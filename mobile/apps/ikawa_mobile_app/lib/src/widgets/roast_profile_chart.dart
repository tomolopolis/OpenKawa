import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

enum _ChartHandleKind { temp, fan }

/// Shared plot rect and axis gutters (painter + drag hit-testing).
class _ChartLayout {
  _ChartLayout({
    required this.plot,
    required this.xMin,
    required this.xMax,
    required this.tempMin,
    required this.tempMax,
    required this.rorMin,
    required this.rorMax,
    required this.fanMin,
    required this.fanMax,
    required this.showRor,
    required this.showFan,
    required this.rorTickX,
    required this.fanTickX,
  });

  final Rect plot;
  final double xMin;
  final double xMax;
  final double tempMin;
  final double tempMax;
  final double rorMin;
  final double rorMax;
  final double fanMin;
  final double fanMax;
  final bool showRor;
  final bool showFan;

  /// Right edge for RoR tick labels (labels are right-aligned to this x).
  final double rorTickX;
  final double fanTickX;

  static const titleRowHeight = 18.0;
  static const bottomPad = 36.0;
  static const colGap = 6.0;
  static const rightMargin = 6.0;

  static _ChartLayout compute({
    required Size size,
    required RoastProfileSeries series,
    required bool showRor,
    required TextStyle labelStyle,
  }) {
    final temp = series.temp;
    final fan = series.fan;
    final showFan = fan.isNotEmpty;
    final rorDisplay = RoastProfileSeriesFactory.rorDisplayFromTempProfile(
      series.tempTimeSec,
      series.temp,
    );

    var xMin = series.timelineStartSec;
    var xMax = series.timelineEndSec;
    if (xMax <= xMin) xMax = xMin + 60;

    final tempMin = temp.reduce((a, b) => a < b ? a : b) - 4;
    final tempMax = temp.reduce((a, b) => a > b ? a : b) + 4;
    var rorMin = -2.0;
    var rorMax = 8.0;
    if (rorDisplay.ror.isNotEmpty) {
      final rorLo = rorDisplay.ror.reduce((a, b) => a < b ? a : b);
      final rorHi = rorDisplay.ror.reduce((a, b) => a > b ? a : b);
      rorMin = math.min(0.0, rorLo) - 2.0;
      rorMax = math.max(0.0, rorHi) + 2.0;
      if (rorMax <= rorMin) rorMax = rorMin + 8.0;
    }

    final fanHi = showFan ? fan.reduce((a, b) => a > b ? a : b) : 255.0;
    const fanMin = 0.0;
    final fanMax = math.max(255.0, fanHi * 1.05);

    double measure(String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      return tp.width;
    }

    var leftPad = 8.0;
    for (var i = 0; i <= 4; i++) {
      final v = tempMin + (tempMax - tempMin) * (4 - i) / 4;
      leftPad = math.max(leftPad, measure('${v.round()}') + 10);
    }
    leftPad = math.max(leftPad, measure('°C') + 10);

    var fanColW = 0.0;
    if (showFan) {
      fanColW = measure('Fan') + 4;
      for (var i = 0; i <= 4; i++) {
        final v = fanMin + (fanMax - fanMin) * (4 - i) / 4;
        fanColW = math.max(fanColW, measure(v.round().toString()) + 4);
      }
    }

    var rorColW = 0.0;
    if (showRor) {
      rorColW = measure('RoR') + 4;
      for (var i = 0; i <= 4; i++) {
        final v = rorMin + (rorMax - rorMin) * (4 - i) / 4;
        rorColW = math.max(rorColW, measure(v.toStringAsFixed(0)) + 4);
      }
    }

    final rightGutter = rightMargin + fanColW + (showRor && showFan ? colGap : 0) + rorColW;
    final plotTop = titleRowHeight + 6;
    final plot = Rect.fromLTRB(
      leftPad,
      plotTop,
      size.width - rightGutter,
      size.height - bottomPad,
    );

    var fanTickX = size.width - rightMargin;
    var rorTickX = fanTickX;
    if (showFan) {
      fanTickX = size.width - rightMargin;
      rorTickX = fanTickX - fanColW - (showRor ? colGap : 0);
    } else if (showRor) {
      rorTickX = size.width - rightMargin;
    }

    return _ChartLayout(
      plot: plot,
      xMin: xMin,
      xMax: xMax,
      tempMin: tempMin,
      tempMax: tempMax,
      rorMin: rorMin,
      rorMax: rorMax,
      fanMin: fanMin,
      fanMax: fanMax,
      showRor: showRor,
      showFan: showFan,
      rorTickX: rorTickX,
      fanTickX: fanTickX,
    );
  }
}

/// Roast profile visualization: bean temperature, fan setpoint (0–255-style), and optional RoR.
/// Temp and fan may use **different** timestamps (Ikawa protobuf shape).
class RoastProfileChart extends StatefulWidget {
  const RoastProfileChart({
    super.key,
    required this.series,
    required this.showRor,
    this.editable = false,
    this.onSeriesChanged,
    this.liveTimeSec,
    this.liveTemp,
    this.liveFan,
    this.liveRor,
  });

  final RoastProfileSeries series;
  final bool showRor;
  final bool editable;
  final ValueChanged<RoastProfileSeries>? onSeriesChanged;

  /// Elapsed roast time in seconds (shared axis with [RoastProfileSeries.timelineStartSec]–[timelineEndSec]).
  final double? liveTimeSec;
  final double? liveTemp;
  final double? liveFan;
  final double? liveRor;

  @override
  State<RoastProfileChart> createState() => _RoastProfileChartState();
}

class _RoastProfileChartState extends State<RoastProfileChart> {
  int? _draggingIndex;
  _ChartHandleKind? _draggingKind;
  Offset? _panAnchorLocal;
  double? _panAnchorTimeSec;
  double? _panAnchorTemp;
  double? _panAnchorFan;
  double? _timeSecPerPx;
  double? _tempPerPy;
  double? _fanPerPy;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tTemp = widget.series.tempTimeSec;
    final tFan = widget.series.fanTimeSec;
    final temp = widget.series.temp;
    final fanList = widget.series.fan;

    var xMin = widget.series.timelineStartSec;
    var xMax = widget.series.timelineEndSec;
    if (xMax <= xMin) xMax = xMin + 60;

    final tempMin = temp.reduce((a, b) => a < b ? a : b) - 4;
    final tempMax = temp.reduce((a, b) => a > b ? a : b) + 4;
    final hasFan = fanList.isNotEmpty;
    final fanHi = hasFan ? fanList.reduce((a, b) => a > b ? a : b) : 255.0;
    const fanAxisMin = 0.0;
    final fanAxisMax = math.max(255.0, fanHi * 1.05);
    final editableFan = widget.editable && widget.showRor && hasFan;

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight.clamp(200.0, 560.0)
            : 280.0;
        final chartSize = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 320,
          h,
        );
        final labelStyle = textTheme.labelSmall ?? const TextStyle(fontSize: 11);
        final layout = _ChartLayout.compute(
          size: chartSize,
          series: widget.series,
          showRor: widget.showRor,
          labelStyle: labelStyle,
        );
        final plot = layout.plot;

        double xToPx(double sec) => plot.left + (sec - xMin) / (xMax - xMin) * plot.width;
        double tempToPx(double v) => plot.bottom - (v - tempMin) / (tempMax - tempMin) * plot.height;
        double fanToPx(double v) =>
            plot.bottom - (v - fanAxisMin) / (fanAxisMax - fanAxisMin) * plot.height;

        ({int index, _ChartHandleKind kind}) pickHandle(Offset local) {
          const hit = 26.0;
          final hit2 = hit * hit;
          var bestI = 0;
          var bestKind = _ChartHandleKind.temp;
          var bestD2 = double.infinity;

          double d2(Offset a, Offset b) => (a.dx - b.dx) * (a.dx - b.dx) + (a.dy - b.dy) * (a.dy - b.dy);

          for (var i = 0; i < tTemp.length; i++) {
            final pt = Offset(xToPx(tTemp[i]), tempToPx(temp[i]));
            final dist = d2(local, pt);
            if (dist < bestD2) {
              bestD2 = dist;
              bestI = i;
              bestKind = _ChartHandleKind.temp;
            }
          }

          if (editableFan) {
            for (var i = 0; i < tFan.length; i++) {
              final pf = Offset(xToPx(tFan[i]), fanToPx(fanList[i]));
              final dist = d2(local, pf);
              if (dist < bestD2) {
                bestD2 = dist;
                bestI = i;
                bestKind = _ChartHandleKind.fan;
              }
            }
          }

          if (bestD2 <= hit2) {
            return (index: bestI, kind: bestKind);
          }

          var bestX = 0;
          var bestDx = double.infinity;
          for (var i = 0; i < tTemp.length; i++) {
            final dx = (xToPx(tTemp[i]) - local.dx).abs();
            if (dx < bestDx) {
              bestDx = dx;
              bestX = i;
            }
          }
          return (index: bestX, kind: _ChartHandleKind.temp);
        }

        void applyDrag(Offset local) {
          if (!widget.editable || _draggingIndex == null || _draggingKind == null || widget.onSeriesChanged == null) {
            return;
          }
          final idx = _draggingIndex!;
          final kind = _draggingKind!;
          final anchor = _panAnchorLocal;
          final anchorTime = _panAnchorTimeSec;
          final secPerPx = _timeSecPerPx;
          if (anchor == null || anchorTime == null || secPerPx == null) return;

          const minGap = 5.0;
          final dx = local.dx - anchor.dx;
          final dy = local.dy - anchor.dy;

          if (kind == _ChartHandleKind.temp) {
            final times = [...widget.series.tempTimeSec];
            final nextTemp = [...widget.series.temp];
            var newSec = anchorTime + dx * secPerPx;
            if (idx == 0) {
              newSec = newSec.clamp(0.0, times[1] - minGap);
            } else if (idx == times.length - 1) {
              newSec = newSec.clamp(times[idx - 1] + minGap, math.max(times[idx - 1] + minGap, tFan.last) + 7200.0);
            } else {
              newSec = newSec.clamp(times[idx - 1] + minGap, times[idx + 1] - minGap);
            }
            times[idx] = newSec;
            final anchorTemp = _panAnchorTemp;
            final tPerPy = _tempPerPy;
            if (anchorTemp == null || tPerPy == null) return;
            nextTemp[idx] = (anchorTemp - dy * tPerPy).clamp(120.0, 260.0);
            widget.onSeriesChanged!(
              widget.series.copyWith(tempTimeSec: times, temp: nextTemp),
            );
          } else {
            final fanTimes = [...widget.series.fanTimeSec];
            final fanVals = [...widget.series.fan];
            var newSec = anchorTime + dx * secPerPx;
            if (idx == 0) {
              newSec = newSec.clamp(0.0, fanTimes[1] - minGap);
            } else if (idx == fanTimes.length - 1) {
              newSec = newSec.clamp(fanTimes[idx - 1] + minGap, fanTimes[idx - 1] + 7200.0);
            } else {
              newSec = newSec.clamp(fanTimes[idx - 1] + minGap, fanTimes[idx + 1] - minGap);
            }
            fanTimes[idx] = newSec;
            final anchorFan = _panAnchorFan;
            final fPerPy = _fanPerPy;
            if (anchorFan == null || fPerPy == null) return;
            fanVals[idx] = (anchorFan - dy * fPerPy).clamp(0.0, 255.0);
            widget.onSeriesChanged!(
              widget.series.copyWith(fanTimeSec: fanTimes, fan: fanVals),
            );
          }
        }

        return SizedBox(
          height: h,
          width: constraints.maxWidth.isFinite ? constraints.maxWidth : double.infinity,
          child: GestureDetector(
            onPanStart: widget.editable
                ? (d) {
                    final picked = pickHandle(d.localPosition);
                    final span = xMax - xMin;
                    final timeSecPerPx = span > 0 ? span / plot.width : 0.0;
                    final tempSpan = tempMax - tempMin;
                    final tempPerPy = tempSpan > 0 ? tempSpan / plot.height : 0.0;
                    final fanSpan = fanAxisMax - fanAxisMin;
                    final fanPerPy = fanSpan > 0 ? fanSpan / plot.height : 0.0;
                    setState(() {
                      _draggingIndex = picked.index;
                      _draggingKind = picked.kind;
                      _panAnchorLocal = d.localPosition;
                      if (picked.kind == _ChartHandleKind.temp) {
                        _panAnchorTimeSec = tTemp[picked.index];
                        _panAnchorTemp = temp[picked.index];
                        _panAnchorFan = null;
                      } else {
                        _panAnchorTimeSec = tFan[picked.index];
                        _panAnchorFan = fanList[picked.index];
                        _panAnchorTemp = null;
                      }
                      _timeSecPerPx = timeSecPerPx;
                      _tempPerPy = tempPerPy;
                      _fanPerPy = fanPerPy;
                    });
                  }
                : null,
            onPanUpdate: widget.editable ? (d) => applyDrag(d.localPosition) : null,
            onPanEnd: widget.editable
                ? (_) => setState(() {
                      _draggingIndex = null;
                      _draggingKind = null;
                      _panAnchorLocal = null;
                      _panAnchorTimeSec = null;
                      _panAnchorTemp = null;
                      _panAnchorFan = null;
                      _timeSecPerPx = null;
                      _tempPerPy = null;
                      _fanPerPy = null;
                    })
                : null,
            child: CustomPaint(
              painter: _RoastProfileChartPainter(
                series: widget.series,
                showRor: widget.showRor,
                liveTimeSec: widget.liveTimeSec,
                liveTemp: widget.liveTemp,
                liveFan: widget.liveFan,
                liveRor: widget.liveRor,
                editable: widget.editable,
                editableFanHandles: editableFan,
                tempColor: scheme.primary,
                rorColor: scheme.tertiary,
                fanColor: scheme.secondary,
                gridColor: scheme.outlineVariant.withValues(alpha: 0.5),
                axisColor: scheme.onSurfaceVariant,
                labelStyle: labelStyle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoastProfileChartPainter extends CustomPainter {
  _RoastProfileChartPainter({
    required this.series,
    required this.showRor,
    required this.liveTimeSec,
    required this.liveTemp,
    required this.liveFan,
    required this.liveRor,
    required this.editable,
    required this.editableFanHandles,
    required this.tempColor,
    required this.rorColor,
    required this.fanColor,
    required this.gridColor,
    required this.axisColor,
    required this.labelStyle,
  });

  final RoastProfileSeries series;
  final bool showRor;
  final double? liveTimeSec;
  final double? liveTemp;
  final double? liveFan;
  final double? liveRor;
  final bool editable;
  final bool editableFanHandles;
  final Color tempColor;
  final Color rorColor;
  final Color fanColor;
  final Color gridColor;
  final Color axisColor;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _ChartLayout.compute(
      size: size,
      series: series,
      showRor: showRor,
      labelStyle: labelStyle,
    );
    final plot = layout.plot;
    final tTemp = series.tempTimeSec;
    final tFan = series.fanTimeSec;
    final temp = series.temp;
    final fan = series.fan;
    final showFan = layout.showFan;
    final xMin = layout.xMin;
    final xMax = layout.xMax;
    final tempMin = layout.tempMin;
    final tempMax = layout.tempMax;
    final rorMin = layout.rorMin;
    final rorMax = layout.rorMax;
    final fanMin = layout.fanMin;
    final fanMax = layout.fanMax;

    double xToPx(double sec) => plot.left + (sec - xMin) / (xMax - xMin) * plot.width;
    double tempToPx(double v) => plot.bottom - (v - tempMin) / (tempMax - tempMin) * plot.height;
    double rorToPx(double v) => plot.bottom - (v - rorMin) / (rorMax - rorMin) * plot.height;
    double fanToPx(double v) => plot.bottom - (v - fanMin) / (fanMax - fanMin) * plot.height;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final tx = plot.left + plot.width * i / 4;
      canvas.drawLine(Offset(tx, plot.top), Offset(tx, plot.bottom), gridPaint);
    }
    for (var i = 0; i <= 4; i++) {
      final ty = plot.top + plot.height * i / 4;
      canvas.drawLine(Offset(plot.left, ty), Offset(plot.right, ty), gridPaint);
    }

    canvas.drawRect(plot, Paint()..style = PaintingStyle.stroke..color = axisPaint.color);

    final tempPath = Path()..moveTo(xToPx(tTemp[0]), tempToPx(temp[0]));
    for (var i = 1; i < tTemp.length; i++) {
      tempPath.lineTo(xToPx(tTemp[i]), tempToPx(temp[i]));
    }
    canvas.drawPath(
      tempPath,
      Paint()
        ..color = tempColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    if (editable) {
      for (var i = 0; i < tTemp.length; i += math.max(1, tTemp.length ~/ 24)) {
        canvas.drawCircle(
          Offset(xToPx(tTemp[i]), tempToPx(temp[i])),
          4.5,
          Paint()..color = tempColor.withValues(alpha: 0.85),
        );
      }
    }

    if (showFan) {
      final fanPath = Path()..moveTo(xToPx(tFan[0]), fanToPx(fan[0]));
      for (var i = 1; i < tFan.length; i++) {
        fanPath.lineTo(xToPx(tFan[i]), fanToPx(fan[i]));
      }
      _strokePathDashed(
        canvas,
        fanPath,
        Paint()
          ..color = fanColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.75
          ..strokeCap = StrokeCap.round,
      );
      if (editableFanHandles) {
        for (var i = 0; i < tFan.length; i += math.max(1, tFan.length ~/ 24)) {
          final pyFan = fanToPx(fan[i]);
          final r = Rect.fromCenter(center: Offset(xToPx(tFan[i]), pyFan), width: 10, height: 10);
          canvas.drawRRect(
            RRect.fromRectAndRadius(r, const Radius.circular(2)),
            Paint()..color = fanColor.withValues(alpha: 0.9),
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(r, const Radius.circular(2)),
            Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5,
          );
        }
      }
    }

    if (showRor) {
      final display = RoastProfileSeriesFactory.rorDisplayFromTempProfile(tTemp, temp);
      if (display.timeSec.length >= 2) {
        final rorPath = Path()
          ..moveTo(xToPx(display.timeSec[0]), rorToPx(display.ror[0]));
        for (var i = 1; i < display.timeSec.length; i++) {
          rorPath.lineTo(xToPx(display.timeSec[i]), rorToPx(display.ror[i]));
        }
        canvas.drawPath(
          rorPath,
          Paint()
            ..color = rorColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    }

    final liveT = liveTimeSec;
    final ltRaw = liveTemp;
    if (liveT != null && ltRaw != null) {
      final tClamped = liveT.clamp(xMin, xMax);
      final lx = xToPx(tClamped);
      final dashPaint = Paint()
        ..color = axisColor.withValues(alpha: 0.6)
        ..strokeWidth = 1;
      _drawDashedLine(canvas, Offset(lx, plot.top), Offset(lx, plot.bottom), dashPaint);

      final lt = ltRaw.clamp(tempMin, tempMax);
      final py = tempToPx(lt);
      canvas.drawCircle(Offset(lx, py), 6, Paint()..color = tempColor);
      canvas.drawCircle(Offset(lx, py), 6, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

      final lf = liveFan;
      if (showFan && lf != null) {
        final fv = lf.clamp(fanMin, fanMax);
        final pyFan = fanToPx(fv);
        final r = Rect.fromCenter(center: Offset(lx, pyFan), width: 9, height: 9);
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(2)),
          Paint()..color = fanColor,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(2)),
          Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5,
        );
      }

      final lr = liveRor;
      if (showRor && lr != null) {
        final lrClamped = lr.clamp(rorMin, rorMax);
        final pyRor = rorToPx(lrClamped);
        canvas.drawCircle(Offset(lx, pyRor), 5, Paint()..color = rorColor);
        canvas.drawCircle(Offset(lx, pyRor), 5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      }
    }

    const titleY = 4.0;
    _paintLabel(canvas, '°C', const Offset(6, titleY));

    if (showRor) {
      _paintLabelRight(canvas, 'RoR', layout.rorTickX, titleY);
    }
    if (showFan) {
      _paintLabelRight(canvas, 'Fan', layout.fanTickX, titleY);
    }

    _paintLabel(
      canvas,
      'Time (min)',
      Offset(plot.left + plot.width / 2 - 28, size.height - _ChartLayout.bottomPad + 4),
    );
    for (var i = 0; i <= 4; i++) {
      final sec = xMin + (xMax - xMin) * i / 4;
      final label = (sec / 60).toStringAsFixed(0);
      final tx = plot.left + plot.width * i / 4;
      _paintLabel(canvas, label, Offset(tx - 6, plot.bottom + 4));
    }

    for (var i = 0; i <= 4; i++) {
      final v = tempMin + (tempMax - tempMin) * (4 - i) / 4;
      final ty = plot.top + plot.height * i / 4;
      _paintLabelRight(canvas, '${v.round()}', plot.left - 4, ty - 6);
    }

    if (showRor) {
      for (var i = 0; i <= 4; i++) {
        final v = rorMin + (rorMax - rorMin) * (4 - i) / 4;
        final ty = plot.top + plot.height * i / 4;
        _paintLabelRight(canvas, v.toStringAsFixed(0), layout.rorTickX, ty - 6);
      }
    }

    if (showFan) {
      for (var i = 0; i <= 4; i++) {
        final v = fanMin + (fanMax - fanMin) * (4 - i) / 4;
        final ty = plot.top + plot.height * i / 4;
        _paintLabelRight(canvas, v.round().toString(), layout.fanTickX, ty - 6);
      }
    }
  }

  void _strokePathDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      var draw = true;
      while (d < metric.length) {
        final seg = draw ? 6.0 : 4.0;
        final end = math.min(d + seg, metric.length);
        if (draw) {
          canvas.drawPath(metric.extractPath(d, end), paint);
        }
        d = end;
        draw = !draw;
      }
    }
  }

  void _paintLabel(Canvas canvas, String text, Offset offset) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: labelStyle.copyWith(color: axisColor)),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  void _paintLabelRight(Canvas canvas, String text, double rightX, double y) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: labelStyle.copyWith(color: axisColor)),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(rightX - tp.width, y));
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 6.0;
    const gap = 4.0;
    final d = b - a;
    final len = d.distance;
    if (len <= 0) return;
    final dir = d / len;
    var pos = 0.0;
    while (pos < len) {
      final p0 = a + dir * pos;
      final p1 = a + dir * (pos + dash).clamp(0.0, len);
      canvas.drawLine(p0, p1, paint);
      pos += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _RoastProfileChartPainter oldDelegate) {
    final s = series;
    final o = oldDelegate.series;
    return !listEquals(s.temp, o.temp) ||
        !listEquals(s.tempTimeSec, o.tempTimeSec) ||
        !listEquals(s.fan, o.fan) ||
        !listEquals(s.fanTimeSec, o.fanTimeSec) ||
        oldDelegate.showRor != showRor ||
        oldDelegate.liveTimeSec != liveTimeSec ||
        oldDelegate.liveTemp != liveTemp ||
        oldDelegate.liveFan != liveFan ||
        oldDelegate.liveRor != liveRor ||
        oldDelegate.editable != editable ||
        oldDelegate.editableFanHandles != editableFanHandles ||
        oldDelegate.tempColor != tempColor ||
        oldDelegate.rorColor != rorColor ||
        oldDelegate.fanColor != fanColor;
  }
}
