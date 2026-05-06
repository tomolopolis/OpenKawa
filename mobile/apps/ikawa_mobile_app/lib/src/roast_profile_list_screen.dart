import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

import 'profile_detail_screen.dart';
import 'providers.dart';

class RoastProfileListScreen extends ConsumerStatefulWidget {
  const RoastProfileListScreen({super.key});

  @override
  ConsumerState<RoastProfileListScreen> createState() => _RoastProfileListScreenState();
}

class _RoastProfileListScreenState extends ConsumerState<RoastProfileListScreen> {
  final _nameCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _coffeeCtrl = TextEditingController();
  final _processCtrl = TextEditingController();
  final _roastLevelCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _originCtrl.dispose();
    _coffeeCtrl.dispose();
    _processCtrl.dispose();
    _roastLevelCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    setState(() {});
  }

  List<RoastProfileCatalogEntry> _filtered(RoastProfileCatalog catalog) {
    return catalog.filter(
      profileName: _nameCtrl.text,
      origin: _originCtrl.text,
      coffeeName: _coffeeCtrl.text,
      processType: _processCtrl.text,
      roastLevel: _roastLevelCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(roastProfileCatalogProvider);
    final selected = ref.watch(selectedRoastProfileCatalogEntryProvider);
    final rows = _filtered(catalog);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Search by profile name',
              hintText: 'Type to filter…',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (_) => _applyFilter(),
          ),
        ),
        ExpansionTile(
          title: const Text('More search options'),
          subtitle: const Text('Origin, coffee, process, roast level'),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            TextField(
              controller: _originCtrl,
              decoration: const InputDecoration(
                labelText: 'Origin',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _applyFilter(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _coffeeCtrl,
              decoration: const InputDecoration(
                labelText: 'Coffee name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _applyFilter(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _processCtrl,
              decoration: const InputDecoration(
                labelText: 'Process type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _applyFilter(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _roastLevelCtrl,
              decoration: const InputDecoration(
                labelText: 'Roast level',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _applyFilter(),
            ),
          ],
        ),
        if (selected != null)
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Selected profile'),
              subtitle: Text(selected.profileName),
            ),
          ),
        Expanded(
          child: ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final e = rows[i];
              final isSelected = selected?.id == e.id;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.local_cafe : Icons.local_cafe_outlined,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                title: Text(e.profileName),
                subtitle: Text(
                  '${e.coffeeName} · ${e.origin}\n'
                  '${e.processType} · ${e.roastLevel}',
                ),
                isThreeLine: true,
                selected: isSelected,
                onTap: () {
                  ref.read(selectedRoastProfileCatalogEntryProvider.notifier).state = e;
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (context) => ProfileDetailScreen(entry: e),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
