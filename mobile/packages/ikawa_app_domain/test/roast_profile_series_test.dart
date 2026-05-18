import 'dart:math' as math;

import 'package:ikawa_app_domain/src/roast_profile_series.dart';
import 'package:test/test.dart';

void main() {
  test('sparseSetpoints allows independent temp and fan times', () {
    final s = RoastProfileSeriesFactory.sparseSetpoints(
      tempTimeSec: const [0, 120, 300, 480, 660],
      temp: const [158, 158, 176, 192, 204],
      fanTimeSec: const [0, 240, 660],
      fan: const [88, 112, 128],
    );
    expect(s.tempTimeSec.length, 5);
    expect(s.fanTimeSec.length, 3);
    expect(s.ror.length, 5);
  });

  test('sparseSetpoints rejects non-increasing temp time', () {
    expect(
      () => RoastProfileSeriesFactory.sparseSetpoints(
        tempTimeSec: const [0, 120, 120],
        temp: const [150, 160, 170],
        fanTimeSec: const [0, 60],
        fan: const [90, 100],
      ),
      throwsArgumentError,
    );
  });

  test('synthetic series has aligned temp and fan times', () {
    final s = RoastProfileSeriesFactory.synthetic(
      durationSec: 600,
      startTemp: 150,
      endTemp: 200,
      coolingSec: 0,
      pointCount: 20,
    );
    expect(s.tempTimeSec.length, 20);
    expect(s.fanTimeSec.length, 20);
    expect(s.temp.length, 20);
    expect(s.fan.length, 20);
    expect(s.tempTimeSec.first, 0);
    expect(s.tempTimeSec.last, 600);
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
    final midPreheatIdx = s.tempTimeSec.indexWhere((t) => t >= pre * 0.5);
    expect(s.temp[midPreheatIdx], closeTo(150, 0.5));
    expect(s.tempTimeSec.last, total);

    final iAfter = s.tempTimeSec.indexWhere((t) => t >= pre);
    expect(iAfter, greaterThan(0));
    final iCool = s.tempTimeSec.indexWhere((t) => t > total);
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
    expect(s.tempTimeSec.last, closeTo(roastEnd + cool, 0.01));
    final atRoastEnd = s.tempTimeSec.lastIndexWhere((t) => t <= roastEnd + 1e-6);
    expect(s.temp[atRoastEnd], closeTo(200, 1.0));
    expect(s.temp.last, lessThan(80));
    expect(s.ror.any((r) => r < -0.5), isTrue);
    final iCool = s.tempTimeSec.indexWhere((t) => t > roastEnd);
    expect(iCool, greaterThan(0));
    expect(s.fan[iCool], 255);
  });

  test('rorDisplayFromTempProfile returns smooth densified curve', () {
    final display = RoastProfileSeriesFactory.rorDisplayFromTempProfile(
      const [0, 120, 300, 480, 660],
      const [158, 158, 176, 192, 204],
      sampleCount: 80,
    );
    expect(display.timeSec.length, 80);
    expect(display.ror.length, display.timeSec.length);
  });

  test('rorDisplayFromTempProfile avoids sharp steps at setpoint corners', () {
    final display = RoastProfileSeriesFactory.rorDisplayFromTempProfile(
      const [0, 60, 120],
      const [150, 150, 210],
      sampleCount: 120,
      windowSec: 40,
    );
    final mid = display.ror.length ~/ 2;
    final maxJump = List.generate(display.ror.length - 1, (i) {
      return (display.ror[i + 1] - display.ror[i]).abs();
    }).reduce(math.max);
    expect(maxJump, lessThan(4.0), reason: 'mid-profile RoR should not stair-step');
    expect(display.ror[mid], greaterThan(0));
  });

  test('copyWith recomputes RoR when temp setpoints change', () {
    final s = RoastProfileSeriesFactory.sparseSetpoints(
      tempTimeSec: const [0, 120, 300, 480, 660],
      temp: const [158, 158, 176, 192, 204],
      fanTimeSec: const [0, 240, 660],
      fan: const [88, 112, 128],
    );
    final before = s.derivedRor;
    final edited = s.copyWith(temp: const [158, 158, 200, 192, 204]);
    expect(edited.derivedRor, isNot(equals(before)));
    expect(edited.ror, equals(edited.derivedRor));
  });

  test('mismatched temp lengths throw', () {
    expect(
      () => RoastProfileSeries(
        tempTimeSec: const [0],
        temp: [1, 2],
        fanTimeSec: const [0, 1],
        fan: const [1, 2],
      ),
      throwsArgumentError,
    );
  });
}
