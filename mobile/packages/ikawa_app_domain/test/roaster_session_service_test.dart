import 'dart:async';
import 'dart:typed_data';

import 'package:ikawa_app_domain/ikawa_app_domain.dart';
import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;
import 'package:test/test.dart';

void main() {
  test('service defaults to simulator mode', () {
    final service = RoasterSessionService(
      protocolClient: NoopProtocolClient(),
      transport: NoopBleTransport(),
    );
    expect(service.mode, SessionMode.simulator);
  });

  test('sendRawRequest roundtrip works with fake transport', () async {
    final service = RoasterSessionService(
      protocolClient: NoopProtocolClient(),
      transport: NoopBleTransport(),
    );

    final payload = Uint8List.fromList([0x11, 0x22, 0x7D, 0x7E]);
    final response = await service.sendRawRequest(payload);
    expect(response, payload);
  });

  test('sendTypedRequest decodes protobuf response', () async {
    final service = RoasterSessionService(
      protocolClient: NoopProtocolClient(),
      transport: _TypedResponseTransport(),
    );

    final request = pb.Message()
      ..cmdType = 2
      ..seq = 42;
    final response = await service.sendTypedRequest(request);
    expect(response.seq, 42);
  });
}

class _TypedResponseTransport implements BleTransport {
  final _notifications = StreamController<Uint8List>.broadcast();
  final _codec = FrameCodec();

  @override
  Stream<BleDiscoveredDevice> scan({Duration timeout = const Duration(seconds: 5)}) async* {
    yield const BleDiscoveredDevice(id: 'test-device', name: 'Test Device');
  }

  @override
  Future<void> connect(String deviceId) async {}

  @override
  Stream<BleConnectionState> connectionState() async* {
    yield BleConnectionState.connected;
  }

  @override
  Future<void> disconnect() async {}

  @override
  Stream<Uint8List> notifications() => _notifications.stream;

  @override
  Future<void> write(Uint8List bytes, {bool withResponse = true}) async {
    final requestPayload = _codec.decode(bytes);
    final request = pb.Message.fromBuffer(requestPayload);

    final response = pb.IkawaResponse()
      ..seq = request.seq
      ..resp = pb.IkawaResponse_Resp.OK;
    _notifications.add(_codec.encode(Uint8List.fromList(response.writeToBuffer())));
  }
}
