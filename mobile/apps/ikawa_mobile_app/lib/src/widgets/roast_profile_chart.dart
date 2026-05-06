import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

/// Roast profile visualization: bean temperature, fan setpoint (0–255-style), and optional RoR.
/// Pass [liveTimeSec], [liveTemp], [liveFan], and optionally [liveRor] during an active roast.
class RoastProfileChart extends StatelessWidget {
  const RoastProfileChart({
    super.key,
    required this.series,
    required this.showRor,
    this.liveTimeSec,
    this.liveTemp,
    this.liveFan,
    this.liveRor,
  });

  final RoastProfileSeries series;
  final bool showRor;

  /// Elapsed roast time in seconds (same time base as [RoastProfileSeries.timeSec]).
  final double? liveTimeSec;
  final double? liveTemp;
  final double? liveFan;
  final double? liveRor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight.clamp(200.0, 560.0)
            : 280.0;
        return SizedBox(
          height: h,
          width: constraints.maxWidth.isFinite ? constraints.maxWidth : double.infinity,
          child: CustomPaint(
            painter: _RoastProfileChartPainter(
              series: series,
              showRor: showRor,
              liveTimeSec: liveTimeSec,
              liveTemp: liveTemp,
              liveFan: liveFan,
              liveRor: liveRor,
              tempColor: scheme.primary,
              rorColor: scheme.tertiary,
              fanColor: scheme.secondary,
              gridColor: scheme.outlineVariant.withValues(alpha: 0.5),
              axisColor: scheme.onSurfaceVariant,
              labelStyle: textTheme.labelSmall ?? const TextStyle(fontSize: 11),
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
  final Color tempColor;
  final Color rorColor;
  final Color fanColor;
  final Color gridColor;
  final Color axisColor;
  final TextStyle labelStyle;

  static const _leftPad = 44.0;
  static const _rorAxisW = 46.0;
  static const _fanAxisW = 42.0;
  static const _rightPadMin = 10.0;
  static const _bottomPad = 36.0;
  static const _topPad = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final t = series.timeSec;
    final temp = series.temp;
    final ror = series.ror;
    final fan = series.fan;
    final showFan = fan.isNotEmpty;

    final xMin = t.first;
    final xMax = t.last;
    final tempMin = temp.reduce((a, b) => a < b ? a : b) - 4;
    final tempMax = temp.reduce((a, b) => a > b ? a : b) + 4;
    final rorLo = ror.reduce((a, b) => a < b ? a : b);
    final rorHi = ror.reduce((a, b) => a > b ? a : b);
    var rorMin = math.min(0.0, rorLo) - 2.0;
    var rorMax = math.max(0.0, rorHi) + 2.0;
    if (rorMax <= rorMin) {
      rorMax = rorMin + 8.0;
    }

    final fanHi = showFan ? fan.reduce((a, b) => a > b ? a : b) : 255.0;
    final fanMin = 0.0;
    final fanMax = math.max(255.0, fanHi * 1.05);

    var rightPad = _rightPadMin;
    if (showRor) rightPad += _rorAxisW;
    if (showFan) rightPad += _fanAxisW;

    final plot = Rect.fromLTRB(
      _leftPad,
      _topPad,
      size.width - rightPad,
      size.height - _bottomPad,
    );

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

    final tempPath = Path()..moveTo(xToPx(t[0]), tempToPx(temp[0]));
    for (var i = 1; i < t.length; i++) {
      tempPath.lineTo(xToPx(t[i]), tempToPx(temp[i]));
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

    if (showFan) {
      final fanPath = Path()..moveTo(xToPx(t[0]), fanToPx(fan[0]));
      for (var i = 1; i < t.length; i++) {
        fanPath.lineTo(xToPx(t[i]), fanToPx(fan[i]));
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
    }

    if (showRor) {
      final rorPath = Path()..moveTo(xToPx(t[0]), rorToPx(ror[0]));
      for (var i = 1; i < t.length; i++) {
        rorPath.lineTo(xToPx(t[i]), rorToPx(ror[i]));
      }
      canvas.drawPath(
        rorPath,
        Paint()
          ..color = rorColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
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

    _paintLabel(canvas, 'Time (min)', Offset(plot.left + plot.width / 2 - 28, size.height - 18));
    for (var i = 0; i <= 4; i++) {
      final sec = xMin + (xMax - xMin) * i / 4;
      final label = (sec / 60).toStringAsFixed(0);
      final tx = plot.left + plot.width * i / 4;
      _paintLabel(canvas, label, Offset(tx - 6, plot.bottom + 4));
    }

    for (var i = 0; i <= 4; i++) {
      final v = tempMin + (tempMax - tempMin) * (4 - i) / 4;
      final ty = plot.top + plot.height * i / 4;
      _paintLabel(canvas, '${v.round()}', Offset(4, ty - 6));
    }

    var xRor = plot.right + 4.0;
    if (showRor) {
      for (var i = 0; i <= 4; i++) {
        final v = rorMin + (rorMax - rorMin) * (4 - i) / 4;
        final ty = plot.top + plot.height * i / 4;
        _paintLabel(canvas, v.toStringAsFixed(0), Offset(xRor, ty - 6));
      }
      _paintLabel(canvas, 'RoR', Offset(xRor, 4));
    }

    if (showFan) {
      final xFan = plot.right + (showRor ? _rorAxisW : 0) + 4;
      for (var i = 0; i <= 4; i++) {
        final v = fanMin + (fanMax - fanMin) * (4 - i) / 4;
        final ty = plot.top + plot.height * i / 4;
        _paintLabel(canvas, v.round().toString(), Offset(xFan, ty - 6));
      }
      _paintLabel(canvas, 'Fan', Offset(xFan, 4));
    }

    _paintLabel(canvas, '°C', Offset(8, 4));
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
    return oldDelegate.series != series ||
        oldDelegate.showRor != showRor ||
        oldDelegate.liveTimeSec != liveTimeSec ||
        oldDelegate.liveTemp != liveTemp ||
        oldDelegate.liveFan != liveFan ||
        oldDelegate.liveRor != liveRor ||
        oldDelegate.tempColor != tempColor ||
        oldDelegate.rorColor != rorColor ||
        oldDelegate.fanColor != fanColor;
  }
}
