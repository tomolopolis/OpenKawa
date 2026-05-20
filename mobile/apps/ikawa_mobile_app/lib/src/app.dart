import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'theme/open_kawa_theme.dart';

class IkawaMobileApp extends StatelessWidget {
  const IkawaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenKawa',
      theme: OpenKawaTheme.light(),
      home: const AppShell(),
    );
  }
}
