import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'ble_transport.dart';
import 'ikawa_ble_ids.dart';

class ReactiveBleTransport implements BleTransport {
  ReactiveBleTransport({
    FlutterReactiveBle? ble,
    this.serviceId = IkawaBleIds.service,
    this.notifyCharacteristicId = IkawaBleIds.notifyCharacteristic,
    this.writeCharacteristicId = IkawaBleIds.writeCharacteristic,
  }) : _ble = ble ?? FlutterReactiveBle();

  final FlutterReactiveBle _ble;
  final String serviceId;
  final String notifyCharacteristicId;
  final String writeCharacteristicId;

  final _notifications = StreamController<Uint8List>.broadcast();
  final _connection = StreamController<BleConnectionState>.broadcast();

  StreamSubscription<ConnectionStateUpdate>? _connectionSub;
  StreamSubscription<List<int>>? _notifySub;
  QualifiedCharacteristic? _notifyCharacteristic;
  QualifiedCharacteristic? _writeCharacteristic;

  Future<void> _ensureBleReady() async {
    final status = await _ble.statusStream.first;
    if (status == BleStatus.ready) return;
    switch (status) {
      case BleStatus.poweredOff:
        throw const BleTransportException(
          'Bluetooth is powered off. Turn Bluetooth on and retry.',
        );
      case BleStatus.locationServicesDisabled:
        throw const BleTransportException(
          'Location services are disabled. Enable location services for BLE scanning.',
        );
      case BleStatus.unauthorized:
        throw const BleTransportException(
          'Bluetooth permission denied. Grant Bluetooth permissions in system settings.',
        );
      case BleStatus.unsupported:
        throw const BleTransportException(
          'Bluetooth LE is not supported on this device.',
        );
      case BleStatus.ready:
        return;
      default:
        throw BleTransportException('Bluetooth is not ready: $status');
    }
  }

  @override
  Stream<BleDiscoveredDevice> scan({Duration timeout = const Duration(seconds: 5)}) {
    final stream = Stream.fromFuture(_ensureBleReady()).asyncExpand(
      (_) => _ble.scanForDevices(withServices: [Uuid.parse(serviceId)]),
    );
    return stream
        .map(
          (result) => BleDiscoveredDevice(
            id: result.id,
            name: result.name.isNotEmpty ? result.name : result.id,
          ),
        )
        .timeout(
          timeout,
          onTimeout: (sink) => sink.close(),
        );
  }

  @override
  Future<void> connect(String deviceId) async {
    await _ensureBleReady();
    _connection.add(BleConnectionState.connecting);

    _notifyCharacteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(notifyCharacteristicId),
      deviceId: deviceId,
    );
    _writeCharacteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(writeCharacteristicId),
      deviceId: deviceId,
    );

    await _connectionSub?.cancel();
    _connectionSub = _ble.connectToDevice(id: deviceId).listen((update) {
      if (update.connectionState == DeviceConnectionState.connected) {
        _connection.add(BleConnectionState.connected);
      } else if (update.connectionState == DeviceConnectionState.connecting) {
        _connection.add(BleConnectionState.connecting);
      } else {
        _connection.add(BleConnectionState.disconnected);
      }
    });

    await _notifySub?.cancel();
    _notifySub = _ble.subscribeToCharacteristic(_notifyCharacteristic!).listen(
      (bytes) => _notifications.add(Uint8List.fromList(bytes)),
    );
  }

  @override
  Future<void> disconnect() async {
    await _notifySub?.cancel();
    _notifySub = null;
    await _connectionSub?.cancel();
    _connectionSub = null;
    _connection.add(BleConnectionState.disconnected);
  }

  @override
  Stream<BleConnectionState> connectionState() => _connection.stream;

  @override
  Stream<Uint8List> notifications() => _notifications.stream;

  @override
  Future<void> write(Uint8List bytes, {bool withResponse = true}) async {
    final characteristic = _writeCharacteristic;
    if (characteristic == null) {
      throw StateError('Transport is not connected. Call connect(deviceId) first.');
    }
    if (withResponse) {
      await _ble.writeCharacteristicWithResponse(characteristic, value: bytes);
    } else {
      await _ble.writeCharacteristicWithoutResponse(characteristic, value: bytes);
    }
  }
}
