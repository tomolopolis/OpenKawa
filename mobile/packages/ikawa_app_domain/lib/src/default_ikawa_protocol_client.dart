import 'dart:async';
import 'dart:typed_data';

import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;

class DefaultIkawaProtocolClient implements IkawaProtocolClient {
  DefaultIkawaProtocolClient({
    required this.transport,
    this.timeout = const Duration(seconds: 3),
  });

  final BleTransport transport;
  final Duration timeout;

  final _codec = FrameCodec();
  final _reassembler = FrameReassembler();

  @override
  Future<IkawaResponse> send(IkawaRequest request) async {
    final completer = Completer<Uint8List>();
    late final StreamSubscription<Uint8List> sub;

    sub = transport.notifications().listen((chunk) {
      for (final frame in _reassembler.addChunk(chunk)) {
        if (!completer.isCompleted) {
          completer.complete(_codec.decode(frame));
        }
      }
    });

    try {
      await transport.write(_codec.encode(request.payload), withResponse: true);
      final responsePayload = await completer.future.timeout(timeout);
      final responseProto = pb.IkawaResponse.fromBuffer(responsePayload);
      if (responseProto.seq != request.sequence) {
        throw StateError(
          'Sequence mismatch: request=${request.sequence}, response=${responseProto.seq}',
        );
      }
      return IkawaResponse.fromProto(responseProto);
    } finally {
      await sub.cancel();
    }
  }
}
