import 'dart:typed_data';

import 'gen/ikawa.pb.dart' as pb;

class IkawaRequest {
  IkawaRequest({
    required this.sequence,
    required this.payload,
  });

  final int sequence;
  final Uint8List payload;

  factory IkawaRequest.fromProto(pb.Message message) {
    return IkawaRequest(
      sequence: message.seq,
      payload: Uint8List.fromList(message.writeToBuffer()),
    );
  }

  pb.Message toProto() => pb.Message.fromBuffer(payload);
}

class IkawaResponse {
  IkawaResponse({
    required this.sequence,
    required this.payload,
  });

  final int sequence;
  final Uint8List payload;

  factory IkawaResponse.fromProto(pb.IkawaResponse response) {
    return IkawaResponse(
      sequence: response.seq,
      payload: Uint8List.fromList(response.writeToBuffer()),
    );
  }

  pb.IkawaResponse toProto() => pb.IkawaResponse.fromBuffer(payload);
}
