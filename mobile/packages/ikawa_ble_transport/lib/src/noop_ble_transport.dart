import 'dart:async';
import 'dart:typed_data';

import 'ble_transport.dart';

class NoopBleTransport implements BleTransport {
  final _notifications = StreamController<Uint8List>.broadcast();
  final _connection = StreamController<BleConnectionState>.broadcast();

  NoopBleTransport() {
    _connection.add(BleConnectionState.disconnected);
  }

  @override
  Stream<BleDiscoveredDevice> scan({Duration timeout = const Duration(seconds: 5)}) async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield const BleDiscoveredDevice(
      id: 'sim-ikawa-001',
      name: 'IKAWA Simulator',
    );
  }

  @override
  Future<void> connect(String deviceId) async {
    if (deviceId.isEmpty) {
      throw ArgumentError.value(deviceId, 'deviceId', 'Cannot be empty');
    }
    _connection.add(BleConnectionState.connecting);
    _connection.add(BleConnectionState.connected);
  }

  @override
  Future<void> disconnect() async {
    _connection.add(BleConnectionState.disconnected);
  }

  @override
  Stream<BleConnectionState> connectionState() => _connection.stream;

  @override
  Stream<Uint8List> notifications() => _notifications.stream;

  @override
  Future<void> write(Uint8List bytes, {bool withResponse = true}) async {
    // Loopback mode for early app/domain integration tests.
    _notifications.add(bytes);
  }
}
