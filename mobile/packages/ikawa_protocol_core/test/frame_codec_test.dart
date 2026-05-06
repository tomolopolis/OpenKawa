import 'dart:typed_data';

import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:test/test.dart';

void main() {
  final codec = FrameCodec();

  test('encode/decode roundtrip', () {
    final payload = Uint8List.fromList([0x01, 0x7D, 0x7E, 0x02]);
    final framed = codec.encode(payload);
    final decoded = codec.decode(framed);
    expect(decoded, payload);
  });

  test('decode throws on invalid boundaries', () {
    final notFramed = Uint8List.fromList([0x01, 0x02, 0x03]);
    expect(() => codec.decode(notFramed), throwsFormatException);
  });
}
