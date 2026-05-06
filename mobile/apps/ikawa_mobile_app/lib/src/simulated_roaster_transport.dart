import 'dart:async';
import 'dart:typed_data';

import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;

class SimulatedRoasterTransport implements BleTransport {
  final _notifications = StreamController<Uint8List>.broadcast();
  final _connection = StreamController<BleConnectionState>.broadcast();
  final _codec = FrameCodec();
  int _simTimeSeconds = 0;
  int _simTempAbove = 130;
  int _simTempBelow = 110;

  SimulatedRoasterTransport() {
    _connection.add(BleConnectionState.disconnected);
  }

  @override
  Stream<BleDiscoveredDevice> scan({Duration timeout = const Duration(seconds: 5)}) async* {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    yield const BleDiscoveredDevice(
      id: 'sim-ikawa-001',
      name: 'IKAWA Simulator',
    );
  }

  @override
  Future<void> connect(String deviceId) async {
    _connection.add(BleConnectionState.connecting);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _connection.add(BleConnectionState.connected);
  }

  @override
  Stream<BleConnectionState> connectionState() => _connection.stream;

  @override
  Future<void> disconnect() async {
    _connection.add(BleConnectionState.disconnected);
  }

  @override
  Stream<Uint8List> notifications() => _notifications.stream;

  @override
  Future<void> write(Uint8List bytes, {bool withResponse = true}) async {
    final payload = _codec.decode(bytes);
    final request = pb.Message.fromBuffer(payload);

    final response = pb.IkawaResponse()
      ..seq = request.seq
      ..resp = pb.IkawaResponse_Resp.OK;

    if (request.cmdType == 0) {
      final version = response.ensureRespBootloaderGetVersion();
      response.resp = pb.IkawaResponse_Resp.BOOTLOADER_GET_VERSION;
      version
        ..version = 25
        ..revision = 'sim-17-g1925dbd';
    } else if (request.cmdType == 2) {
      final machType = response.ensureRespMachPropType();
      response.resp = pb.IkawaResponse_Resp.MACH_PROP_TYPE;
      machType
        ..type = 3
        ..variant = 0;
    } else if (request.cmdType == 3) {
      final machId = response.ensureRespMachId();
      response.resp = pb.IkawaResponse_Resp.MACH_ID;
      machId.id = 800368;
    } else if (request.cmdType == 11) {
      _simTimeSeconds += 2;
      _simTempAbove += 1;
      _simTempBelow += 1;
      final status = response.ensureRespMachStatusGetAll();
      response.resp = pb.IkawaResponse_Resp.MACH_STATUS_GET_ALL;
      status
        ..time = _simTimeSeconds
        ..tempAbove = _simTempAbove
        ..fan = 127
        ..state = 2
        ..heater = 35
        ..p = 10
        ..i = 2
        ..d = 1
        ..setpoint = 180
        ..fanMeasured = 124
        ..tempBelow = _simTempBelow
        ..rorAbove = 14 + (_simTimeSeconds % 5)
        ..rorBelow = 12 + (_simTimeSeconds % 4);
    } else if (request.cmdType == 13) {
      final roasts = response.ensureRespHistGetTotalRoastCount();
      response.resp = pb.IkawaResponse_Resp.HIST_GET_TOTAL_ROAST_COUNT;
      roasts.totalRoastCount = 5;
    } else if (request.cmdType == 23) {
      final support = response.ensureRespMachPropGetSupportInfo();
      response.resp = pb.IkawaResponse_Resp.MACH_PROP_GET_SUPPORT_INFO;
      support.profileSchema = 2;
    } else if (request.cmdType == 15) {
      // PROFILE_GET — matches Python `IkawaEmulatedRoaster.PROFILE_GET`.
      final profileGet = response.ensureRespProfileGet();
      response.resp = pb.IkawaResponse_Resp.PROFILE_GET;
      final prof = profileGet.ensureProfile();
      prof
        ..schema = 2
        ..name = 'Simulator · City Roast'
        ..coffeeName = 'Yirgacheffe (sim)'
        ..profileType = 'simulator'
        ..tempSensor = 0;
      prof.tempPoints
        ..clear()
        ..addAll([
          pb.TempPoint()..time = 0..temp = 150,
          pb.TempPoint()..time = 120..temp = 198,
          pb.TempPoint()..time = 360..temp = 215,
        ]);
      prof.fanPoints
        ..clear()
        ..addAll([
          pb.FanPoint()..time = 0..power = 50,
          pb.FanPoint()..time = 180..power = 45,
        ]);
      prof.id.addAll([0x01, 0x23, 0x45, 0x67, 0x89, 0xab]);
    }

    _notifications.add(_codec.encode(Uint8List.fromList(response.writeToBuffer())));
  }
}
