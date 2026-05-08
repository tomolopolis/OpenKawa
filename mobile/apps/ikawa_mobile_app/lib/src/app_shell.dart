import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'roast_profile_list_screen.dart';
import 'run_history_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _titles = ['Roast profiles', 'Roaster', 'Run history'];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 840;
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: Text('Profiles'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bluetooth_searching),
                  selectedIcon: Icon(Icons.bluetooth_connected),
                  label: Text('Roaster'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: Text('History'),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: const [
                RoastProfileListScreen(),
                HomeScreen(),
                RunHistoryScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: 'Profiles',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bluetooth_searching),
                  selectedIcon: Icon(Icons.bluetooth_connected),
                  label: 'Roaster',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: 'History',
                ),
              ],
            ),
    );
  }
}
