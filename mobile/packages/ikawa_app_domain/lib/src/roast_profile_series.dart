import 'dart:math' as math;

/// Roast profile for UI (not wire protobuf). **Temp** and **fan** each have their own
/// time series (Ikawa-style): [tempTimeSec]/[temp] and [fanTimeSec]/[fan] may differ in
/// length and timestamps.
///
/// [ror] is °C/min-style, aligned with [temp] samples only (derived unless [synthetic]
/// passes a smoothed override).
class RoastProfileSeries {
  RoastProfileSeries({
    required List<double> tempTimeSec,
    required List<double> temp,
    required List<double> fanTimeSec,
    required List<double> fan,
    List<double>? rorAtTempPoints,
  })  : tempTimeSec = List.unmodifiable(tempTimeSec),
        temp = List.unmodifiable(temp),
        fanTimeSec = List.unmodifiable(fanTimeSec),
        fan = List.unmodifiable(fan),
        ror = List.unmodifiable(
          rorAtTempPoints ?? RoastProfileSeriesFactory.rorFromTempSeries(tempTimeSec, temp),
        ) {
    if (tempTimeSec.length != temp.length) {
      throw ArgumentError('tempTimeSec and temp must have equal length');
    }
    if (fanTimeSec.length != fan.length) {
      throw ArgumentError('fanTimeSec and fan must have equal length');
    }
    if (temp.length != ror.length) {
      throw ArgumentError('ror must align with temp (${temp.length} vs ${ror.length})');
    }
    if (tempTimeSec.isEmpty || fanTimeSec.isEmpty) {
      throw ArgumentError('Temp and fan series must be non-empty');
    }
    _assertStrictlyIncreasing(tempTimeSec, 'tempTimeSec');
    _assertStrictlyIncreasing(fanTimeSec, 'fanTimeSec');
  }

  final List<double> tempTimeSec;
  final List<double> temp;
  final List<double> fanTimeSec;
  final List<double> fan;
  final List<double> ror;

  double get timelineStartSec => math.min(tempTimeSec.first, fanTimeSec.first);
  double get timelineEndSec => math.max(tempTimeSec.last, fanTimeSec.last);
  double get durationSec => timelineEndSec - timelineStartSec;

  /// RoR (°C/min) from current [temp] / [tempTimeSec] (always matches the BT curve).
  List<double> get derivedRor =>
      RoastProfileSeriesFactory.rorFromTempSeries(tempTimeSec, temp);

  /// After editing temp/fan setpoints, returns a new series with [ror] recomputed from BT.
  RoastProfileSeries copyWith({
    List<double>? tempTimeSec,
    List<double>? temp,
    List<double>? fanTimeSec,
    List<double>? fan,
  }) {
    return RoastProfileSeries(
      tempTimeSec: tempTimeSec ?? List<double>.from(this.tempTimeSec),
      temp: temp ?? List<double>.from(this.temp),
      fanTimeSec: fanTimeSec ?? List<double>.from(this.fanTimeSec),
      fan: fan ?? List<double>.from(this.fan),
    );
  }

  static void _assertStrictlyIncreasing(List<double> t, String name) {
    for (var i = 1; i < t.length; i++) {
      if (t[i] <= t[i - 1]) {
        throw ArgumentError('$name must be strictly increasing');
      }
    }
  }
}

/// Builds plausible demo curves for catalog entries until real profile payloads exist.
final class RoastProfileSeriesFactory {
  RoastProfileSeriesFactory._();

  /// Sparse profile with **independent** temp and fan times (typical Ikawa Home / protobuf shape).
  static RoastProfileSeries sparseSetpoints({
    required List<double> tempTimeSec,
    required List<double> temp,
    required List<double> fanTimeSec,
    required List<double> fan,
  }) {
    if (tempTimeSec.length != temp.length ||
        fanTimeSec.length != fan.length ||
        temp.length < 2 ||
        fan.length < 2) {
      throw ArgumentError('Need at least two temp and two fan setpoints, aligned lengths');
    }
    return RoastProfileSeries(
      tempTimeSec: List<double>.from(tempTimeSec),
      temp: List<double>.from(temp),
      fanTimeSec: List<double>.from(fanTimeSec),
      fan: List<double>.from(fan),
    );
  }

  /// Convenience: same timestamps for every temp and fan row (legacy app behavior).
  static RoastProfileSeries sparseSetpointsAligned({
    required List<double> timeSec,
    required List<double> temp,
    required List<double> fan,
  }) {
    return sparseSetpoints(
      tempTimeSec: timeSec,
      temp: temp,
      fanTimeSec: timeSec,
      fan: fan,
    );
  }

  /// [durationSec] is time from 0 to **end of roast** (preheat + roast; [endTemp] at this time).
  /// [coolingSec] appends fan cooling: temperature decays toward [coolEndTemp]. Total timeline
  /// is `durationSec + coolingSec`.
  ///
  /// Uses one shared time grid for temp and fan (dense synthetic demo).
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
    const k = 3.0;

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

    return RoastProfileSeries(
      tempTimeSec: t,
      temp: temp,
      fanTimeSec: List<double>.from(t),
      fan: fan,
      rorAtTempPoints: ror,
    );
  }

  /// Smooth RoR trace for charts (Artisan-style): interpolate BT, smooth it, then
  /// °C/min over a **time window** so setpoint corners do not produce step RoR.
  static ({List<double> timeSec, List<double> ror}) rorDisplayFromTempProfile(
    List<double> tempTimeSec,
    List<double> temp, {
    int sampleCount = 280,
    double windowSec = 45.0,
    int btSmoothPasses = 6,
    int rorSmoothPasses = 8,
  }) {
    if (tempTimeSec.length != temp.length || tempTimeSec.isEmpty) {
      return (timeSec: const [], ror: const []);
    }
    if (tempTimeSec.length == 1) {
      return (timeSec: List<double>.from(tempTimeSec), ror: const [0]);
    }

    final t0 = tempTimeSec.first;
    final t1 = tempTimeSec.last;
    final duration = t1 - t0;
    if (duration <= 0) {
      return (timeSec: List<double>.from(tempTimeSec), ror: const [0, 0]);
    }

    final n = math.max(32, sampleCount);
    final denseT = List<double>.generate(n, (i) => t0 + duration * i / (n - 1));
    var denseTemp = List<double>.generate(
      n,
      (i) => _interpTempAt(tempTimeSec, temp, denseT[i]),
    );
    if (btSmoothPasses > 0 && denseTemp.length >= 5) {
      denseTemp = _smoothDisplay(denseTemp, btSmoothPasses);
    }

    final window = math.min(windowSec, math.max(18.0, duration * 0.15));
    final ror = List<double>.filled(n, 0);
    for (var i = 0; i < n; i++) {
      final tEnd = denseT[i];
      final tStart = math.max(t0, tEnd - window);
      final dt = tEnd - tStart;
      if (dt < 1.0) {
        ror[i] = i > 0 ? ror[i - 1] : 0;
        continue;
      }
      final btEnd = denseTemp[i];
      final btStart = _interpTempAt(denseT, denseTemp, tStart);
      ror[i] = (btEnd - btStart) / dt * 60;
    }

    var smoothRor = ror;
    if (rorSmoothPasses > 0 && smoothRor.length >= 5) {
      smoothRor = _smoothDisplay(smoothRor, rorSmoothPasses);
    }

    return (timeSec: denseT, ror: smoothRor);
  }

  /// Linear BT (°C) on a piecewise-linear profile at [t] seconds.
  static double _interpTempAt(List<double> timeSec, List<double> temp, double t) {
    if (t <= timeSec.first) return temp.first;
    if (t >= timeSec.last) return temp.last;
    for (var i = 1; i < timeSec.length; i++) {
      if (t <= timeSec[i]) {
        final dt = timeSec[i] - timeSec[i - 1];
        if (dt <= 0) return temp[i];
        final u = (t - timeSec[i - 1]) / dt;
        return temp[i - 1] + u * (temp[i] - temp[i - 1]);
      }
    }
    return temp.last;
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

  static int _firstStrictlyAfter(List<double> t, double sec) {
    const eps = 1e-9;
    for (var i = 0; i < t.length; i++) {
      if (t[i] > sec + eps) return i;
    }
    return t.length;
  }

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

  /// Wider kernel than [_smooth3]; repeated for display RoR.
  static List<double> _smooth5(List<double> v) {
    if (v.length < 5) return _smooth3(v);
    final out = List<double>.filled(v.length, 0);
    out[0] = v[0];
    out[1] = (v[0] + v[1] + v[2]) / 3;
    for (var i = 2; i < v.length - 2; i++) {
      out[i] = (v[i - 2] + v[i - 1] + v[i] + v[i + 1] + v[i + 2]) / 5;
    }
    out[v.length - 2] = (v[v.length - 3] + v[v.length - 2] + v[v.length - 1]) / 3;
    out[v.length - 1] = v[v.length - 1];
    return out;
  }

  static List<double> _smoothDisplay(List<double> v, int passes) {
    var out = List<double>.from(v);
    for (var p = 0; p < passes; p++) {
      out = _smooth5(out);
    }
    return out;
  }
}
