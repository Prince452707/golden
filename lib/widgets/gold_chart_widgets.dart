import 'dart:math' as math;
import 'package:flutter/material.dart';

/// -------------------------------------------------------------
/// Reusable Segmented Switcher (Gold | Silver)
/// -------------------------------------------------------------
class GoldSilverSegmentedToggle extends StatelessWidget {
  final bool isGoldSelected;
  final ValueChanged<bool> onToggle;

  const GoldSilverSegmentedToggle({
    super.key,
    required this.isGoldSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(19),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isGoldSelected ? const Color(0xFF005953) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isGoldSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF005953).withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Gold',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isGoldSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isGoldSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: !isGoldSelected ? const Color(0xFF005953) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: !isGoldSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF005953).withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Silver',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: !isGoldSelected ? FontWeight.w700 : FontWeight.w600,
                      color: !isGoldSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------------------------------------------------
/// Reusable Time Filter Row (1D, 1W, 1M, 6M, 1Y, ALL)
/// -------------------------------------------------------------
class TimeFilterPillsRow extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const TimeFilterPillsRow({
    super.key,
    this.options = const ['1D', '1W', '1M', '1Y', 'ALL'],
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: options.map((opt) {
        final isSelected = opt == selected;
        return GestureDetector(
          onTap: () => onSelected(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF005953) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// -------------------------------------------------------------
/// Smooth Bezier Line Chart Painter
/// -------------------------------------------------------------
class SmoothTrendLineChart extends StatelessWidget {
  final List<double> points;
  final Color lineColor;
  final Color gradientStartColor;
  final double height;
  final bool showDots;

  const SmoothTrendLineChart({
    super.key,
    required this.points,
    this.lineColor = const Color(0xFFE2A03F),
    this.gradientStartColor = const Color(0xFFFDE68A),
    this.height = 70,
    this.showDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BezierChartPainter(
          points: points,
          lineColor: lineColor,
          gradientStartColor: gradientStartColor,
          showDots: showDots,
        ),
      ),
    );
  }
}

class _BezierChartPainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;
  final Color gradientStartColor;
  final bool showDots;

  _BezierChartPainter({
    required this.points,
    required this.lineColor,
    required this.gradientStartColor,
    required this.showDots,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minVal = points.reduce(math.min);
    final maxVal = points.reduce(math.max);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final path = Path();
    final fillPath = Path();

    final dx = size.width / (points.length - 1);
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final norm = (points[i] - minVal) / range;
      final y = size.height - (norm * (size.height * 0.75) + (size.height * 0.12));
      offsets.add(Offset(i * dx, y));
    }

    path.moveTo(offsets[0].dx, offsets[0].dy);
    fillPath.moveTo(offsets[0].dx, size.height);
    fillPath.lineTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(offsets.last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientStartColor.withValues(alpha: 0.35),
          gradientStartColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    if (showDots) {
      final dotPaint = Paint()..color = lineColor;
      final dotInner = Paint()..color = Colors.white;
      for (final p in offsets) {
        canvas.drawCircle(p, 3.5, dotPaint);
        canvas.drawCircle(p, 1.8, dotInner);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BezierChartPainter oldDelegate) => true;
}

