import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;

/// Latest sample from [RespMachStatusGetAll], for overlay on profile charts during a roast.
class LiveRoastTelemetry {
  const LiveRoastTelemetry({
    required this.timeSec,
    required this.beanTempC,
    this.rorCPerMin,
    this.fanSetpoint,
  });

  /// Roaster clock (seconds), same axis as profile series time.
  final double timeSec;
  final double beanTempC;

  /// Combined / primary RoR when firmware exposes above/below probes (display units).
  final double? rorCPerMin;

  /// Fan setpoint (0–255-style); profile fan curves use [RoastProfileSeries.fanTimeSec]/[fan].
  final double? fanSetpoint;

  static LiveRoastTelemetry? fromMachStatus(pb.RespMachStatusGetAll s) {
    double? bean;
    if (s.hasTempAbove()) {
      bean = s.tempAbove.toDouble();
    } else if (s.hasTempBelow()) {
      bean = s.tempBelow.toDouble();
    } else if (s.hasTempAboveFiltered()) {
      bean = s.tempAboveFiltered.toDouble();
    }
    if (bean == null) return null;

    double? ror;
    if (s.hasRorAbove() && s.hasRorBelow()) {
      ror = (s.rorAbove + s.rorBelow) / 2.0;
    } else if (s.hasRorAbove()) {
      ror = s.rorAbove.toDouble();
    } else if (s.hasRorBelow()) {
      ror = s.rorBelow.toDouble();
    }

    return LiveRoastTelemetry(
      timeSec: s.time.toDouble(),
      beanTempC: bean,
      rorCPerMin: ror,
      fanSetpoint: s.hasFan() ? s.fan.toDouble() : null,
    );
  }
}
