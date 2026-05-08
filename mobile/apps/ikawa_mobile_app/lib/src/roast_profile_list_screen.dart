import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

import 'profile_detail_screen.dart';
import 'providers.dart';
import 'roast_features.dart';

class RoastProfileListScreen extends ConsumerStatefulWidget {
  const RoastProfileListScreen({super.key});

  @override
  ConsumerState<RoastProfileListScreen> createState() => _RoastProfileListScreenState();
}

class _RoastProfileListScreenState extends ConsumerState<RoastProfileListScreen> {
  final _profileIo = ProfileIoService();

  bool _matches(String value, String query) {
    final q = query.trim();
    if (q.isEmpty) return true;
    return value.toLowerCase().contains(q.toLowerCase());
  }
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
    final builtIn = catalog.filter(
      profileName: _nameCtrl.text,
      origin: _originCtrl.text,
      coffeeName: _coffeeCtrl.text,
      processType: _processCtrl.text,
      roastLevel: _roastLevelCtrl.text,
    );
    final imported = ref.read(importedRoastProfilesProvider).where((e) {
      return _matches(e.profileName, _nameCtrl.text) &&
          _matches(e.origin, _originCtrl.text) &&
          _matches(e.coffeeName, _coffeeCtrl.text) &&
          _matches(e.processType, _processCtrl.text) &&
          _matches(e.roastLevel, _roastLevelCtrl.text);
    }).toList();
    return [...builtIn, ...imported];
  }

  Future<void> _importLegacyJson() async {
    try {
      final file = File('${Directory.current.path}/profile_set.json');
      if (!await file.exists()) return;
      final entry = _profileIo.importJsonProfile(await file.readAsString());
      final current = [...ref.read(importedRoastProfilesProvider)];
      current.add(entry);
      ref.read(importedRoastProfilesProvider.notifier).state = current;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imported ${entry.profileName}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    }
  }

  Future<void> _createNewProfile() async {
    final preset = await showDialog<({RoastLevelPreset roastLevel, DevelopmentTimePreset devTime})>(
      context: context,
      builder: (context) => const _NewProfilePresetDialog(),
    );
    if (preset == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final roastLevelLabel = switch (preset.roastLevel) {
      RoastLevelPreset.light => 'Light',
      RoastLevelPreset.lightMedium => 'Light-medium',
      RoastLevelPreset.medium => 'Medium',
      RoastLevelPreset.mediumDark => 'Medium-dark',
      RoastLevelPreset.dark => 'Dark',
    };
    final devLabel = switch (preset.devTime) {
      DevelopmentTimePreset.low => 'Low',
      DevelopmentTimePreset.medium => 'Medium',
      DevelopmentTimePreset.high => 'High',
    };
    final entry = RoastProfileCatalogEntry(
      id: 'custom-$now',
      profileName: '$roastLevelLabel · $devLabel dev',
      origin: 'Custom',
      coffeeName: 'Custom Bean',
      processType: 'Washed',
      roastLevel: roastLevelLabel,
      series: buildPresetSeries(
        roastLevel: preset.roastLevel,
        developmentTime: preset.devTime,
      ),
    );
    final current = [...ref.read(importedRoastProfilesProvider), entry];
    ref.read(importedRoastProfilesProvider.notifier).state = current;
    ref.read(selectedRoastProfileCatalogEntryProvider.notifier).state = entry;
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ProfileDetailScreen(entry: entry),
      ),
    );
  }

  bool _isUserManagedProfile(RoastProfileCatalogEntry e) {
    return e.id.startsWith('custom-') || e.id.startsWith('imported-');
  }

  Future<void> _deleteProfile(RoastProfileCatalogEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete profile'),
        content: Text('Delete "${entry.profileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final updated = [...ref.read(importedRoastProfilesProvider)]
      ..removeWhere((p) => p.id == entry.id);
    ref.read(importedRoastProfilesProvider.notifier).state = updated;

    final selected = ref.read(selectedRoastProfileCatalogEntryProvider);
    if (selected?.id == entry.id) {
      ref.read(selectedRoastProfileCatalogEntryProvider.notifier).state = null;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted ${entry.profileName}')),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: _createNewProfile,
                icon: const Icon(Icons.add),
                label: const Text('New profile'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _importLegacyJson,
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Import legacy .json'),
              ),
            ],
          ),
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
                trailing: _isUserManagedProfile(e)
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete profile',
                        onPressed: () => _deleteProfile(e),
                      )
                    : null,
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

class _NewProfilePresetDialog extends StatefulWidget {
  const _NewProfilePresetDialog();

  @override
  State<_NewProfilePresetDialog> createState() => _NewProfilePresetDialogState();
}

class _NewProfilePresetDialogState extends State<_NewProfilePresetDialog> {
  RoastLevelPreset _roastLevel = RoastLevelPreset.medium;
  DevelopmentTimePreset _dev = DevelopmentTimePreset.medium;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New profile preset'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<RoastLevelPreset>(
            initialValue: _roastLevel,
            decoration: const InputDecoration(labelText: 'Roast level'),
            items: const [
              DropdownMenuItem(value: RoastLevelPreset.light, child: Text('Light')),
              DropdownMenuItem(value: RoastLevelPreset.lightMedium, child: Text('Light-medium')),
              DropdownMenuItem(value: RoastLevelPreset.medium, child: Text('Medium')),
              DropdownMenuItem(value: RoastLevelPreset.mediumDark, child: Text('Medium-dark')),
              DropdownMenuItem(value: RoastLevelPreset.dark, child: Text('Dark')),
            ],
            onChanged: (v) => setState(() => _roastLevel = v ?? _roastLevel),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DevelopmentTimePreset>(
            initialValue: _dev,
            decoration: const InputDecoration(labelText: 'Development time'),
            items: const [
              DropdownMenuItem(value: DevelopmentTimePreset.low, child: Text('Low')),
              DropdownMenuItem(value: DevelopmentTimePreset.medium, child: Text('Medium')),
              DropdownMenuItem(value: DevelopmentTimePreset.high, child: Text('High')),
            ],
            onChanged: (v) => setState(() => _dev = v ?? _dev),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop((roastLevel: _roastLevel, devTime: _dev)),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
