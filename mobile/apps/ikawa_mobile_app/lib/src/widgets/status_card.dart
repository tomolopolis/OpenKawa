import 'package:flutter/material.dart';

class StatusChip {
  const StatusChip({required this.label, required this.value});

  final String label;
  final String value;
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.title,
    required this.rows,
    required this.emptyMessage,
    this.chips = const [],
  });

  final String title;
  final Map<String, String> rows;
  final String emptyMessage;
  final List<StatusChip> chips;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (chips.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: chips.map((chip) => Chip(label: Text('${chip.label}: ${chip.value}'))).toList(),
              ),
            ],
            const SizedBox(height: 8),
            if (rows.isEmpty)
              Text(emptyMessage, style: theme.textTheme.bodyMedium)
            else
              ...rows.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(entry.value, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
