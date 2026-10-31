import 'package:flutter/material.dart';
import '../../screens/portfolio_screen.dart';
import '../../screens/buy_screen.dart';
import '../../screens/sell_screen.dart';
import 'home_arch_painters.dart';

class HomeTotalSavingsArchCard extends StatelessWidget {
  const HomeTotalSavingsArchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              painter: FadingArchDomePainter(),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 375),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 104,
                      height: 7.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5B252).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(4.5),
                      ),
                    ),

                    const SizedBox(height: 36),

                    const Text(
                      'TOTAL SAVINGS',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.8,
                        color: Color(0xFF94723C),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '₹101',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: -1.2,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Transform.translate(
                      offset: const Offset(0, 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFFFDF8), Color(0xFFFFF7E2)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFFDE68A).withValues(alpha: 0.75),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD49B28).withValues(alpha: 0.16),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
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
                              width: 25,
                              height: 17,
                              child: CustomPaint(painter: RealisticBanknotePainter()),
                            ),
                            const SizedBox(width: 9),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹101 ',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Gullak Cash',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF475569),
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 16.5,
                              color: Color(0xFF334155),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    Transform.translate(
                      offset: const Offset(0, 36),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const PortfolioScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.32),
                                Colors.white.withValues(alpha: 0.32),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'View details',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF00544E),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 17,
                                color: Color(0xFF00544E),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: -4,
              left: cardWidth * 0.22,
              child: IgnorePointer(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CustomPaint(painter: ArchRadiantFlarePainter()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomeMainActionButtons extends StatelessWidget {
  const HomeMainActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BuyScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005953),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Invest more',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SellScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF7E2),
                foregroundColor: const Color(0xFF005953),
                elevation: 0,
                side: const BorderSide(color: Color(0xFFFDE68A), width: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Withdraw',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

