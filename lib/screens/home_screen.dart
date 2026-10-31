import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'live_rates_screen.dart';
import 'profile_screen.dart';
import 'buy_screen.dart';
import 'portfolio_screen.dart';
import 'transactions_screen.dart';
import '../widgets/home/home_arch_painters.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Top Radiant Golden Hero Header
                    _buildTopHeroSection(context),

                    // Main Body on Crisp White Canvas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),

                          // 1. Two Action Cards: Buy Gold & Buy Silver
                          _buildBuyCards(context),

                          const SizedBox(height: 16),

                          // 2. Live Gold Price with Golden Wave Trend Chart
                          _buildLiveGoldPriceCard(context),

                          const SizedBox(height: 16),

                          // 3. "Lowest Gold Price in Last 6 Months" Banner
                          _buildLowestPriceBanner(context),

                          const SizedBox(height: 20),

                          // 4. Recent Activity Section
                          _buildRecentActivitySection(context),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Navigation Bar (Home [Active], Gulaks, Dashboard, Profile)
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
    );
  }

  /// Top Radiant Golden Header containing the Top Bar & Total Savings Hero
  Widget _buildTopHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.68, 1.0],
          colors: [
            Color(0xFFFEDE77),
            Color(0xFFFFE59E),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: PK Avatar, Live Rate Pill, Purple Gift, Magenta Chat
              _buildTopBar(context),

              const SizedBox(height: 14),

          
              _buildHeroTotalSavings(context),
            ],
          ),
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
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),

        const Spacer(),

        // Live Rate Pill: ((•)) ₹14,346.67/gm >
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                  child: CustomPaint(painter: BroadcastWavePainter()),
                ),
                const SizedBox(width: 6),
                const Text(
                  '₹14,346.67/gm',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF64748B),
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
                content: Text('🎁 Rewards & Gifts: Scratch cards active!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CustomPaint(painter: PurpleGiftBoxPainter()),
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
                content: Text('💬 Support: 24/7 Dedicated Gold Advisor online'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(painter: MagentaChatBubblePainter()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Total Savings Hero Area with 3D Coin Podium Graphic
  Widget _buildHeroTotalSavings(BuildContext context) {
    return SizedBox(
      height: 154,
      child: Stack(
        children: [
          // Left: Total Savings, ₹101, Gold Balance Badge, View Details Link
          Positioned(
            left: 0,
            top: 4,
            bottom: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Your Total Savings',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563),
                        letterSpacing: -0.1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '₹101',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.6,
                      ),
                    ),
                  ],
                ),

                // Gold Balance Pill
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PortfolioScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFDE68A),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/home_mini_bar.png',
                          width: 18,
                          height: 14,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '₹101 Gold Balance',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Color(0xFF0F172A),
                        ),
                      ],
                    ),
                  ),
                ),

                // View Details Link
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PortfolioScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'View details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF005953),
                            letterSpacing: -0.1,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF005953),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right: 3D Golden Podium with Rupee Coins and Upward Arrow
          Positioned(
            right: -6,
            bottom: 0,
            child: SizedBox(
              width: 195,
              height: 142,
              child: Image.asset(
                'assets/home_podium_feathered.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Two Side-by-Side Action Cards: Buy Gold & Buy Silver
  Widget _buildBuyCards(BuildContext context) {
    return Row(
      children: [
        // 1. Buy Gold Card
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BuyScreen(initialIsGold: true),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 154,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF7ED),
                    Color(0xFFFEF3C7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFED7AA).withValues(alpha: 0.6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD97706).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
              child: Stack(
                children: [
                  // Left Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Buy',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Gold',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Start investing\nin gold',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),

                      // Circle Arrow Button
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Right 3D Gold Bar Graphic
                  Positioned(
                    right: 0,
                    top: 10,
                    bottom: 10,
                    child: SizedBox(
                      width: 78,
                      child: Image.asset(
                        'assets/home_gold_bar_feathered.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 2. Buy Silver Card
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BuyScreen(initialIsGold: false),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 154,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF0F9FF),
                    Color(0xFFE0F2FE),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFBAE6FD).withValues(alpha: 0.6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
              child: Stack(
                children: [
                  // Left Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Buy',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Silver',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Invest in silver\nfor a brighter future',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),

                      // Circle Arrow Button
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Right 3D Silver Ingot Graphic
                  Positioned(
                    right: 0,
                    top: 10,
                    bottom: 10,
                    child: SizedBox(
                      width: 78,
                      child: Image.asset(
                        'assets/home_silver_bar_feathered.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Live Gold Price Card with Realtime Golden Wave Curve
  Widget _buildLiveGoldPriceCard(BuildContext context) {
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
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Live Gold Price • Live from market | View chart ->
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Live Gold Price',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Live from market',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),

              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LiveRatesScreen()),
                  );
                },
                child: Row(
                  children: const [
                    Text(
                      'View chart',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00796B),
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: Color(0xFF00796B),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Price & Chart Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price and Percentage Change
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '₹14,346.67 / gm',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(
                        Icons.arrow_drop_up_rounded,
                        size: 18,
                        color: Color(0xFF059669),
                      ),
                      Text(
                        '+0.8% (₹112.30)',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Golden Wave Line Chart
              SizedBox(
                width: 154,
                height: 52,
                child: CustomPaint(
                  painter: HomeLivePriceChartPainter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// "Lowest Gold Price in Last 6 Months" Banner Card
  Widget _buildLowestPriceBanner(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const BuyScreen(initialIsGold: true),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFBEB),
              Color(0xFFFEF3C7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.7),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD97706).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Left Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'INVEST SMARTER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF78350F),
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lowest Gold Price\nin Last 6 Months',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Best time to buy and grow\nyour savings.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Right 3D Calendar & Clock Graphic
            SizedBox(
              width: 125,
              height: 92,
              child: Image.asset(
                'assets/home_calendar_feathered.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recent Activity Section with Bought Gold & Bought Silver Transactions
  Widget _buildRecentActivitySection(BuildContext context) {
    return Column(
      children: [
        // Header Row: Recent Activity | View all ->
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                );
              },
              child: Row(
                children: const [
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00796B),
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: Color(0xFF00796B),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Activity Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Bought Gold Item
              _buildTransactionItem(
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                icon: Icons.arrow_upward_rounded,
                title: 'Bought Gold',
                date: '12 Oct 2026, 11:34 AM',
                amount: '₹2,014.00',
                quantity: '0.1380 g',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                  );
                },
              ),

              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF8FAFC),
                indent: 58,
                endIndent: 16,
              ),

              // 2. Bought Silver Item
              _buildTransactionItem(
                iconColor: const Color(0xFFEF4444),
                iconBg: const Color(0xFFFEE2E2),
                icon: Icons.arrow_downward_rounded,
                title: 'Bought Silver',
                date: '5 Oct 2026, 4:12 PM',
                amount: '₹460.50',
                quantity: '5.000 g',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required Color iconColor,
    required Color iconBg,
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required String quantity,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Round Indicator Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ),

            const SizedBox(width: 12),

            // Title & Timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Amount & Quantity
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 6),

            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Painter for the Smooth Golden Wave Curve on Live Gold Price Card
class HomeLivePriceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Normalized curve points matching the exact wave in reference:
    // Dip on left, soft crest, minor consolidation, soaring peak on top right
    final points = [
      Offset(0, h * 0.72),
      Offset(w * 0.16, h * 0.58),
      Offset(w * 0.32, h * 0.64),
      Offset(w * 0.48, h * 0.44),
      Offset(w * 0.65, h * 0.48),
      Offset(w * 0.82, h * 0.30),
      Offset(w * 0.98, h * 0.14),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cpX = (p0.dx + p1.dx) / 2;
      path.cubicTo(cpX, p0.dy, cpX, p1.dy, p1.dx, p1.dy);
    }

    // Fill underneath curve
    final fillPath = Path.from(path)
      ..lineTo(w * 0.98, h)
      ..lineTo(0, h)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFBBF24).withValues(alpha: 0.35),
          const Color(0xFFFEF3C7).withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    // Stroke the golden curve
    final strokePaint = Paint()
      ..color = const Color(0xFFEAB308)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    // Peak Glowing Golden Dot at the top right tip
    final peak = points.last;
    final auraPaint = Paint()..color = const Color(0xFFFEF08A);
    final dotPaint = Paint()..color = const Color(0xFFEAB308);
    canvas.drawCircle(peak, 4.5, auraPaint);
    canvas.drawCircle(peak, 3.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
