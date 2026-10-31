import 'dart:math' as math;
import 'package:flutter/material.dart';

export 'gold_chart_widgets.dart';


class GoldBar3DWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isSilver;

  const GoldBar3DWidget({
    super.key,
    this.width = 54,
    this.height = 42,
    this.isSilver = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _IngotPainter(isSilver: isSilver),
      ),
    );
  }
}

class _IngotPainter extends CustomPainter {
  final bool isSilver;

  _IngotPainter({required this.isSilver});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Drop shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final shadowPath = Path()
      ..moveTo(w * 0.15, h * 0.75)
      ..lineTo(w * 0.85, h * 0.75)
      ..lineTo(w * 0.95, h * 0.95)
      ..lineTo(w * 0.05, h * 0.95)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Color palettes
    final topColors = isSilver
        ? [const Color(0xFFFFFFFF), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]
        : [const Color(0xFFFFF7C2), const Color(0xFFFFD54F), const Color(0xFFF59E0B)];

    final frontColors = isSilver
        ? [const Color(0xFFCBD5E1), const Color(0xFF94A3B8), const Color(0xFF64748B)]
        : [const Color(0xFFF59E0B), const Color(0xFFD97706), const Color(0xFFB45309)];

    final sideColors = isSilver
        ? [const Color(0xFF94A3B8), const Color(0xFF64748B), const Color(0xFF475569)]
        : [const Color(0xFFD97706), const Color(0xFFB45309), const Color(0xFF78350F)];

    // 1. Front Trapezoid Face
    final frontPath = Path()
      ..moveTo(w * 0.12, h * 0.40)
      ..lineTo(w * 0.75, h * 0.25)
      ..lineTo(w * 0.75, h * 0.75)
      ..lineTo(w * 0.12, h * 0.90)
      ..close();

    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: frontColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(frontPath, frontPaint);

    // 2. Right Side Face
    final sidePath = Path()
      ..moveTo(w * 0.75, h * 0.25)
      ..lineTo(w * 0.94, h * 0.15)
      ..lineTo(w * 0.94, h * 0.65)
      ..lineTo(w * 0.75, h * 0.75)
      ..close();

    final sidePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: sideColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(sidePath, sidePaint);

    // 3. Top Face (Slanted Ingot Surface)
    final topPath = Path()
      ..moveTo(w * 0.12, h * 0.40)
      ..lineTo(w * 0.38, h * 0.12)
      ..lineTo(w * 0.94, h * 0.15)
      ..lineTo(w * 0.75, h * 0.25)
      ..close();

    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: topColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(topPath, topPaint);

    // Specular Highlight Ridge
    final ridgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.12, h * 0.40), Offset(w * 0.75, h * 0.25), ridgePaint);
    canvas.drawLine(Offset(w * 0.75, h * 0.25), Offset(w * 0.94, h * 0.15), ridgePaint);

    // Ingot Text Stamp ("999.9" or "999.0")
    final textPainter = TextPainter(
      text: TextSpan(
        text: isSilver ? '999.0\nSILVER' : '999.9\nGOLD',
        style: TextStyle(
          color: (isSilver ? const Color(0xFF475569) : const Color(0xFF78350F)).withValues(alpha: 0.85),
          fontSize: h * 0.12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(w * 0.42, h * 0.55);
    canvas.rotate(-0.18);
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _IngotPainter oldDelegate) => oldDelegate.isSilver != isSilver;
}

/// -------------------------------------------------------------
/// Realistic 3D Stack of Shiny Gold Coins (Used on Screen 4 - Sell)
/// -------------------------------------------------------------
class GoldCoinsStackWidget extends StatelessWidget {
  final double width;
  final double height;

  const GoldCoinsStackWidget({
    super.key,
    this.width = 65,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CoinsStackPainter(),
      ),
    );
  }
}

class _CoinsStackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw 2 stacks of coins
    _drawCoinPillar(canvas, Offset(w * 0.28, h * 0.65), w * 0.45, h * 0.22, 4);
    _drawCoinPillar(canvas, Offset(w * 0.68, h * 0.50), w * 0.48, h * 0.24, 7);
  }

  void _drawCoinPillar(Canvas canvas, Offset bottomCenter, double width, double height, int count) {
    const coinThickness = 4.2;

    for (int i = 0; i < count; i++) {
      final y = bottomCenter.dy - (i * coinThickness);
      final rect = Rect.fromCenter(center: Offset(bottomCenter.dx, y), width: width, height: height);

      // Edge of coin (cylinder side)
      final edgePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFB45309),
            Color(0xFFF59E0B),
            Color(0xFFFFFBEB),
            Color(0xFFF59E0B),
            Color(0xFF78350F),
          ],
        ).createShader(rect);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(rect.left, rect.top, rect.width, coinThickness + 2),
          Radius.circular(height / 2),
        ),
        edgePaint,
      );

      // Top oval of coin
      final topPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.2, -0.3),
          radius: 0.85,
          colors: [
            Color(0xFFFFFDE7),
            Color(0xFFFFD54F),
            Color(0xFFF59E0B),
            Color(0xFFD97706),
          ],
        ).createShader(rect);

      canvas.drawOval(rect, topPaint);

      // Inner rim
      final innerRect = rect.deflate(2.0);
      final rimPaint = Paint()
        ..color = const Color(0xFFB45309).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawOval(innerRect, rimPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// -------------------------------------------------------------
/// Realistic 3D Single Gold Coin (Used on Screen 5 - Portfolio)
/// -------------------------------------------------------------
class GoldCoinSingleWidget extends StatelessWidget {
  final double size;

  const GoldCoinSingleWidget({
    super.key,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SingleCoinPainter(),
      ),
    );
  }
}

class _SingleCoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Shadow
    canvas.drawCircle(
      center.translate(1, 2),
      radius - 1,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Outer milled rim
    final outerPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xFFD97706),
          Color(0xFFFFF7C2),
          Color(0xFFF59E0B),
          Color(0xFF78350F),
          Color(0xFFFFF7C2),
          Color(0xFFD97706),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, outerPaint);

    // Inner bevel
    final innerRadius = radius - 3.5;
    final innerPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        radius: 0.9,
        colors: [
          Color(0xFFFFFBEB),
          Color(0xFFFBBF24),
          Color(0xFFD97706),
          Color(0xFF92400E),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius));
    canvas.drawCircle(center, innerRadius, innerPaint);

    // Coin emblem: Embossed "S" / Gullak mark
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'S',
        style: TextStyle(
          color: Color(0xFF78350F),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          fontFamily: 'serif',
          shadows: [
            Shadow(
              color: Color(0xFFFFFBEB),
              offset: Offset(-0.8, -0.8),
              blurRadius: 0,
            ),
            Shadow(
              color: Color(0xFF451A03),
              offset: Offset(0.8, 0.8),
              blurRadius: 1,
            ),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

