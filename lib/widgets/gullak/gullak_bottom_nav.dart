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
              pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
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
              pageBuilder: (context, animation, secondaryAnimation) => const GullaksScreen(),
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
              pageBuilder: (context, animation, secondaryAnimation) => const PortfolioScreen(),
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
              pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(
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
            icon: Icons.home_rounded,
            onTap: () => _onTapTab(context, 0),
          ),
          _buildGullakItem(
            context: context,
            index: 1,
            label: 'Goals',
            onTap: () => _onTapTab(context, 1),
          ),
          _buildItem(
            context: context,
            index: 2,
            label: 'Dashboard',
            icon: Icons.bar_chart_rounded,
            onTap: () => _onTapTab(context, 2),
          ),
          _buildItem(
            context: context,
            index: 3,
            label: 'Profile',
            icon: Icons.person_outline_rounded,
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
    final color = isSelected ? const Color(0xFF00796B) : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3.5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE6F4F1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 2),
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
    final color = isSelected ? const Color(0xFF00796B) : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3.5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE6F4F1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CustomPaint(
                  painter: GullakPotIconPainter(
                    color: color,
                    isFilled: isSelected,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
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
