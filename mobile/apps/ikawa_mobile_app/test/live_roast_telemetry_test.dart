import 'package:flutter_test/flutter_test.dart';
import 'package:ikawa_mobile_app/src/live_roast_telemetry.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;

void main() {
  test('maps telemetry from above probe and average ror', () {
    final status = pb.RespMachStatusGetAll()
      ..time = 42
      ..tempAbove = 180
      ..fan = 128
      ..rorAbove = 12
      ..rorBelow = 10;

    final telemetry = LiveRoastTelemetry.fromMachStatus(status);

    expect(telemetry, isNotNull);
    expect(telemetry!.timeSec, 42);
    expect(telemetry.beanTempC, 180);
    expect(telemetry.fanSetpoint, 128);
    expect(telemetry.rorCPerMin, 11);
  });

  test('returns null when no bean temperature exists', () {
    final status = pb.RespMachStatusGetAll()..time = 10;
    expect(LiveRoastTelemetry.fromMachStatus(status), isNull);
  });
}
