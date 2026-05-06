import 'dart:typed_data';

enum BleConnectionState {
  disconnected,
  connecting,
  connected,
}

class BleTransportException implements Exception {
  const BleTransportException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BleDiscoveredDevice {
  const BleDiscoveredDevice({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

abstract class BleTransport {
  Stream<BleDiscoveredDevice> scan({Duration timeout = const Duration(seconds: 5)});
  Future<void> connect(String deviceId);
  Future<void> disconnect();
  Future<void> write(Uint8List bytes, {bool withResponse = true});
  Stream<Uint8List> notifications();
  Stream<BleConnectionState> connectionState();
}
