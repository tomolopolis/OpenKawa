import 'roast_profile_series.dart';

class RoastProfileValidationIssue {
  const RoastProfileValidationIssue(this.message);
  final String message;
}

class RoastProfileValidator {
  const RoastProfileValidator({
    this.maxDeltaTempPerMinute = 45,
    this.maxFanStep = 80,
  });

  final double maxDeltaTempPerMinute;
  final double maxFanStep;

  List<RoastProfileValidationIssue> validate(RoastProfileSeries series) {
    final issues = <RoastProfileValidationIssue>[];
    final tt = series.tempTimeSec;
    final temp = series.temp;
    for (var i = 1; i < tt.length; i++) {
      final dt = tt[i] - tt[i - 1];
      if (dt <= 0) {
        issues.add(const RoastProfileValidationIssue('Temp time points must increase.'));
        continue;
      }
      final dTempPerMin = (temp[i] - temp[i - 1]) / dt * 60;
      if (dTempPerMin.abs() > maxDeltaTempPerMinute) {
        issues.add(
          RoastProfileValidationIssue(
            'Temp ramp too steep at ${tt[i].round()}s (${dTempPerMin.toStringAsFixed(1)} C/min).',
          ),
        );
      }
    }

    final ft = series.fanTimeSec;
    final fan = series.fan;
    for (var i = 1; i < ft.length; i++) {
      final dt = ft[i] - ft[i - 1];
      if (dt <= 0) {
        issues.add(const RoastProfileValidationIssue('Fan time points must increase.'));
        continue;
      }
      final dFan = (fan[i] - fan[i - 1]).abs();
      if (dFan > maxFanStep) {
        issues.add(
          RoastProfileValidationIssue(
            'Fan step too abrupt at ${ft[i].round()}s (delta ${dFan.toStringAsFixed(0)}).',
          ),
        );
      }
    }
    return issues;
  }
}
