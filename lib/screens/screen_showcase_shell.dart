import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'live_rates_screen.dart';
import 'buy_screen.dart';
import 'sell_screen.dart';
import 'portfolio_screen.dart';
import 'transactions_screen.dart';
import 'price_history_screen.dart';
import 'profile_screen.dart';
import 'gullaks_screen.dart';
import 'gullak_goals_screen.dart';

class ScreenShowcaseShell extends StatefulWidget {
  const ScreenShowcaseShell({super.key});

  @override
  State<ScreenShowcaseShell> createState() => _ScreenShowcaseShellState();
}

class _ScreenShowcaseShellState extends State<ScreenShowcaseShell> {
  int _activeScreenIndex = 0;
  bool _isSwitcherVisible = false; // Hidden by default to leave bottom completely unobstructed
  bool _isGridOverviewMode = false;

  final List<String> _screenTitles = [
    '1. Home',
    '2. Live Rates',
    '3. Buy',
    '4. Sell',
    '5. My Portfolio',
    '6. Transactions',
    '7. Price History',
    '8. Profile',
    '9. Gullaks (Section)',
    '10. What\'s your goal? (Goals)',
  ];

  Widget _getScreenWidget(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const LiveRatesScreen();
      case 2:
        return const BuyScreen();
      case 3:
        return const SellScreen();
      case 4:
        return const PortfolioScreen();
      case 5:
        return const TransactionsScreen();
      case 6:
        return const PriceHistoryScreen();
      case 7:
        return const ProfileScreen();
      case 8:
        return const GullaksScreen();
      case 9:
        return const GullakGoalsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isGridOverviewMode) {
      return _buildGridOverview();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // The Active Screen
          Positioned.fill(
            child: _getScreenWidget(_activeScreenIndex),
          ),

          // Discreet Switcher Launcher Button at Top-Right
          if (!_isSwitcherVisible)
            Positioned(
              top: 50,
              right: 14,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isSwitcherVisible = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers_rounded, size: 13, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '#${_activeScreenIndex + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Floating Screen Showcase Switcher Pill (Shown only when opened)
          if (_isSwitcherVisible)
            Positioned(
              bottom: 24,
              left: 12,
              right: 12,
              child: _buildFloatingSwitcher(),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '8-Screen Replica Switcher',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              // Grid View Toggle
              InkWell(
                onTap: () {
                  setState(() {
                    _isGridOverviewMode = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.dashboard_rounded, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '2×4 Grid',
                        style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Hide / Close
              InkWell(
                onTap: () {
                  setState(() {
                    _isSwitcherVisible = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _screenTitles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final isSelected = index == _activeScreenIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _activeScreenIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00AAA1) : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        _screenTitles[index],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 2x4 Grid Overview matching the exact layout of the uploaded image!
  Widget _buildGridOverview() {
    return Scaffold(
      backgroundColor: const Color(0xFFFDD76D), // Yellow backdrop matching image border
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Exact 8-Screen Replica (2×4 Grid)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isGridOverviewMode = false;
              });
            },
            icon: const Icon(Icons.fullscreen_rounded, color: Color(0xFF005953)),
            label: const Text(
              'Interactive Mode',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF005953)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildGridRow([0, 1, 2, 3]),
            const SizedBox(height: 16),
            _buildGridRow([4, 5, 6, 7]),
          ],
        ),
      ),
    );
  }

  Widget _buildGridRow(List<int> indices) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - (indices.length - 1) * 10) / indices.length;
        final cardHeight = cardWidth * 1.95;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: indices.map((index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _activeScreenIndex = index;
                  _isGridOverviewMode = false;
                });
              },
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: 390,
                          height: 844,
                          child: IgnorePointer(
                            child: _getScreenWidget(index),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#${index + 1}',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
