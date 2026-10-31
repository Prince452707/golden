import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/home/home_arch_painters.dart';
import '../widgets/gullak/gullak_models.dart';
import '../widgets/gullak/gullak_card.dart';
import '../widgets/gullak/gullak_active_card.dart';
import '../widgets/gullak/gullak_custom_banner.dart';
import '../widgets/gullak/gullak_trust_row.dart';
import '../widgets/gullak/gullak_bottom_nav.dart';
import '../widgets/gullak/gullak_setup_modal.dart';
import '../widgets/gullak/gullak_painters.dart';
import 'gullak_goals_screen.dart';
import 'buy_screen.dart';
import 'live_rates_screen.dart';
import 'profile_screen.dart';

class GullaksScreen extends StatefulWidget {
  final String userName;
  final String? phoneNumber;

  const GullaksScreen({
    super.key,
    this.userName = 'Prince Kumar',
    this.phoneNumber,
  });

  @override
  State<GullaksScreen> createState() => _GullaksScreenState();
}

class _GullaksScreenState extends State<GullaksScreen> {
  int _selectedBottomNavIndex = 1;

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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Top Golden Ambient Header Area
                    _buildGoldenHeader(context),

                    // Main Body Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),

                          // 1. "Set up a new Gullak" + "View all ->"
                          _buildSectionHeader(
                            title: 'Set up a new Gullak',
                            onViewAll: () => _navigateToAllGoals(context),
                          ),
                          const SizedBox(height: 12),

                          // Horizontal Scrolling Goal Cards
                          SizedBox(
                            height: 154,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: GullakGoal.allGoals.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final goal = GullakGoal.allGoals[index];
                                return GullakGoalCard(
                                  goal: goal,
                                  width: 104,
                                  height: 154,
                                  isCarousel: true,
                                  onTap: () {
                                    _openGoalSetup(context, goal);
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // 2. "Your Gullaks" + "View all ->"
                          _buildSectionHeader(
                            title: 'Your Gullaks',
                            onViewAll: () => _navigateToAllGoals(context),
                          ),
                          const SizedBox(height: 12),

                          // Active Saving Card (Daily Saving ₹0)
                          GullakActiveCard(
                            onCompleteSetup: () {
                              _openGoalSetup(
                                context,
                                GullakGoal.allGoals[1], // Gold Savings
                              );
                            },
                            onOptionsTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Daily Saving Settings: Active & Running'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // 3. "Have a different goal?"
                          const Text(
                            'Have a different goal?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Custom Gullak Banner Card
                          GullakCustomGoalCard(
                            onSetupNow: () {
                              _openGoalSetup(
                                context,
                                GullakGoal.allGoals.last, // Custom Gullak
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // 4. "Why Gullak?"
                          const WhyGullakSection(),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar (Home, Gullaks [active], Dashboard, Profile)
            GullakBottomNav(
              selectedIndex: _selectedBottomNavIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedBottomNavIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Warm golden glowing header matching the exact replica
  Widget _buildGoldenHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.50, 0.82, 1.0],
          colors: [
            Color(0xFFFFDA72),
            Color(0xFFFED670),
            Color(0xFFFDD56E),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Ambient sparkle rays behind the pot
            Positioned.fill(
              child: CustomPaint(
                painter: GullakHeaderAuraPainter(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Status Bar: PK Avatar, Live Rate Chip, Purple Gift, Magenta Chat
                  _buildTopBar(context),

                  const SizedBox(height: 12),

                  // Header Visual & Titles Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left: Gullaks title & subtitle
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gullaks',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF111827),
                                  letterSpacing: -0.6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Small savings for your big dreams',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                  letterSpacing: -0.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Subtle black accent underline dash
                              Container(
                                width: 28,
                                height: 2.2,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111827),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right: 3D Golden Pot with overflowing coins (clean transparent, seamless)
                      SizedBox(
                        width: 165,
                        height: 112,
                        child: Image.asset(
                          'assets/clean_header_pot.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomRight,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // User Avatar Circle "PK"
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  userName: widget.userName,
                  phoneNumber: widget.phoneNumber ?? '+91 98765 43210',
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'PK',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.2,
                ),
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
                content: Text('Gullak Support: 24/7 Dedicated Gold Advisor online'),
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

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.3,
          ),
        ),
        InkWell(
          onTap: onViewAll,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00897B),
                  ),
                ),
                SizedBox(width: 3),
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
    );
  }

  void _navigateToAllGoals(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GullakGoalsScreen(),
      ),
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

