import 'dart:typed_data';

/// Matches the algorithm currently used in the Python reference implementation.
Uint8List crc16(Uint8List input, {int seed = 0xFFFF}) {
  var crc = seed;
  for (final byte in input) {
    final i3 = (byte & 0xFF) ^ (crc & 0xFF);
    final i4 = i3 ^ ((i3 << 4) & 0xFF);
    crc = ((((crc >> 8) & 0xFF) | ((i4 << 8) & 0xFFFF)) ^
            (i4 >> 4) ^
            ((i4 << 3) & 0xFFFF)) &
        0xFFFF;
  }
  return Uint8List.fromList([(crc >> 8) & 0xFF, crc & 0xFF]);
}
