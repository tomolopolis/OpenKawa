import 'dart:async';
import 'dart:typed_data';

import 'package:ikawa_app_domain/ikawa_app_domain.dart';
import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;
import 'package:test/test.dart';

void main() {
  test('returns typed response with matching sequence', () async {
    final client = DefaultIkawaProtocolClient(
      transport: _RoundTripTransport(),
      timeout: const Duration(milliseconds: 500),
    );

    final req = pb.Message()
      ..cmdType = 2
      ..seq = 7;
    final response = await client.sendTyped(req);

    expect(response.seq, 7);
    expect(response.resp, pb.IkawaResponse_Resp.OK);
  });

  test('throws on sequence mismatch', () async {
    final client = DefaultIkawaProtocolClient(
      transport: _RoundTripTransport(forceSequence: 99),
      timeout: const Duration(milliseconds: 500),
    );

    final req = pb.Message()
      ..cmdType = 2
      ..seq = 7;

    await expectLater(
      () => client.sendTyped(req),
      throwsA(isA<StateError>()),
    );
  });
}

class _RoundTripTransport implements BleTransport {
  _RoundTripTransport({this.forceSequence});

  final int? forceSequence;
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
    final payload = _codec.decode(bytes);
    final request = pb.Message.fromBuffer(payload);

    final response = pb.IkawaResponse()
      ..seq = forceSequence ?? request.seq
      ..resp = pb.IkawaResponse_Resp.OK;
    _notifications.add(_codec.encode(Uint8List.fromList(response.writeToBuffer())));
  }
}
