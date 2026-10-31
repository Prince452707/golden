import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Decorative golden sunburst rays and ambient sparkle for the Gullak header
class GullakHeaderAuraPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft warm radial glow behind the top-right gold pot
    final centerGlow = Offset(w * 0.78, h * 0.45);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE082).withValues(alpha: 0.45),
          const Color(0xFFFDC537).withValues(alpha: 0.18),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: centerGlow, radius: w * 0.5));
    canvas.drawCircle(centerGlow, w * 0.5, glowPaint);

    // Subtle golden sparkle stars
    final sparklePaint = Paint()..color = Colors.white.withValues(alpha: 0.65);
    _drawSparkle(canvas, Offset(w * 0.58, h * 0.22), 3.0, sparklePaint);
    _drawSparkle(canvas, Offset(w * 0.88, h * 0.18), 4.0, sparklePaint);
    _drawSparkle(canvas, Offset(w * 0.48, h * 0.60), 2.5, sparklePaint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius * 2.2);
    path.quadraticBezierTo(center.dx, center.dy, center.dx + radius * 2.2, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + radius * 2.2);
    path.quadraticBezierTo(center.dx, center.dy, center.dx - radius * 2.2, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - radius * 2.2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Arched warm golden backdrop behind the terracotta gullak
class CustomGullakBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Curved golden hill/arch on the right
    final path = Path();
    path.moveTo(w * 0.40, h);
    path.quadraticBezierTo(w * 0.52, h * 0.15, w, h * 0.10);
    path.lineTo(w, h);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFEF3C7),
          Color(0xFFFDE68A),
          Color(0xFFFCD34D),
        ],
      ).createShader(Rect.fromLTWH(w * 0.40, 0, w * 0.60, h));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Small Gold Ingot Icon for Digi Gold badge
class GoldIngotIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.20, h * 0.28);
    path.lineTo(w * 0.80, h * 0.28);
    path.lineTo(w * 0.95, h * 0.72);
    path.lineTo(w * 0.05, h * 0.72);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, paint);

    // Bevel highlights
    final bevelPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(w * 0.20, h * 0.28), Offset(w * 0.80, h * 0.28), bevelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Teal Gullak Pot icon for bottom navigation bar and headers
class GullakPotIconPainter extends CustomPainter {
  final Color color;
  final bool isFilled;

  const GullakPotIconPainter({
    required this.color,
    this.isFilled = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Pot body
    path.moveTo(w * 0.32, h * 0.30);
    // Left flare
    path.cubicTo(w * 0.04, h * 0.42, w * 0.08, h * 0.82, w * 0.30, h * 0.88);
    // Base
    path.lineTo(w * 0.70, h * 0.88);
    // Right flare
    path.cubicTo(w * 0.92, h * 0.82, w * 0.96, h * 0.42, w * 0.68, h * 0.30);
    // Neck
    path.lineTo(w * 0.65, h * 0.22);
    path.lineTo(w * 0.35, h * 0.22);
    path.close();

    canvas.drawPath(path, paint);

    // Lid knob on top
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.30, h * 0.12, w * 0.40, h * 0.10),
      const Radius.circular(2),
    );
    canvas.drawRRect(lidRect, paint);

    final knob = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.44, h * 0.05, w * 0.12, h * 0.08),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(knob, paint);

    // Coin slot line
    if (isFilled) {
      final slotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(w * 0.40, h * 0.46), Offset(w * 0.60, h * 0.46), slotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GullakPotIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isFilled != isFilled;
}

