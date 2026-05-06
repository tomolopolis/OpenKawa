import 'dart:typed_data';

class PacketLogEntry {
  PacketLogEntry({
    required this.timestamp,
    required this.direction,
    required this.bytes,
  });

  final DateTime timestamp;
  final String direction;
  final Uint8List bytes;
}
