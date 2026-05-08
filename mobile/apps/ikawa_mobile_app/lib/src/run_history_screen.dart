import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class RunHistoryScreen extends ConsumerWidget {
  const RunHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(roastRunHistoryProvider);
    final entries = map.entries.toList()
      ..sort((a, b) {
        final at = a.value.isEmpty ? '' : a.value.first.endedAtIso;
        final bt = b.value.isEmpty ? '' : b.value.first.endedAtIso;
        return bt.compareTo(at);
      });

    if (entries.isEmpty) {
      return const Center(child: Text('No roast runs recorded yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];
        final runs = e.value;
        final latest = runs.first;
        final avgDrop = runs.map((r) => r.dropTempC).fold<double>(0, (a, b) => a + b) / runs.length;
        final avgDuration =
            runs.map((r) => r.durationSec).fold<double>(0, (a, b) => a + b) / runs.length;
        return Card(
          child: ExpansionTile(
            title: Text(latest.profileName),
            subtitle: Text(
              '${runs.length} runs · avg drop ${avgDrop.toStringAsFixed(1)} C · avg duration ${(avgDuration / 60).toStringAsFixed(1)} min',
            ),
            children: runs.take(12).map((run) {
              final dt = DateTime.tryParse(run.endedAtIso)?.toLocal();
              return ListTile(
                dense: true,
                title: Text(
                  dt == null
                      ? 'Run'
                      : '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
                ),
                subtitle: Text(
                  'Drop ${run.dropTempC.toStringAsFixed(1)} C · '
                  'Duration ${(run.durationSec / 60).toStringAsFixed(1)} min · '
                  '${run.developmentRatioPct == null ? 'DTR n/a' : 'DTR ${run.developmentRatioPct!.toStringAsFixed(1)}%'}',
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

