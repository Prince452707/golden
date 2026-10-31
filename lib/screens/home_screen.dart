import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'live_rates_screen.dart';
import 'profile_screen.dart';
import '../widgets/home/home_arch_painters.dart';
import '../widgets/home/home_savings_card.dart';
import '../widgets/home/home_bottom_section.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String? phoneNumber;

  const HomeScreen({
    super.key,
    this.userName = 'Prince Kumar',
    this.phoneNumber,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDC537),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.45, 1.0],
              colors: [
                Color(0xFFFFD464),
                Color(0xFFFCC842),
                Color(0xFFFDCF58),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // 1. Top Bar: PK Avatar, Live Rate Chip, Purple Gift Box, Magenta Chat
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildTopBar(),
                        ),

                        const SizedBox(height: 6),

                        // 2. Gullak Arch / Dome "TOTAL SAVINGS" Card with Radiant Sparkle Flare
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: HomeTotalSavingsArchCard(),
                        ),

                        const SizedBox(height: 16),

                        // 3. Two Main Action Buttons: "Invest more" & "Withdraw"
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: HomeMainActionButtons(),
                        ),

                        const SizedBox(height: 22),

                        // 4. White Lower Section: Speedometer Gauge + Trending Banner
                        const HomeWhiteBottomSection(),
                      ],
                    ),
                  ),
                ),

                // 5. Bottom Navigation Bar (Home, Gullaks, Dashboard)
                HomeBottomNav(
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
        ),
      ),
    );
  }

  Widget _buildTopBar() {
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'PK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF262626),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),

        const Spacer(),

        // Live Rate Chip: ((•)) 14,346.67/gm
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LiveRatesScreen()),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5).withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
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
                  '14,346.67/gm',
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
              color: const Color(0xFFFFFDF5).withValues(alpha: 0.94),
              shape: BoxShape.circle,
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
                content: Text('Gullak Support: 24/7 Dedicated Relationship Manager online'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5).withValues(alpha: 0.94),
              shape: BoxShape.circle,
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
}
