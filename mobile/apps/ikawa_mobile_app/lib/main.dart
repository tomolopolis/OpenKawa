import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

export 'src/app.dart';
export 'src/app_config.dart';
export 'src/providers.dart';
export 'src/simulated_roaster_transport.dart';

void main() {
  runApp(const ProviderScope(child: IkawaMobileApp()));
}
