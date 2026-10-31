import 'package:flutter/material.dart';
import 'gullak_models.dart';

class GullakGoalCard extends StatelessWidget {
  final GullakGoal goal;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final bool isCarousel;

  const GullakGoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    this.width,
    this.height,
    this.isCarousel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: goal.gradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // 1. Clean 3D Illustration (transparent background, perfectly aligned)
                Positioned(
                  left: 6,
                  right: 6,
                  bottom: 2,
                  top: isCarousel ? 40 : 44,
                  child: Image.asset(
                    goal.cleanImageAsset,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.savings_rounded,
                          size: 36,
                          color: goal.titleColor,
                        ),
                      );
                    },
                  ),
                ),

                // 2. Top-Left Native Crisp Vector Typography
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        goal.prefix,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.1,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        goal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'serif',
                          color: goal.titleColor,
                          letterSpacing: -0.3,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Bottom-Right Circular Vector Arrow Button
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
