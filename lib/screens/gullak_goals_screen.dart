import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/home/home_arch_painters.dart';
import '../widgets/gullak/gullak_models.dart';
import '../widgets/gullak/gullak_card.dart';
import '../widgets/gullak/gullak_trust_row.dart';
import '../widgets/gullak/gullak_setup_modal.dart';
import 'buy_screen.dart';
import 'live_rates_screen.dart';

class GullakGoalsScreen extends StatelessWidget {
  const GullakGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: true,
          child: Column(
            children: [
              const SizedBox(height: 6),

              // 1. Top Bar: Back Button, Live Rate Chip, Purple Gift, Magenta Chat
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTopBar(context),
              ),

              const SizedBox(height: 16),

              // 2. Scrollable Body: Title, Subtitle, 2-Column Grid, Bottom Trust Card
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Titles
                      const Text(
                        "What's your goal?",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Choose a goal to start your Gold Saving journey',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const SizedBox(height: 18),

                     
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: GullakGoal.allGoals.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.935,
                        ),
                        itemBuilder: (context, index) {
                          final goal = GullakGoal.allGoals[index];
                          return GullakGoalCard(
                            goal: goal,
                            isCarousel: false,
                            onTap: () {
                              _openGoalSetup(context, goal);
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Trust Badges at bottom
                      const GoalScreenTrustCard(),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Back Button
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 0.8,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ),

        const Spacer(),

        // Live Rate Chip: ((•)) 14,139.83/gm
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LiveRatesScreen()),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFFEE685).withValues(alpha: 0.7),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CustomPaint(
                    painter: BroadcastWavePainter(),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '14,139.83/gm',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 3D Purple Gift Box Circle Button
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rewards & Gifts: Daily 24K gold scratch cards active!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CustomPaint(
                  painter: PurpleGiftBoxPainter(),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 3D Magenta Chat Speech Bubble Circle Button
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Goal Support: 24/7 Dedicated Gold Advisor online'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: MagentaChatBubblePainter(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openGoalSetup(BuildContext context, GullakGoal goal) {
    GullakSetupModal.show(
      context: context,
      goal: goal,
      onProceedToPayment: (initialDeposit, targetAmount, frequency) {
        // Direct transition into payment / Buy screen allocated to this goal
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BuyScreen(
              initialIsGold: true,
              goalName: goal.title,
              initialAmount: initialDeposit,
            ),
          ),
        );
      },
    );
  }
}

