import 'models.dart';
import 'gen/ikawa.pb.dart' as pb;

abstract class IkawaProtocolClient {
  Future<IkawaResponse> send(IkawaRequest request);
}

extension IkawaProtocolClientTyped on IkawaProtocolClient {
  Future<pb.IkawaResponse> sendTyped(pb.Message request) async {
    final rawResponse = await send(IkawaRequest.fromProto(request));
    return rawResponse.toProto();
  }
}

class NoopProtocolClient implements IkawaProtocolClient {
  @override
  Future<IkawaResponse> send(IkawaRequest request) async {
    // Echo request sequence in a placeholder OK response for early integration.
    final requestProto = request.toProto();
    final responseProto = pb.IkawaResponse()
      ..seq = requestProto.seq
      ..resp = pb.IkawaResponse_Resp.OK;
    return IkawaResponse.fromProto(responseProto);
  }
}
