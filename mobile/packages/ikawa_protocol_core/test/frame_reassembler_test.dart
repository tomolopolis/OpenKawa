import 'dart:typed_data';

import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:test/test.dart';

void main() {
  test('reassembles frame from multiple chunks', () {
    final codec = FrameCodec();
    final reassembler = FrameReassembler();
    final frame = codec.encode(Uint8List.fromList([0x01, 0x02, 0x03]));

    final first = Uint8List.fromList(frame.sublist(0, 2));
    final second = Uint8List.fromList(frame.sublist(2));

    expect(reassembler.addChunk(first), isEmpty);
    final complete = reassembler.addChunk(second);
    expect(complete.length, 1);
    expect(codec.decode(complete.first), Uint8List.fromList([0x01, 0x02, 0x03]));
  });

  test('extracts two frames from one chunk', () {
    final codec = FrameCodec();
    final reassembler = FrameReassembler();
    final a = codec.encode(Uint8List.fromList([0x10]));
    final b = codec.encode(Uint8List.fromList([0x20]));
    final chunk = Uint8List.fromList([...a, ...b]);

    final frames = reassembler.addChunk(chunk);
    expect(frames.length, 2);
    expect(codec.decode(frames[0]), Uint8List.fromList([0x10]));
    expect(codec.decode(frames[1]), Uint8List.fromList([0x20]));
  });
}
