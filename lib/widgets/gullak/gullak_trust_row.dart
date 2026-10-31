import 'package:flutter/material.dart';

/// "Why Gullak?" 3-column benefit card row in Gullaks Screen
class WhyGullakSection extends StatelessWidget {
  const WhyGullakSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why Goals?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.savings_outlined,
                title: 'Disciplined\nSavings',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.account_balance_outlined,
                title: 'Build for\nyour Goals',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildBenefitCard(
                icon: Icons.verified_user_outlined,
                title: '100% Secure\n& Insured',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF00897B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

/// Trust Badges at bottom of "What's your goal?" Screen
class GoalScreenTrustCard extends StatelessWidget {
  const GoalScreenTrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            icon: Icons.monetization_on_outlined,
            title: 'Save in Digital\nGold',
          ),
          Container(
            width: 1,
            height: 36,
            color: const Color(0xFFE2E8F0),
          ),
          _buildItem(
            icon: Icons.track_changes_rounded,
            title: 'Reach your\nGoals Faster',
          ),
          Container(
            width: 1,
            height: 36,
            color: const Color(0xFFE2E8F0),
          ),
          _buildItem(
            icon: Icons.shield_outlined,
            title: 'Safe &\nInsured',
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF00897B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

