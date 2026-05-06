import 'dart:async';
import 'dart:typed_data';

import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;

enum SessionMode { simulator, realBle }

class RoasterSessionService {
  RoasterSessionService({
    required this.protocolClient,
    required this.transport,
    this.mode = SessionMode.simulator,
  });

  final IkawaProtocolClient protocolClient;
  final BleTransport transport;
  final SessionMode mode;

  final _codec = FrameCodec();
  final _reassembler = FrameReassembler();

  Future<Uint8List> sendRawRequest(
    Uint8List payload, {
    Duration timeout = const Duration(seconds: 3),
    bool withResponse = true,
  }) async {
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
      await transport.write(_codec.encode(payload), withResponse: withResponse);
      return await completer.future.timeout(timeout);
    } finally {
      await sub.cancel();
    }
  }

  Future<pb.IkawaResponse> sendTypedRequest(
    pb.Message request, {
    bool withResponse = true,
  }) async {
    if (!withResponse) {
      throw UnsupportedError('sendTypedRequest requires withResponse=true');
    }
    final typed = await protocolClient.sendTyped(request);
    if (typed.seq != request.seq) {
      throw StateError(
        'Typed response sequence mismatch: request=${request.seq}, response=${typed.seq}',
      );
    }
    return typed;
  }
}
