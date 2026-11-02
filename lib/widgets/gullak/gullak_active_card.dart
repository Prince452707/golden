import 'package:flutter/material.dart';
import '../../core/models/gullak_models.dart';
import 'gullak_painters.dart';

class GullakActiveCard extends StatelessWidget {
  final VoidCallback onCompleteSetup;
  final VoidCallback? onOptionsTap;
  final GullakGoalModel? goal;
  final String title;
  final String savedAmount;
  final double progressPercentage;

  const GullakActiveCard({
    super.key,
    required this.onCompleteSetup,
    this.onOptionsTap,
    this.goal,
    this.title = 'Savings Goal',
    this.savedAmount = '₹0.00',
    this.progressPercentage = 0.0,
  });

  String get _displayTitle => goal?.title ?? title;

  String get _displaySavedAmount {
    if (goal != null) {
      return '₹${goal!.savedAmount.toStringAsFixed(2)}';
    }
    return savedAmount;
  }

  double get _displayProgress {
    if (goal != null) {
      return goal!.progressPercentage;
    }
    return progressPercentage;
  }

  @override
  Widget build(BuildContext context) {
    final isSilver = goal?.categoryId.toLowerCase() == 'silver';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Digi Gold/Silver Pill + Three dots menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: isSilver
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSilver
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFFDE68A),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 10,
                      child: CustomPaint(painter: GoldIngotIconPainter()),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isSilver ? 'Digi Silver' : 'Digi Gold',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isSilver
                            ? const Color(0xFF475569)
                            : const Color(0xFF92400E),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onOptionsTap ?? () {},
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Content Row: Savings Goal info + 3D Coins stack
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You Saved',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _displaySavedAmount,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // 3D Stack of Gold Coins
              SizedBox(
                width: 110,
                height: 84,
                child: Image.asset(
                  'assets/clean_coins_stack.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/gold_coins_stack.png',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress Bar with dynamic percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 6,
                    color: const Color(0xFFE5E7EB),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_displayProgress / 100).clamp(0.0, 1.0),
                      child: Container(
                        color: const Color(0xFF00897B),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_displayProgress.toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Complete Setup Button
          InkWell(
            onTap: onCompleteSetup,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF00897B),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00897B).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Complete Setup',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
