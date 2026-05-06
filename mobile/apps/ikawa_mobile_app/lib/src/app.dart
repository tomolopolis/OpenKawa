import 'package:flutter/material.dart';

import 'app_shell.dart';

class IkawaMobileApp extends StatelessWidget {
  const IkawaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IKAWA',
      theme: ThemeData(
        colorSchemeSeed: Colors.brown,
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
