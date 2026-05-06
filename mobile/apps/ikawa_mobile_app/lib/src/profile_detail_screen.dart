import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

import 'providers.dart';
import 'widgets/roast_profile_chart.dart';

enum _ProfileChartMode { temperature, advanced }

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({
    super.key,
    required this.entry,
    this.liveTimeSec,
    this.liveTemp,
    this.liveRor,
  });

  final RoastProfileCatalogEntry entry;

  /// During an active roast, pass telemetry (seconds aligned with [entry.series.timeSec]).
  final double? liveTimeSec;
  final double? liveTemp;
  final double? liveRor;

  @override
  ConsumerState<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  _ProfileChartMode _mode = _ProfileChartMode.temperature;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final showRor = _mode == _ProfileChartMode.advanced;
    final roasterLive = ref.watch(liveRoastTelemetryProvider);
    final liveTimeSec = roasterLive?.timeSec ?? widget.liveTimeSec;
    final liveTemp = roasterLive?.beanTempC ?? widget.liveTemp;
    final liveRor = showRor ? (roasterLive?.rorCPerMin ?? widget.liveRor) : null;
    final liveFan = roasterLive?.fanSetpoint;
    final hasLiveMarker = liveTimeSec != null && liveTemp != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(e.profileName),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(selectedRoastProfileCatalogEntryProvider.notifier).state = e;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Active profile: ${e.profileName}')),
              );
            },
            child: const Text('Use for roaster'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SegmentedButton<_ProfileChartMode>(
                segments: const [
                  ButtonSegment<_ProfileChartMode>(
                    value: _ProfileChartMode.temperature,
                    label: Text('Temperature'),
                    icon: Icon(Icons.thermostat_outlined),
                  ),
                  ButtonSegment<_ProfileChartMode>(
                    value: _ProfileChartMode.advanced,
                    label: Text('Advanced'),
                    icon: Icon(Icons.show_chart),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.single),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${e.coffeeName} · ${e.origin} · ${e.processType} · ${e.roastLevel}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (roasterLive != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Badge(
                    label: Text(
                      '${roasterLive.beanTempC.toStringAsFixed(0)}°C'
                      '${showRor && roasterLive.rorCPerMin != null ? ' · RoR ${roasterLive.rorCPerMin!.toStringAsFixed(1)}' : ''} '
                      '@ ${roasterLive.timeSec.toStringAsFixed(0)}s',
                    ),
                    child: const Icon(Icons.podcasts, size: 20),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: RoastProfileChart(
                      series: e.series,
                      showRor: showRor,
                      liveTimeSec: liveTimeSec,
                      liveTemp: liveTemp,
                      liveFan: liveFan,
                      liveRor: liveRor,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _LegendDot(
                    color: Theme.of(context).colorScheme.primary,
                    label: 'Bean temperature',
                  ),
                  _LegendFan(color: Theme.of(context).colorScheme.secondary),
                  if (showRor)
                    _LegendDot(
                      color: Theme.of(context).colorScheme.tertiary,
                      label: 'RoR',
                    ),
                  if (hasLiveMarker)
                    _LegendDot(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      label: 'Live roaster',
                      isMarker: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendFan extends StatelessWidget {
  const _LegendFan({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(14, 3),
          painter: _DashedLinePainter(color: color),
        ),
        const SizedBox(width: 6),
        Text('Fan', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const dash = 4.0;
    const gap = 3.0;
    var x = 0.0;
    while (x < size.width) {
      final x1 = math.min(x + dash, size.width);
      canvas.drawLine(Offset(x, size.height / 2), Offset(x1, size.height / 2), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => oldDelegate.color != color;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    this.isMarker = false,
  });

  final Color color;
  final String label;
  final bool isMarker;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMarker)
          Icon(Icons.place, size: 16, color: color)
        else
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
