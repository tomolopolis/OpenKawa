import 'package:ikawa_app_domain/src/roast_profile_series.dart';
import 'package:test/test.dart';

void main() {
  test('synthetic series has aligned lengths', () {
    final s = RoastProfileSeriesFactory.synthetic(
      durationSec: 600,
      startTemp: 150,
      endTemp: 200,
      coolingSec: 0,
      pointCount: 20,
    );
    expect(s.timeSec.length, 20);
    expect(s.temp.length, 20);
    expect(s.ror.length, 20);
    expect(s.fan.length, 20);
    expect(s.timeSec.first, 0);
    expect(s.timeSec.last, 600);
    expect(s.temp.first, closeTo(150, 0.01));
    expect(s.temp.last, closeTo(200, 0.01));
  });

  test('synthetic preheat plateau then rising temp; RoR non-increasing after preheat', () {
    const pre = 60.0;
    const total = 600.0;
    final s = RoastProfileSeriesFactory.synthetic(
      durationSec: total,
      startTemp: 150,
      endTemp: 200,
      preheatSec: pre,
      coolingSec: 0,
      pointCount: 121,
    );
    final midPreheatIdx = s.timeSec.indexWhere((t) => t >= pre * 0.5);
    expect(s.temp[midPreheatIdx], closeTo(150, 0.5));
    expect(s.timeSec.last, total);

    final iAfter = s.timeSec.indexWhere((t) => t >= pre);
    expect(iAfter, greaterThan(0));
    final iCool = s.timeSec.indexWhere((t) => t > total);
    final endRoast = iCool < 0 ? s.ror.length : iCool;
    for (var i = iAfter + 1; i < endRoast; i++) {
      expect(
        s.ror[i],
        lessThanOrEqualTo(s.ror[i - 1] + 1e-6),
        reason: 'RoR should not increase during roast after preheat at i=$i',
      );
    }
  });

  test('synthetic cooling phase extends timeline and drops temperature', () {
    const roastEnd = 400.0;
    const cool = 90.0;
    final s = RoastProfileSeriesFactory.synthetic(
      durationSec: roastEnd,
      startTemp: 150,
      endTemp: 200,
      preheatSec: 60,
      coolingSec: cool,
      coolEndTemp: 48,
      pointCount: 100,
    );
    expect(s.timeSec.last, closeTo(roastEnd + cool, 0.01));
    final atRoastEnd = s.timeSec.lastIndexWhere((t) => t <= roastEnd + 1e-6);
    expect(s.temp[atRoastEnd], closeTo(200, 1.0));
    expect(s.temp.last, lessThan(80));
    expect(s.ror.any((r) => r < -0.5), isTrue);
    final iCool = s.timeSec.indexWhere((t) => t > roastEnd);
    expect(iCool, greaterThan(0));
    expect(s.fan[iCool], 255);
  });

  test('mismatched lengths throw', () {
    expect(
      () => RoastProfileSeries(timeSec: [0], temp: [1, 2], ror: [1], fan: [1]),
      throwsArgumentError,
    );
  });
}
