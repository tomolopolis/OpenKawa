import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

import 'providers.dart';
import 'widgets/roast_profile_chart.dart';
import 'roast_features.dart';

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

  /// During an active roast, pass telemetry (seconds on the same axis as [RoastProfileSeries.timelineStartSec]–[timelineEndSec]).
  final double? liveTimeSec;
  final double? liveTemp;
  final double? liveRor;

  @override
  ConsumerState<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  _ProfileChartMode _mode = _ProfileChartMode.temperature;
  late RoastProfileSeries _editableSeries;

  @override
  void initState() {
    super.initState();
    _editableSeries = widget.entry.series;
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final validationIssues = const RoastProfileValidator().validate(_editableSeries);
    final showRor = _mode == _ProfileChartMode.advanced;
    final runHistory = ref.watch(roastRunHistoryProvider)[e.id] ?? const <RoastRunSummary>[];
    final roasterLive = ref.watch(liveRoastTelemetryProvider);
    final extSensor = ref.watch(externalSensorTelemetryProvider);
    final beanLibrary = ref.watch(beanLibraryProvider);
    final selectedBeanId = ref.watch(selectedBeanIdProvider);
    GreenBean? bean;
    if (selectedBeanId == null) {
      bean = beanLibrary.isEmpty ? null : beanLibrary.first;
    } else {
      for (final b in beanLibrary) {
        if (b.id == selectedBeanId) {
          bean = b;
          break;
        }
      }
    }
    final liveTimeSec = roasterLive?.timeSec ?? widget.liveTimeSec;
    final virtualBeanTemp = roasterLive == null
        ? null
        : estimateVirtualBeanTemp(inletTempC: roasterLive.beanTempC, bean: bean);
    final liveTemp = extSensor?.beanProbeTempC ?? roasterLive?.beanTempC ?? virtualBeanTemp ?? widget.liveTemp;
    final liveRor = showRor ? (roasterLive?.rorCPerMin ?? widget.liveRor) : null;
    final liveFan = roasterLive?.fanSetpoint;
    final hasLiveMarker = liveTimeSec != null && liveTemp != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(e.profileName),
        actions: [
          TextButton(
            onPressed: () {
              final updated = RoastProfileCatalogEntry(
                id: e.id.startsWith('custom-') || e.id.startsWith('imported-')
                    ? e.id
                    : 'custom-${DateTime.now().millisecondsSinceEpoch}',
                profileName: e.profileName,
                origin: e.origin,
                coffeeName: e.coffeeName,
                processType: e.processType,
                roastLevel: e.roastLevel,
                series: _editableSeries,
              );
              final all = [...ref.read(importedRoastProfilesProvider)];
              final idx = all.indexWhere((p) => p.id == updated.id);
              if (idx >= 0) {
                all[idx] = updated;
              } else {
                all.add(updated);
              }
              ref.read(importedRoastProfilesProvider.notifier).state = all;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile changes saved')),
              );
            },
            child: const Text('Save'),
          ),
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
            if (virtualBeanTemp != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Text(
                  extSensor != null
                      ? 'External probe active: ${extSensor.beanProbeTempC.toStringAsFixed(1)} C'
                      : 'Virtual bean temp: ${virtualBeanTemp.toStringAsFixed(1)} C',
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
                      series: _editableSeries,
                      showRor: showRor,
                      editable: true,
                      onSeriesChanged: (next) => setState(() => _editableSeries = next),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                runHistory.isEmpty
                    ? 'No recorded runs for this profile yet.'
                    : 'Recorded runs: ${runHistory.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (runHistory.isNotEmpty)
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: math.min(runHistory.length, 8),
                  itemBuilder: (context, i) {
                    final run = runHistory[i];
                    return SizedBox(
                      width: 220,
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Run ${i + 1}', style: Theme.of(context).textTheme.labelLarge),
                              Text('Drop ${run.dropTempC.toStringAsFixed(1)} C'),
                              Text('Duration ${(run.durationSec / 60).toStringAsFixed(1)} min'),
                              Text(
                                run.developmentRatioPct == null
                                    ? 'DTR n/a'
                                    : 'DTR ${run.developmentRatioPct!.toStringAsFixed(1)}%',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (validationIssues.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  validationIssues.first.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Temperature: drag dots on the solid curve. '
                'Advanced: drag squares on the dashed fan curve (0–255). '
                'Fan and temp setpoints can sit at different times (Ikawa-style). '
                'Horizontal drag moves time; keep ≥5s between points on each curve.',
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
