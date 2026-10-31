import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../../screens/gullaks_screen.dart';
import '../../screens/portfolio_screen.dart';
import '../../screens/profile_screen.dart';
import 'gullak_painters.dart';

class GullakBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const GullakBottomNav({
    super.key,
    this.selectedIndex = 1,
    this.onTabSelected,
  });

  void _onTapTab(BuildContext context, int targetIndex) {
    if (targetIndex == selectedIndex) return;

    if (onTabSelected != null) {
      onTabSelected!(targetIndex);
    }

    switch (targetIndex) {
      case 0: // Home
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        }
        break;

      case 1: // Gullaks
        if (selectedIndex == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const GullaksScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const GullaksScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        }
        break;

      case 2: // Dashboard (Portfolio)
        if (selectedIndex == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PortfolioScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const PortfolioScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        }
        break;

      case 3: // Profile
        if (selectedIndex == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(
                userName: 'Prince Kumar',
                phoneNumber: '+91 98765 43210',
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const ProfileScreen(
                userName: 'Prince Kumar',
                phoneNumber: '+91 98765 43210',
              ),
              transitionDuration: Duration.zero,
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: bottomInset > 0 ? bottomInset + 4 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            context: context,
            index: 0,
            label: 'Home',
            icon: selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
            onTap: () => _onTapTab(context, 0),
          ),
          _buildGullakItem(
            context: context,
            index: 1,
            label: 'Gullaks',
            onTap: () => _onTapTab(context, 1),
          ),
          _buildItem(
            context: context,
            index: 2,
            label: 'Dashboard',
            icon: selectedIndex == 2
                ? Icons.pie_chart_rounded
                : Icons.pie_chart_outline_rounded,
            onTap: () => _onTapTab(context, 2),
          ),
          _buildItem(
            context: context,
            index: 3,
            label: 'Profile',
            icon: selectedIndex == 3
                ? Icons.person_rounded
                : Icons.person_outline_rounded,
            onTap: () => _onTapTab(context, 3),
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
    final color = isSelected ? const Color(0xFF00897B) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 23, color: color),
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
    final color = isSelected ? const Color(0xFF00897B) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CustomPaint(
                painter: GullakPotIconPainter(color: color, isFilled: isSelected),
              ),
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

typedef AppBottomNav = GullakBottomNav;
