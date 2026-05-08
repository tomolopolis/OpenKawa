import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';
import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;
import 'package:permission_handler/permission_handler.dart';

import 'app_config.dart';
import 'live_roast_telemetry.dart';
import 'profile_detail_screen.dart';
import 'providers.dart';
import 'roast_features.dart';
import 'widgets/status_card.dart';
import 'widgets/roast_profile_chart.dart';

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
  final _beanRepo = AppBeanLibraryRepository();
  final _profileIo = ProfileIoService();
  final _runRepo = RoastRunHistoryRepository();

  Future<void> _showBeanEditor() async {
    final edited = await showDialog<List<GreenBean>>(
      context: context,
      builder: (context) => _BeanLibraryDialog(initial: ref.read(beanLibraryProvider)),
    );
    if (edited == null) return;
    ref.read(beanLibraryProvider.notifier).state = edited;
    if (edited.isNotEmpty) {
      final selectedId = ref.read(selectedBeanIdProvider);
      final stillExists = edited.any((b) => b.id == selectedId);
      if (!stillExists) {
        ref.read(selectedBeanIdProvider.notifier).state = edited.first.id;
      }
    } else {
      ref.read(selectedBeanIdProvider.notifier).state = null;
    }
    await _saveBeanLibrary();
  }
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
    _bootstrapLocalState();
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

  Future<void> _bootstrapLocalState() async {
    final beans = await _beanRepo.load();
    if (!mounted) return;
    if (beans.isNotEmpty) {
      ref.read(beanLibraryProvider.notifier).state = beans;
      final selectedId = ref.read(selectedBeanIdProvider);
      if (selectedId == null || !beans.any((b) => b.id == selectedId)) {
        ref.read(selectedBeanIdProvider.notifier).state = beans.first.id;
      }
    }
    final runs = await _runRepo.load();
    if (!mounted) return;
    ref.read(roastRunHistoryProvider.notifier).state = runs;
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

  Future<void> _uploadSelectedProfile() async {
    final selectedCatalog = ref.read(selectedRoastProfileCatalogEntryProvider);
    if (selectedCatalog == null) {
      setState(() => _status = 'Select a profile from Profiles tab first.');
      return;
    }
    setState(() => _status = 'Uploading ${selectedCatalog.profileName}...');
    try {
      final uploader = ProfileUploadService(sessionService: ref.read(sessionServiceProvider));
      final result = await uploader.uploadCatalogProfile(selectedCatalog);
      ref.read(uploadedChunkCountProvider.notifier).state = result.chunkCount;
      if (!mounted) return;
      setState(() => _status = 'Profile uploaded in ${result.chunkCount} chunks.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Profile upload failed: $e');
    }
  }

  Future<void> _saveBeanLibrary() async {
    final beans = ref.read(beanLibraryProvider);
    await _beanRepo.save(beans);
    if (!mounted) return;
    setState(() => _status = 'Saved ${beans.length} beans.');
  }

  Future<void> _loadBeanLibrary() async {
    final beans = await _beanRepo.load();
    ref.read(beanLibraryProvider.notifier).state = beans;
    if (!mounted) return;
    setState(() => _status = 'Loaded ${beans.length} beans.');
  }

  Future<void> _exportCsv() async {
    final selected = ref.read(selectedRoastProfileCatalogEntryProvider);
    if (selected == null) {
      setState(() => _status = 'Select a profile before exporting.');
      return;
    }
    final csv = _profileIo.exportArtisanCsv(
      profile: selected,
      samples: ref.read(roastSamplesProvider),
    );
    setState(() => _status = 'CSV export ready (${csv.split('\n').length - 1} rows).');
  }

  Future<void> _stopRoastAndRecordRun() async {
    final currentSession = ref.read(roastSessionStateProvider);
    final selectedProfile = ref.read(selectedRoastProfileCatalogEntryProvider);
    final samples = ref.read(roastSamplesProvider);
    if (!currentSession.isRunning || selectedProfile == null || samples.isEmpty) {
      ref.read(roastSessionStateProvider.notifier).state = const RoastSessionState();
      setState(() => _status = 'Roast stopped.');
      return;
    }
    final startSec = currentSession.roastStartSec ?? samples.first.timeSec;
    final endSec = samples.last.timeSec;
    final duration = (endSec - startSec).clamp(0, 7200).toDouble();
    final firstCrack = currentSession.firstCrackSec;
    final devPct = firstCrack == null || endSec <= firstCrack
        ? null
        : ((endSec - firstCrack) / (endSec - startSec) * 100);
    final summary = RoastRunSummary(
      profileId: selectedProfile.id,
      profileName: selectedProfile.profileName,
      startedAtIso: DateTime.now().subtract(Duration(seconds: duration.round())).toIso8601String(),
      endedAtIso: DateTime.now().toIso8601String(),
      durationSec: duration,
      dropTempC: samples.last.beanTempC,
      firstCrackSec: firstCrack == null ? null : (firstCrack - startSec).clamp(0, 7200).toDouble(),
      developmentRatioPct: devPct,
    );
    final map = {...ref.read(roastRunHistoryProvider)};
    final list = [...(map[selectedProfile.id] ?? const <RoastRunSummary>[])];
    list.insert(0, summary);
    map[selectedProfile.id] = list.take(50).toList();
    ref.read(roastRunHistoryProvider.notifier).state = map;
    await _runRepo.save(map);
    ref.read(roastSessionStateProvider.notifier).state = const RoastSessionState();
    setState(() => _status = 'Roast run saved for ${selectedProfile.profileName}.');
  }

  Future<void> _autoCompleteRunIfFinished(LiveRoastTelemetry telemetry) async {
    final session = ref.read(roastSessionStateProvider);
    if (!session.isRunning) return;
    final selectedProfile = ref.read(selectedRoastProfileCatalogEntryProvider);
    if (selectedProfile == null) return;
    final targetEnd = selectedProfile.series.timelineEndSec;
    if (telemetry.timeSec >= targetEnd) {
      await _stopRoastAndRecordRun();
    }
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
        final selectedBeanId = ref.read(selectedBeanIdProvider);
        GreenBean? bean;
        for (final b in ref.read(beanLibraryProvider)) {
          if (selectedBeanId == null || b.id == selectedBeanId) {
            bean = b;
            break;
          }
        }
        final beanTemp = telemetry.beanTempC;
        final derivedRor = telemetry.rorCPerMin ?? 0;
        final samples = [...ref.read(roastSamplesProvider)];
        samples.add(
          LiveRoastSample(
            timeSec: telemetry.timeSec,
            inletTempC: s.hasTempAbove() ? s.tempAbove.toDouble() : telemetry.beanTempC,
            beanTempC: beanTemp,
            rorCPerMin: derivedRor,
            fan: telemetry.fanSetpoint ?? 0,
          ),
        );
        ref.read(roastSamplesProvider.notifier).state = samples.take(180).toList();
        final warnings = evaluateRoastWarnings(
          rorCPerMin: derivedRor,
          elapsedSec: telemetry.timeSec,
          bean: bean,
        );
        if (warnings.isNotEmpty && mounted && !silent) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(warnings.first.message)));
        }
        ref.read(externalSensorTelemetryProvider.notifier).state = ExternalSensorSample(
          timeSec: telemetry.timeSec,
          beanProbeTempC: telemetry.beanTempC - 3,
        );
        await _autoCompleteRunIfFinished(telemetry);
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
    final roastSession = ref.watch(roastSessionStateProvider);
    final telemetry = ref.watch(liveRoastTelemetryProvider);
    final dtr = telemetry == null ? null : calculateDtrPercent(roastSession, telemetry.timeSec);
    final dtrLabel = dtr == null ? 'DTR: not started' : 'DTR ${dtr.toStringAsFixed(1)}% · ${dtrZone(dtr)}';
    final uploadedChunks = ref.watch(uploadedChunkCountProvider);
    final canShowLiveOverlay = selectedCatalog != null && telemetry != null;
    final beans = ref.watch(beanLibraryProvider);
    final selectedBeanId = ref.watch(selectedBeanIdProvider);
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
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _connectionState == BleConnectionState.connected ? _uploadSelectedProfile : null,
              child: const Text('Upload Selected Profile'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: telemetry == null
                        ? null
                        : () {
                            ref.read(roastSessionStateProvider.notifier).state = RoastSessionState(
                              isRunning: true,
                              roastStartSec: telemetry.timeSec,
                            );
                          },
                    child: const Text('Start Roast'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: roastSession.isRunning ? _stopRoastAndRecordRun : null,
                    child: const Text('Stop Roast'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: (!roastSession.isRunning || telemetry == null)
                        ? null
                        : () {
                            final current = ref.read(roastSessionStateProvider);
                            ref.read(roastSessionStateProvider.notifier).state = current.copyWith(
                              firstCrackSec: telemetry.timeSec,
                            );
                          },
                    child: const Text('Mark First Crack'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(dtrLabel),
            if (uploadedChunks > 0) Text('Last upload chunks: $uploadedChunks'),
            const SizedBox(height: 12),
            if (selectedCatalog != null) ...[
              Text(
                telemetry == null ? 'Profile preview' : 'Live overlay on active profile',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: RoastProfileChart(
                    series: selectedCatalog.series,
                    showRor: true,
                    editable: false,
                    liveTimeSec: telemetry?.timeSec,
                    liveTemp: telemetry?.beanTempC,
                    liveFan: telemetry?.fanSetpoint,
                    liveRor: telemetry?.rorCPerMin,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canShowLiveOverlay
                          ? () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (context) => ProfileDetailScreen(entry: selectedCatalog),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Open active profile'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (beans.isNotEmpty)
                  DropdownButton<String>(
                    value: selectedBeanId ?? beans.first.id,
                    items: beans
                        .map((b) => DropdownMenuItem<String>(
                              value: b.id,
                              child: Text('${b.name} (${b.densityGPerMl.toStringAsFixed(2)} g/ml)'),
                            ))
                        .toList(),
                    onChanged: (v) => ref.read(selectedBeanIdProvider.notifier).state = v,
                  ),
                OutlinedButton(onPressed: _showBeanEditor, child: const Text('Edit Beans')),
                OutlinedButton(onPressed: _loadBeanLibrary, child: const Text('Load Bean Library')),
                OutlinedButton(onPressed: _exportCsv, child: const Text('Export Artisan CSV')),
              ],
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

class _BeanLibraryDialog extends StatefulWidget {
  const _BeanLibraryDialog({required this.initial});

  final List<GreenBean> initial;

  @override
  State<_BeanLibraryDialog> createState() => _BeanLibraryDialogState();
}

class _BeanLibraryDialogState extends State<_BeanLibraryDialog> {
  late List<GreenBean> _beans;

  @override
  void initState() {
    super.initState();
    _beans = [...widget.initial];
  }

  Future<void> _addBean() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final bean = await showDialog<GreenBean>(
      context: context,
      builder: (context) => _BeanEditorDialog(
        bean: GreenBean(
          id: 'bean-$now',
          name: 'New Bean',
          densityGPerMl: 0.70,
          moisturePercent: 10.8,
          beanSizeScreen: 16,
        ),
      ),
    );
    if (bean != null) setState(() => _beans.add(bean));
  }

  Future<void> _editBean(int idx) async {
    final bean = await showDialog<GreenBean>(
      context: context,
      builder: (context) => _BeanEditorDialog(bean: _beans[idx]),
    );
    if (bean != null) {
      setState(() => _beans[idx] = bean);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bean Library'),
      content: SizedBox(
        width: 420,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _beans.length,
          itemBuilder: (context, i) {
            final b = _beans[i];
            return ListTile(
              title: Text(b.name),
              subtitle: Text(
                'Density ${b.densityGPerMl.toStringAsFixed(2)} g/ml · Moisture ${b.moisturePercent.toStringAsFixed(1)}% · Size ${b.beanSizeScreen}',
              ),
              onTap: () => _editBean(i),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => setState(() => _beans.removeAt(i)),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: _addBean, child: const Text('Add bean')),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_beans),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _BeanEditorDialog extends StatefulWidget {
  const _BeanEditorDialog({required this.bean});
  final GreenBean bean;

  @override
  State<_BeanEditorDialog> createState() => _BeanEditorDialogState();
}

class _BeanEditorDialogState extends State<_BeanEditorDialog> {
  late final TextEditingController _name = TextEditingController(text: widget.bean.name);
  late final TextEditingController _density =
      TextEditingController(text: widget.bean.densityGPerMl.toStringAsFixed(2));
  late final TextEditingController _moisture =
      TextEditingController(text: widget.bean.moisturePercent.toStringAsFixed(1));
  late final TextEditingController _size =
      TextEditingController(text: widget.bean.beanSizeScreen.toString());

  @override
  void dispose() {
    _name.dispose();
    _density.dispose();
    _moisture.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bean details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _density, decoration: const InputDecoration(labelText: 'Density (g/ml)')),
          TextField(controller: _moisture, decoration: const InputDecoration(labelText: 'Moisture (%)')),
          TextField(controller: _size, decoration: const InputDecoration(labelText: 'Bean size')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final parsedDensity = double.tryParse(_density.text) ?? widget.bean.densityGPerMl;
            final parsedMoisture = double.tryParse(_moisture.text) ?? widget.bean.moisturePercent;
            final parsedSize = int.tryParse(_size.text) ?? widget.bean.beanSizeScreen;
            Navigator.of(context).pop(
              GreenBean(
                id: widget.bean.id,
                name: _name.text.trim().isEmpty ? widget.bean.name : _name.text.trim(),
                densityGPerMl: parsedDensity,
                moisturePercent: (parsedMoisture.clamp(8.0, 14.0) as num).toDouble(),
                beanSizeScreen: parsedSize,
              ),
            );
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
