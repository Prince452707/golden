import 'package:flutter/material.dart';

class GullakCustomGoalCard extends StatelessWidget {
  final VoidCallback onSetupNow;

  const GullakCustomGoalCard({
    super.key,
    required this.onSetupNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Right-aligned authentic terracotta pot and gold coins (clean, zero text, seamless)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 145,
              child: Image.asset(
                'assets/clean_custom_gullak.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),

            // Left Content: Text
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 140, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Set up a',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Custom Goal',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create your own goal and save\nin gold your way',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: onSetupNow,
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Setup now',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00897B),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: Color(0xFF00897B),
                          ),
                        ],
                      ),
                    ),
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
