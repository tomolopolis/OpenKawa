import 'dart:typed_data';

import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';
import 'package:test/test.dart';

void main() {
  test('crc16 returns expected bytes for known input', () {
    final input = Uint8List.fromList([0x01, 0x02, 0x03, 0x04]);
    final crc = crc16(input);
    expect(crc, Uint8List.fromList([0xC6, 0x6E]));
  });

  test('crc16 supports alternate seed', () {
    final input = Uint8List.fromList([0x10, 0x20]);
    final crc = crc16(input, seed: 0xAAAA);
    expect(crc, Uint8List.fromList([0xEC, 0x4C]));
  });
}
