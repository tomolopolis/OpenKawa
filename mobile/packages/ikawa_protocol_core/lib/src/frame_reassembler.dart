import 'dart:typed_data';

import 'frame_codec.dart';

/// Reassembles framed packets from arbitrary notification chunk boundaries.
class FrameReassembler {
  final _buffer = <int>[];

  List<Uint8List> addChunk(Uint8List chunk) {
    _buffer.addAll(chunk);
    final frames = <Uint8List>[];

    while (true) {
      final start = _buffer.indexOf(FrameCodec.frameBoundary);
      if (start < 0) {
        _buffer.clear();
        break;
      }
      if (start > 0) {
        _buffer.removeRange(0, start);
      }

      final endRelative = _buffer.sublist(1).indexOf(FrameCodec.frameBoundary);
      if (endRelative < 0) {
        break;
      }
      final end = endRelative + 1;
      final frame = Uint8List.fromList(_buffer.sublist(0, end + 1));
      frames.add(frame);
      _buffer.removeRange(0, end + 1);
    }

    return frames;
  }

  void reset() => _buffer.clear();
}
