import 'package:flutter/material.dart';
import '../../screens/buy_screen.dart';
import '../../screens/portfolio_screen.dart';
import '../../screens/transactions_screen.dart';
import 'home_bottom_painters.dart';

class HomeWhiteBottomSection extends StatelessWidget {
  const HomeWhiteBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Lowest Gold Price in Last 6 Months',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 14),
          HomeSpeedometerCard(),
          SizedBox(height: 20),
          Text(
            'Trending',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 12),
          HomeTrendingCard(),
        ],
      ),
    );
  }
}

class HomeSpeedometerCard extends StatelessWidget {
  const HomeSpeedometerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF4A1017),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A1017).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(painter: MaroonGridPainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE68A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'BEST TIME TO BUY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF451A03),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 250,
                  height: 125,
                  child: CustomPaint(painter: SpeedometerWithLabelsPainter()),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Get Extra',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '5% Gold FREE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFBBF24),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.35),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Lowest Gold Price in Last 6 Months',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFDE68A),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BuyScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFBEB),
                      foregroundColor: const Color(0xFF1E293B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF0F172A)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTrendingCard extends StatelessWidget {
  const HomeTrendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 122,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8DE), Color(0xFFFEF3C7), Color(0xFFFDE68A)],
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
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: ConfettiPainter())),
            Positioned(
              right: 12,
              bottom: 4,
              top: 8,
              width: 90,
              child: CustomPaint(painter: GiftBoxPainter()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 110, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Win Assured ',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1B4B),
                          ),
                        ),
                        TextSpan(
                          text: '₹1000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF831843),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'For every successful referral\nyou bring in!',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF78350F),
                      height: 1.25,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Referral link copied! Share with friends to win ₹1000.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005953),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Refer Now',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 12),
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

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            context: context,
            index: 0,
            label: 'Home',
            icon: Icons.home_rounded,
            onTap: () => onTabSelected(0),
          ),
          _buildGullakItem(
            context: context,
            index: 1,
            label: 'Gullaks',
            onTap: () {
              onTabSelected(1);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TransactionsScreen()),
              );
            },
          ),
          _buildItem(
            context: context,
            index: 2,
            label: 'Dashboard',
            icon: Icons.pie_chart_outline_rounded,
            onTap: () {
              onTabSelected(2);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PortfolioScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF00AAA1) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGullakItem({
    required BuildContext context,
    required int index,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF00AAA1) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CustomPaint(painter: GullakIconPainter(color: color)),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

