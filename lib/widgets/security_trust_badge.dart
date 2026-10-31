import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SecurityTrustBadge extends StatelessWidget {
  const SecurityTrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shield Icon
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.textLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 14,
                color: AppTheme.primaryTeal,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Secured By',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            // Partner 1: VISTRA
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'VISTRA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(width: 3),
                CustomPaint(
                  size: const Size(8, 8),
                  painter: _TrianglePainter(),
                ),
              ],
            ),
            Container(
              height: 12,
              width: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            // Partner 2: BRINKS
            const Text(
              'BRINKS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Color(0xFF0F3A66),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMicroPill('100% Insured'),
            const SizedBox(width: 6),
            const Text('•', style: TextStyle(color: AppTheme.textLight, fontSize: 10)),
            const SizedBox(width: 6),
            _buildMicroPill('24K 99.99% Purity'),
            const SizedBox(width: 6),
            const Text('•', style: TextStyle(color: AppTheme.textLight, fontSize: 10)),
            const SizedBox(width: 6),
            _buildMicroPill('IDBI Trusteeship'),
          ],
        ),
      ],
    );
  }

  Widget _buildMicroPill(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        color: AppTheme.textMuted,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE11D48)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

