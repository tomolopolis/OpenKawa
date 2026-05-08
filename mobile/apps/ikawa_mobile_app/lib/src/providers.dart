import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';
import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';

import 'app_config.dart';
import 'live_roast_telemetry.dart';
import 'roast_features.dart';
import 'simulated_roaster_transport.dart';

final transportProvider = Provider<BleTransport>((ref) {
  if (useSimulatedTransport) {
    return SimulatedRoasterTransport();
  }
  return ReactiveBleTransport();
});

final protocolClientProvider = Provider<IkawaProtocolClient>((ref) {
  return DefaultIkawaProtocolClient(
    transport: ref.watch(transportProvider),
  );
});

final sessionServiceProvider = Provider<RoasterSessionService>((ref) {
  return RoasterSessionService(
    protocolClient: ref.watch(protocolClientProvider),
    transport: ref.watch(transportProvider),
  );
});

final roastProfileCatalogProvider = Provider<RoastProfileCatalog>((ref) {
  return RoastProfileCatalog();
});

final importedRoastProfilesProvider = StateProvider<List<RoastProfileCatalogEntry>>((ref) => const []);

final selectedRoastProfileCatalogEntryProvider =
    StateProvider<RoastProfileCatalogEntry?>((ref) => null);

/// Updated from roaster status polls while connected; cleared on disconnect.
final liveRoastTelemetryProvider = StateProvider<LiveRoastTelemetry?>((ref) => null);

final roastSessionStateProvider = StateProvider<RoastSessionState>((ref) {
  return const RoastSessionState();
});

final uploadedChunkCountProvider = StateProvider<int>((ref) => 0);

final roastSamplesProvider = StateProvider<List<LiveRoastSample>>((ref) => const []);

final beanLibraryProvider = StateProvider<List<GreenBean>>((ref) {
  return const [
    GreenBean(
      id: 'default-ethiopia',
      name: 'Ethiopia Washed',
      densityGPerMl: 0.73,
      moisturePercent: 10.8,
      beanSizeScreen: 16,
    ),
  ];
});

final selectedBeanIdProvider = StateProvider<String?>((ref) => 'default-ethiopia');

final externalSensorTelemetryProvider = StateProvider<ExternalSensorSample?>((ref) => null);

final roastRunHistoryProvider = StateProvider<Map<String, List<RoastRunSummary>>>((ref) => const {});
