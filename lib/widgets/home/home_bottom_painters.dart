import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Speedometer Gauge Painter with 5 segments and labels
class SpeedometerWithLabelsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.height * 0.88;
    final strokeWidth = size.height * 0.32;

    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFFFACC15),
      const Color(0xFF84CC16),
      const Color(0xFF10B981),
    ];

    final labels = [
      'Strong\nSell',
      'Sell',
      'Neutral',
      'Buy',
      'Strong\nBuy',
    ];

    const totalAngle = math.pi;
    final segmentAngle = totalAngle / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      final startAngle = math.pi + (i * segmentAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        startAngle,
        segmentAngle,
        false,
        paint,
      );
    }

    final dividerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.6;

    for (int i = 0; i <= colors.length; i++) {
      final angle = math.pi + (i * segmentAngle);
      final rInner = radius - strokeWidth;
      final p1 = Offset(center.dx + rInner * math.cos(angle), center.dy + rInner * math.sin(angle));
      final p2 = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(p1, p2, dividerPaint);
    }

    for (int i = 0; i < labels.length; i++) {
      final midAngle = math.pi + (i + 0.5) * segmentAngle;
      final textRadius = radius - (strokeWidth / 2);
      final tx = center.dx + textRadius * math.cos(midAngle);
      final ty = center.dy + textRadius * math.sin(midAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.0,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(tx - textPainter.width / 2, ty - textPainter.height / 2),
      );
    }

    final needleAngle = math.pi + (4.4 * segmentAngle);
    final needleLength = radius * 0.82;

    final needlePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    canvas.drawLine(center, needleTip, needlePaint);

    final pivotPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(center, 6.5, pivotPaint);
    canvas.drawCircle(center, 2.8, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Subtle grid painter for maroon card
class MaroonGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gullak Pot vector icon for Bottom Bar
class GullakIconPainter extends CustomPainter {
  final Color color;

  GullakIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width * 0.35, size.height * 0.22);
    path.lineTo(size.width * 0.65, size.height * 0.22);

    path.moveTo(size.width * 0.35, size.height * 0.22);
    path.cubicTo(
      size.width * 0.05,
      size.height * 0.35,
      size.width * 0.05,
      size.height * 0.85,
      size.width * 0.50,
      size.height * 0.88,
    );
    path.cubicTo(
      size.width * 0.95,
      size.height * 0.85,
      size.width * 0.95,
      size.height * 0.35,
      size.width * 0.65,
      size.height * 0.22,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.18),
          width: size.width * 0.45,
          height: 4,
        ),
        const Radius.circular(2),
      ),
      paint,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GullakIconPainter oldDelegate) => oldDelegate.color != color;
}

/// 3D Red Gift Box Painter with Gold Bow for Referral Card
class GiftBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final boxPaint = Paint()..color = const Color(0xFFEF4444);
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.35, w * 0.75, h * 0.60),
      const Radius.circular(8),
    );
    canvas.drawRRect(boxRect, boxPaint);

    final lidPaint = Paint()..color = const Color(0xFFDC2626);
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.26, w * 0.88, h * 0.16),
      const Radius.circular(6),
    );
    canvas.drawRRect(lidRect, lidPaint);

    final ribbonPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawRect(Rect.fromLTWH(w * 0.45, h * 0.26, w * 0.15, h * 0.69), ribbonPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.08, h * 0.31, w * 0.88, h * 0.08), ribbonPaint);

    final bowPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.40, h * 0.18), width: w * 0.30, height: h * 0.18),
      bowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.65, h * 0.18), width: w * 0.30, height: h * 0.18),
      bowPaint,
    );
    canvas.drawCircle(Offset(w * 0.52, h * 0.22), 6, Paint()..color = const Color(0xFFD97706));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gold Confetti Sparkles
class ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path1 = Path()
      ..moveTo(size.width * 0.65, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.70, size.height * 0.40, size.width * 0.60, size.height * 0.65);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(size.width * 0.85, size.height * 0.20)
      ..quadraticBezierTo(size.width * 0.90, size.height * 0.50, size.width * 0.80, size.height * 0.80);
    canvas.drawPath(path2, paint);

    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.25), 2.5, Paint()..color = const Color(0xFFF59E0B));
    canvas.drawCircle(Offset(size.width * 0.58, size.height * 0.45), 2.0, Paint()..color = const Color(0xFFD97706));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

