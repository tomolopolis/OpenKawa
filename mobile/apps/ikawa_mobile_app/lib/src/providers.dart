import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';
import 'package:ikawa_ble_transport/ikawa_ble_transport.dart';
import 'package:ikawa_protocol_core/ikawa_protocol_core.dart';

import 'app_config.dart';
import 'live_roast_telemetry.dart';
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

final selectedRoastProfileCatalogEntryProvider =
    StateProvider<RoastProfileCatalogEntry?>((ref) => null);

/// Updated from roaster status polls while connected; cleared on disconnect.
final liveRoastTelemetryProvider = StateProvider<LiveRoastTelemetry?>((ref) => null);
