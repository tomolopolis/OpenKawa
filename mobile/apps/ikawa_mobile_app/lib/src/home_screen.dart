import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;
import 'package:permission_handler/permission_handler.dart';

import 'app_config.dart';
import 'live_roast_telemetry.dart';
import 'providers.dart';
import 'widgets/status_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _seq = 0;
  String _status = 'Scan and connect to a roaster.';
  BleConnectionState _connectionState = BleConnectionState.disconnected;
  final List<BleDiscoveredDevice> _devices = [];
  String? _selectedDeviceId;
  bool _isScanning = false;
  StreamSubscription<BleConnectionState>? _connectionSub;
  Timer? _statusPollTimer;
  Map<String, String> _machineInfo = const {};
  Map<String, String> _liveStatus = const {};

  Future<String?> _ensureBlePermissions() async {
    if (useSimulatedTransport) return null;

    if (Platform.isAndroid) {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      final scan = statuses[Permission.bluetoothScan];
      final connect = statuses[Permission.bluetoothConnect];
      final location = statuses[Permission.locationWhenInUse];

      final bluetoothGranted = (scan?.isGranted ?? false) && (connect?.isGranted ?? false);
      final legacyGranted = location?.isGranted ?? false;

      if (bluetoothGranted || legacyGranted) {
        return null;
      }

      final permanentlyDenied = (scan?.isPermanentlyDenied ?? false) ||
          (connect?.isPermanentlyDenied ?? false) ||
          (location?.isPermanentlyDenied ?? false);

      if (permanentlyDenied) {
        return 'Bluetooth permission permanently denied. Open Android Settings > App > '
            'Permissions and allow Nearby devices.';
      }
      return 'Bluetooth permissions are required to scan for roasters.';
    }

    if (Platform.isIOS) {
      final status = await Permission.bluetooth.request();
      if (status.isGranted) return null;
      if (status.isPermanentlyDenied) {
        return 'Bluetooth permission permanently denied. Open iOS Settings and allow Bluetooth.';
      }
      return 'Bluetooth permission is required to scan for roasters.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    final transport = ref.read(transportProvider);
    _connectionSub = transport.connectionState().listen((state) {
      if (!mounted) return;
      if (state != BleConnectionState.connected) {
        ref.read(liveRoastTelemetryProvider.notifier).state = null;
      }
      setState(() {
        _connectionState = state;
        if (state == BleConnectionState.connected) {
          _startStatusPolling();
        } else {
          _stopStatusPolling();
          _liveStatus = const {};
        }
      });
    });
  }

  @override
  void dispose() {
    _stopStatusPolling();
    _connectionSub?.cancel();
    super.dispose();
  }

  void _startStatusPolling() {
    _statusPollTimer?.cancel();
    _statusPollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _getMachineStatus(silent: true);
    });
  }

  void _stopStatusPolling() {
    _statusPollTimer?.cancel();
    _statusPollTimer = null;
  }

  Future<void> _scan() async {
    final transport = ref.read(transportProvider);
    final permissionError = await _ensureBlePermissions();
    if (permissionError != null) {
      if (!mounted) return;
      setState(() {
        _status = permissionError;
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _status = 'Scanning for devices...';
      _devices.clear();
      _selectedDeviceId = null;
    });

    try {
      await for (final device in transport.scan(timeout: const Duration(seconds: 5))) {
        if (!mounted) return;
        if (_devices.every((d) => d.id != device.id)) {
          setState(() {
            _devices.add(device);
            _selectedDeviceId ??= device.id;
          });
        }
      }
      if (!mounted) return;
      setState(() {
        _status = _devices.isEmpty
            ? 'No devices found.'
            : 'Scan complete. Select a device and connect.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'Scan failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _connect() async {
    final deviceId = _selectedDeviceId;
    if (deviceId == null) {
      setState(() => _status = 'Select a device first.');
      return;
    }
    final transport = ref.read(transportProvider);
    setState(() => _status = 'Connecting to $deviceId...');
    try {
      await transport.connect(deviceId);
      if (!mounted) return;
      setState(() => _status = 'Connected to $deviceId');
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Connect failed: $e');
    }
  }

  Future<void> _disconnect() async {
    final transport = ref.read(transportProvider);
    await transport.disconnect();
    ref.read(liveRoastTelemetryProvider.notifier).state = null;
    if (!mounted) return;
    setState(() {
      _status = 'Disconnected';
      _machineInfo = const {};
      _liveStatus = const {};
    });
  }

  Future<pb.IkawaResponse> _sendCommand(int cmdType) async {
    final session = ref.read(sessionServiceProvider);
    final request = pb.Message()
      ..cmdType = cmdType
      ..seq = ++_seq;
    return session.sendTypedRequest(request);
  }

  Future<void> _getMachineType() async {
    if (_connectionState != BleConnectionState.connected) {
      setState(() => _status = 'Connect to a device first.');
      return;
    }
    setState(() => _status = 'Sending MACH_PROP_GET_TYPE...');
    try {
      final response = await _sendCommand(2);
      final type = response.hasRespMachPropType() ? response.respMachPropType.type : -1;
      final variant = response.hasRespMachPropType() ? response.respMachPropType.variant : -1;
      setState(() {
        _status = 'OK seq=${response.seq} resp=${response.resp.value}\n'
            'type=$type variant=$variant';
      });
    } catch (e) {
      setState(() => _status = 'Request failed: $e');
    }
  }

  Future<void> _loadMachineInfo() async {
    if (_connectionState != BleConnectionState.connected) {
      setState(() => _status = 'Connect to a device first.');
      return;
    }
    setState(() => _status = 'Loading machine info...');
    try {
      final versionResp = await _sendCommand(0);
      final typeResp = await _sendCommand(2);
      final idResp = await _sendCommand(3);
      final supportResp = await _sendCommand(23);
      final roastCountResp = await _sendCommand(13);

      final version = versionResp.hasRespBootloaderGetVersion()
          ? '${versionResp.respBootloaderGetVersion.version} '
              '(${versionResp.respBootloaderGetVersion.revision})'
          : 'n/a';
      final type = typeResp.hasRespMachPropType() ? typeResp.respMachPropType.type : -1;
      final variant = typeResp.hasRespMachPropType() ? typeResp.respMachPropType.variant : -1;
      final machineId = idResp.hasRespMachId() ? idResp.respMachId.id : -1;
      final schema = supportResp.hasRespMachPropGetSupportInfo()
          ? supportResp.respMachPropGetSupportInfo.profileSchema
          : -1;
      final totalRoasts = roastCountResp.hasRespHistGetTotalRoastCount()
          ? roastCountResp.respHistGetTotalRoastCount.totalRoastCount
          : -1;

      if (!mounted) return;
      setState(() {
        _machineInfo = {
          'Machine ID': '$machineId',
          'Type': '$type',
          'Variant': '$variant',
          'Firmware': version,
          'Profile schema': '$schema',
          'Total roasts': '$totalRoasts',
        };
        _status = 'Machine info loaded.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Machine info failed: $e');
    }
  }

  /// Wire command id for “profile loaded on machine” (matches Python `IkawaEmulatedRoaster.PROFILE_GET`).
  static const int _cmdProfileGet = 15;

  Map<String, String> _profileSummary(pb.RoastProfile p) {
    final idBytes = p.id;
    final idHex = idBytes.isEmpty
        ? '—'
        : idBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return {
      'Name': p.hasName() && p.name.isNotEmpty ? p.name : '—',
      'Coffee': p.hasCoffeeName() && p.coffeeName.isNotEmpty ? p.coffeeName : '—',
      'Schema': p.hasSchema() ? '${p.schema}' : '—',
      'Type': p.hasProfileType() && p.profileType.isNotEmpty ? p.profileType : '—',
      'Temp points': '${p.tempPoints.length}',
      'Fan points': '${p.fanPoints.length}',
      'Id (hex)': idHex,
    };
  }

  Future<void> _getMachineStatus({bool silent = false}) async {
    if (_connectionState != BleConnectionState.connected) return;
    if (!silent) {
      setState(() => _status = 'Loading live status...');
    }
    try {
      final response = await _sendCommand(11);
      if (!response.hasRespMachStatusGetAll()) {
        if (!silent && mounted) {
          setState(() => _status = 'Live status unavailable.');
        }
        return;
      }
      final s = response.respMachStatusGetAll;
      final telemetry = LiveRoastTelemetry.fromMachStatus(s);
      if (telemetry != null) {
        ref.read(liveRoastTelemetryProvider.notifier).state = telemetry;
      }

      pb.RoastProfile? loadedProfile;
      try {
        final profileResp = await _sendCommand(_cmdProfileGet);
        if (profileResp.hasRespProfileGet() && profileResp.respProfileGet.hasProfile()) {
          loadedProfile = profileResp.respProfileGet.profile;
        }
      } catch (_) {
        // Profile query is optional; telemetry still useful if firmware differs.
      }

      if (!mounted) return;
      setState(() {
        final rows = <String, String>{
          'Time': '${s.time}s',
          'State': '${s.state}',
          'Temp above': s.hasTempAbove() ? '${s.tempAbove}' : 'n/a',
          'Temp below': s.hasTempBelow() ? '${s.tempBelow}' : 'n/a',
          'Setpoint': '${s.setpoint}',
          'Fan set / measured': '${s.fan} / ${s.fanMeasured}',
          'Heater': '${s.heater}',
        };
        if (loadedProfile != null) {
          for (final e in _profileSummary(loadedProfile).entries) {
            rows['Profile · ${e.key}'] = e.value;
          }
        } else {
          rows['Profile · Name'] = '—';
          rows['Profile · Coffee'] = '(not available)';
        }
        _liveStatus = rows;
        if (!silent) {
          _status = 'Live status updated.';
        }
      });
    } catch (e) {
      if (!silent && mounted) {
        setState(() => _status = 'Live status failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionServiceProvider);
    final selectedCatalog = ref.watch(selectedRoastProfileCatalogEntryProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Current mode: ${session.mode.name}'),
            Text('Connection: ${_connectionState.name}'),
            Text(
              selectedCatalog != null
                  ? 'Catalog profile: ${selectedCatalog.profileName}'
                  : 'Catalog profile: none (choose in Profiles tab)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isScanning ? null : _scan,
              child: Text(_isScanning ? 'Scanning...' : 'Scan for Devices'),
            ),
            if (_devices.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedDeviceId,
                hint: const Text('Select device'),
                items: _devices
                    .map(
                      (d) => DropdownMenuItem<String>(
                        value: d.id,
                        child: Text('${d.name} (${d.id})'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedDeviceId = value),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _connectionState == BleConnectionState.connected ? null : _connect,
                      child: const Text('Connect'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _connectionState == BleConnectionState.connected ? _disconnect : null,
                      child: const Text('Disconnect'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _connectionState == BleConnectionState.connected ? _getMachineType : null,
              child: const Text('Get Machine Type'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _connectionState == BleConnectionState.connected ? _loadMachineInfo : null,
              child: const Text('Load Machine Info'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _connectionState == BleConnectionState.connected
                  ? () => _getMachineStatus()
                  : null,
              child: const Text('Refresh Live Status'),
            ),
            const SizedBox(height: 12),
            StatusCard(
              title: 'Machine Info',
              rows: _machineInfo,
              emptyMessage: 'Not loaded.',
            ),
            const SizedBox(height: 12),
            StatusCard(
              title: 'Live Status',
              rows: _liveStatus,
              emptyMessage: 'Not loaded.',
              chips: [
                StatusChip(
                  label: 'Connection',
                  value: _connectionState.name,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
