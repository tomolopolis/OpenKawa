import 'dart:math' as math;

/// Time-aligned profile curves for UI (not wire protobuf). Units are display-only:
/// [timeSec] seconds, [temp] bean temperature (°C-style), [ror] rate of rise (°C/min-style),
/// [fan] setpoint in the same 0–255-style range as firmware fan fields.
///
/// Ikawa-style timelines often include a short **preheat** segment (~1 min) at charge temperature
/// before the programmed roast curve; RoR is derived from the temperature samples.
/// After the roast target is reached, an optional **cooling** segment models fan-only cooldown
/// until a safe eject temperature.
class RoastProfileSeries {
  RoastProfileSeries({
    required List<double> timeSec,
    required List<double> temp,
    required List<double> ror,
    required List<double> fan,
  })  : timeSec = List.unmodifiable(timeSec),
        temp = List.unmodifiable(temp),
        ror = List.unmodifiable(ror),
        fan = List.unmodifiable(fan) {
    if (timeSec.length != temp.length ||
        temp.length != ror.length ||
        ror.length != fan.length) {
      throw ArgumentError('timeSec, temp, ror, and fan must have equal length');
    }
    if (timeSec.isEmpty) {
      throw ArgumentError('Series must not be empty');
    }
  }

  final List<double> timeSec;
  final List<double> temp;
  final List<double> ror;
  final List<double> fan;

  double get durationSec => timeSec.last - timeSec.first;
}

/// Builds plausible demo curves for catalog entries until real profile payloads exist.
final class RoastProfileSeriesFactory {
  RoastProfileSeriesFactory._();

  /// [durationSec] is time from 0 to **end of roast** (preheat + roast; [endTemp] at this time).
  /// [coolingSec] appends fan cooling: temperature decays toward [coolEndTemp]. Total timeline
  /// is `durationSec + coolingSec`.
  ///
  /// RoR is °C/min from consecutive [temp] samples, smoothed lightly, then **non-increasing**
  /// only during the roast phase (not during cooling, where RoR is negative).
  static RoastProfileSeries synthetic({
    required double durationSec,
    required double startTemp,
    required double endTemp,
    double preheatSec = 60,
    double coolingSec = 120,
    double coolEndTemp = 50,
    int pointCount = 72,
  }) {
    final n = math.max(8, pointCount);
    if (durationSec <= 0) {
      throw ArgumentError.value(durationSec, 'durationSec', 'must be positive');
    }
    final cool = math.max(0.0, coolingSec);
    final total = durationSec + cool;
    final maxPreheat = math.max(0.0, durationSec - 30.0);
    final pre = math.min(preheatSec, maxPreheat).clamp(0.0, maxPreheat).toDouble();
    final roastSpan = durationSec - pre;
    const k = 3.0; // higher → more rise early; keeps RoR falling through the roast

    final t = List<double>.generate(n, (i) => total * i / (n - 1));
    final temp = List<double>.generate(n, (i) {
      final ti = t[i];
      if (ti <= pre || roastSpan <= 0) return startTemp;
      if (ti <= durationSec) {
        final u = ((ti - pre) / roastSpan).clamp(0.0, 1.0).toDouble();
        final mix = (1 - math.exp(-k * u)) / (1 - math.exp(-k));
        return startTemp + (endTemp - startTemp) * mix;
      }
      final coolSpan = total - durationSec;
      if (coolSpan <= 0) return endTemp;
      final v = ((ti - durationSec) / coolSpan).clamp(0.0, 1.0).toDouble();
      final decay = math.exp(-4.0 * v);
      return coolEndTemp + (endTemp - coolEndTemp) * decay;
    });

    final rawRor = rorFromTempSeries(t, temp);
    final smoothed = _smooth3(rawRor);
    final i0 = _firstIndexAtOrAfter(t, pre);
    final iCool = _firstStrictlyAfter(t, durationSec);
    final ror = _enforceNonIncreasingOnRange(smoothed, i0, iCool);

    final fan = List<double>.generate(n, (i) {
      final ti = t[i];
      if (ti <= pre || roastSpan <= 0) return 92;
      if (ti <= durationSec) {
        final u = ((ti - pre) / roastSpan).clamp(0.0, 1.0).toDouble();
        return 92 + 40 * u;
      }
      return 255;
    });

    return RoastProfileSeries(timeSec: t, temp: temp, ror: ror, fan: fan);
  }

  /// Rate of rise (°C/min) from paired [timeSec] and [temp] samples (secant between points).
  static List<double> rorFromTempSeries(List<double> timeSec, List<double> temp) {
    final n = timeSec.length;
    if (n != temp.length) {
      throw ArgumentError('timeSec and temp must have equal length');
    }
    if (n == 0) return [];
    final out = List<double>.filled(n, 0);
    for (var i = 1; i < n; i++) {
      final dt = timeSec[i] - timeSec[i - 1];
      if (dt <= 0) continue;
      out[i] = (temp[i] - temp[i - 1]) / dt * 60;
    }
    out[0] = out.length > 1 ? out[1] : 0;
    return out;
  }

  static int _firstIndexAtOrAfter(List<double> t, num sec) {
    for (var i = 0; i < t.length; i++) {
      if (t[i] >= sec) return i;
    }
    return t.length - 1;
  }

  /// First index with `t[i] > sec` (roast phase uses `sec == durationSec`); [t.length] if none.
  static int _firstStrictlyAfter(List<double> t, double sec) {
    const eps = 1e-9;
    for (var i = 0; i < t.length; i++) {
      if (t[i] > sec + eps) return i;
    }
    return t.length;
  }

  /// BT-style roast phase: RoR does not increase on `[startIndex, endExclusive)`.
  static List<double> _enforceNonIncreasingOnRange(
    List<double> ror,
    int startIndex,
    int endExclusive,
  ) {
    if (ror.isEmpty || startIndex >= ror.length) return List<double>.from(ror);
    final end = math.min(endExclusive, ror.length);
    if (startIndex + 1 >= end) return List<double>.from(ror);
    final out = List<double>.from(ror);
    for (var i = startIndex + 1; i < end; i++) {
      if (out[i] > out[i - 1]) out[i] = out[i - 1];
    }
    return out;
  }

  static List<double> _smooth3(List<double> v) {
    if (v.length < 3) return List<double>.from(v);
    final out = List<double>.filled(v.length, 0);
    out[0] = v[0];
    for (var i = 1; i < v.length - 1; i++) {
      out[i] = (v[i - 1] + v[i] + v[i + 1]) / 3;
    }
    out[v.length - 1] = v[v.length - 1];
    return out;
  }
}
