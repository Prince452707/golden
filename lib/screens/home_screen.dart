import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'live_rates_screen.dart';
import 'profile_screen.dart';
import 'buy_screen.dart';
import 'portfolio_screen.dart';
import '../widgets/home/home_arch_painters.dart';
import '../widgets/home/home_bottom_section.dart';
import 'discover_screen.dart';
import 'gift_bullion_screen.dart';

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
        backgroundColor: const Color(0xFFFEDE77),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    // Top Radiant Golden Hero Header
                    _buildTopHeroSection(context),

                    // Main Body on Crisp White Canvas
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),

                          // 1. Two Action Cards: Buy Gold & Buy Silver
                          _buildBuyCards(context),

                          const SizedBox(height: 16),

                          // 2. "Track Price Trends & Save at the Right Time" Banner
                          _buildLowestPriceBanner(context),

                          const SizedBox(height: 20),

                          // 3. "Discover & Learn" Horizontal Scroll Section
                          _buildDiscoverAndLearnSection(context),

                          const SizedBox(height: 20),

                          // 4. Gift Gold & Silver Festive Card
                          _buildGiftBullionBanner(context),

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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GiftBullionScreen()),
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
          // Left: Total Savings, ₹101, Gold Balance Badge
          Positioned(
            left: 0,
            top: 4,
            bottom: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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

                const SizedBox(height: 10),

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

  /// Festive "Gift Gold & Silver" Banner Card
  Widget _buildGiftBullionBanner(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const GiftBullionScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFFDE68A),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD97706).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // 3D Gift Box Graphic
            SizedBox(
              width: 44,
              height: 44,
              child: Image.asset(
                'assets/clean_gift.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 12),

            // Middle Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'GIFT 24K BULLION 🎁',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB45309),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Gift Gold & Silver to Someone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Delivered instantly with a personalized card',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Gift Now Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00796B),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Gift',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// "Track Price Trends & Save at the Right Time" Banner Card
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
                    'Track Price Trends\n& Save at the Right Time',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Learn how gold prices move and\nwhen to invest.',
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
              width: 120,
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

  /// Discover & Learn Section with Tapable Header & Large Image/Description Cards
  Widget _buildDiscoverAndLearnSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tapable Header: "Discover & Learn ›" (Opens Dedicated Full Screen)
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const DiscoverScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Discover & Learn',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Enlarged Horizontal Carousel of Article Cards
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: DiscoverData.articles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final article = DiscoverData.articles[index];
              return _buildDiscoverCard(context, article);
            },
          ),
        ),
      ],
    );
  }

  /// Enlarged Individual Discover Card with Large Image, Category, Title, and Date
  Widget _buildDiscoverCard(BuildContext context, DiscoverArticle article) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DiscoverDetailScreen(article: article),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 200,
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
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Top Image Thumbnail
              SizedBox(
                height: 114,
                width: double.infinity,
                child: Image.asset(
                  article.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),

              // Content Padding
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Read Time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDFA),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF99F6E4), width: 0.8),
                          ),
                          child: Text(
                            article.category,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          article.readTime,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      article.title.replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        height: 1.25,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article.date,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
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
      ),
    );
  }
}
