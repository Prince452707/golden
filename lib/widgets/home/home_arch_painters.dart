import 'dart:math' as math;
import 'package:flutter/material.dart';

class BroadcastWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFE11D48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, 1.8, Paint()..color = const Color(0xFFE11D48));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 4.2),
      math.pi * 0.70,
      math.pi * 0.60,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 4.2),
      -math.pi * 0.30,
      math.pi * 0.60,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 6.8),
      math.pi * 0.72,
      math.pi * 0.56,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 6.8),
      -math.pi * 0.28,
      math.pi * 0.56,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Purple Gift Box with Golden Bow matching screenshot
class PurpleGiftBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.16, h * 0.36, w * 0.68, h * 0.58),
      const Radius.circular(4),
    );
    final boxPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFA855F7), Color(0xFF7E22CE)],
      ).createShader(boxRect.outerRect);
    canvas.drawRRect(boxRect, boxPaint);

    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.26, w * 0.80, h * 0.16),
      const Radius.circular(3),
    );
    final lidPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFC084FC), Color(0xFF9333EA)],
      ).createShader(lidRect.outerRect);
    canvas.drawRRect(lidRect, lidPaint);

    final ribbonPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawRect(Rect.fromLTWH(w * 0.44, h * 0.26, w * 0.12, h * 0.68), ribbonPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.10, h * 0.31, w * 0.80, h * 0.06), ribbonPaint);

    final bowPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.18), width: w * 0.26, height: h * 0.16),
      bowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.62, h * 0.18), width: w * 0.26, height: h * 0.16),
      bowPaint,
    );
    canvas.drawCircle(Offset(w * 0.50, h * 0.22), 2.5, Paint()..color = const Color(0xFFD97706));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Magenta Chat Speech Bubble
class MagentaChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.08, w * 0.84, h * 0.72),
        Radius.circular(w * 0.36),
      ),
    );

    path.moveTo(w * 0.24, h * 0.70);
    path.lineTo(w * 0.14, h * 0.94);
    path.lineTo(w * 0.40, h * 0.78);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE879F9), Color(0xFFD946EF), Color(0xFFA21CAF)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(path, paint);

    final glossPath = Path();
    glossPath.addOval(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.24), width: w * 0.56, height: h * 0.18),
    );
    canvas.drawPath(glossPath, Paint()..color = Colors.white.withValues(alpha: 0.35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gullak Cash Ticket
class GoldCashTicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final ticketPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFDE68A), Color(0xFFF59E0B), Color(0xFFD97706)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(rrect, ticketPaint);

    final punchPaint = Paint()..color = const Color(0xFFFFFDF5);
    canvas.drawCircle(Offset(0, h / 2), 2.2, punchPaint);
    canvas.drawCircle(Offset(w, h / 2), 2.2, punchPaint);

    final coinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(Offset(w / 2, h / 2), 3.2, coinPaint);
    canvas.drawCircle(Offset(w / 2, h / 2), 1.2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Realistic Gold Banknote matching screenshot
class RealisticBanknotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(-0.12);
    canvas.translate(-w / 2, -h / 2);

    final shadowPaint = Paint()
      ..color = const Color(0xFFB45309).withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0.5, 1.5, w - 1, h - 1.5), const Radius.circular(2.5)),
      shadowPaint,
    );

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFF099),
          Color(0xFFFBBF24),
          Color(0xFFF59E0B),
          Color(0xFFD97706),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final noteRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(2.8),
    );
    canvas.drawRRect(noteRRect, bodyPaint);

    final dashPaint = Paint()
      ..color = const Color(0xFFB45309).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final innerRect = Rect.fromLTWH(2.0, 1.8, w - 4.0, h - 3.6);
    canvas.drawRRect(RRect.fromRectAndRadius(innerRect, const Radius.circular(1.6)), dashPaint);

    final circlePaint = Paint()
      ..color = const Color(0xFFFFFBEB).withValues(alpha: 0.92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.85;
    canvas.drawCircle(Offset(w / 2, h / 2), 3.2, circlePaint);
    canvas.drawCircle(Offset(w / 2, h / 2), 1.3, Paint()..color = const Color(0xFF78350F));

    final markPaint = Paint()..color = const Color(0xFFB45309).withValues(alpha: 0.7);
    canvas.drawCircle(Offset(3.2, 3.2), 0.7, markPaint);
    canvas.drawCircle(Offset(w - 3.2, 3.2), 0.7, markPaint);
    canvas.drawCircle(Offset(3.2, h - 3.2), 0.7, markPaint);
    canvas.drawCircle(Offset(w - 3.2, h - 3.2), 0.7, markPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Frosted Glass Dome with Arc Rim Line that Vanishes as it curves lower
class FadingArchDomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const apexY = 2.0;
    const hDrop = 112.0;
    final chordHalf = w / 2;
    final r = (hDrop / 2) + (chordHalf * chordHalf) / (2 * hDrop);

    final fillPath = Path();
    fillPath.moveTo(0, h);
    fillPath.lineTo(0, apexY + hDrop);
    fillPath.arcToPoint(
      Offset(w, apexY + hDrop),
      radius: Radius.circular(r),
      clockwise: true,
    );
    fillPath.lineTo(w, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.35, 0.70, 1.0],
        colors: [
          Colors.white.withValues(alpha: 0.48),
          Colors.white.withValues(alpha: 0.28),
          Colors.white.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    final strokePath = Path();
    final sideDrop = apexY + hDrop + 36.0;
    strokePath.moveTo(0, sideDrop);
    strokePath.lineTo(0, apexY + hDrop);
    strokePath.arcToPoint(
      Offset(w, apexY + hDrop),
      radius: Radius.circular(r),
      clockwise: true,
    );
    strokePath.lineTo(w, sideDrop);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.18, 0.42, 0.70],
        colors: [
          Colors.white.withValues(alpha: 0.98),
          Colors.white.withValues(alpha: 0.80),
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Radiant Specular Lens Flare on Arch Rim
class ArchRadiantFlarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.48)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, 12, glowPaint);

    final hRayPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.95),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCenter(center: center, width: size.width, height: 3.5));
    canvas.drawRect(Rect.fromCenter(center: center, width: size.width, height: 2.2), hRayPaint);

    final vRayPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.95),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCenter(center: center, width: 3.5, height: size.height));
    canvas.drawRect(Rect.fromCenter(center: center, width: 2.2, height: size.height), vRayPaint);

    final starPath = Path()
      ..moveTo(center.dx, center.dy - 14)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + 14, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + 14)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - 14, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - 14)
      ..close();
    canvas.drawPath(starPath, Paint()..color = Colors.white);

    canvas.drawCircle(center, 3.2, Paint()..color = const Color(0xFFFFFBEB));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

