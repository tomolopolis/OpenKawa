import 'dart:typed_data';

import 'crc16.dart';

class FrameCodec {
  static const int frameBoundary = 0x7E;
  static const int escapeByte = 0x7D;
  static const int escaped7D = 0x5D;
  static const int escaped7E = 0x5E;

  Uint8List encode(Uint8List payload) {
    final withCrc = Uint8List.fromList([...payload, ...crc16(payload)]);
    final escaped = <int>[];
    for (final b in withCrc) {
      if (b == escapeByte) {
        escaped.addAll([escapeByte, escaped7D]);
      } else if (b == frameBoundary) {
        escaped.addAll([escapeByte, escaped7E]);
      } else {
        escaped.add(b);
      }
    }
    return Uint8List.fromList([frameBoundary, ...escaped, frameBoundary]);
  }

  Uint8List decode(Uint8List framed) {
    if (framed.length < 4 ||
        framed.first != frameBoundary ||
        framed.last != frameBoundary) {
      throw const FormatException('Invalid frame boundaries');
    }

    final body = framed.sublist(1, framed.length - 1);
    final unescaped = <int>[];
    for (var i = 0; i < body.length; i++) {
      final b = body[i];
      if (b == escapeByte) {
        if (i + 1 >= body.length) {
          throw const FormatException('Invalid trailing escape byte');
        }
        final next = body[++i];
        if (next == escaped7D) {
          unescaped.add(escapeByte);
        } else if (next == escaped7E) {
          unescaped.add(frameBoundary);
        } else {
          throw const FormatException('Invalid escaped byte sequence');
        }
      } else {
        unescaped.add(b);
      }
    }

    if (unescaped.length < 3) {
      throw const FormatException('Frame payload too short');
    }

    final payload = Uint8List.fromList(unescaped.sublist(0, unescaped.length - 2));
    final recvCrc = Uint8List.fromList(unescaped.sublist(unescaped.length - 2));
    final calcCrc = crc16(payload);
    if (recvCrc[0] != calcCrc[0] || recvCrc[1] != calcCrc[1]) {
      throw const FormatException('CRC mismatch');
    }

    return payload;
  }
}
