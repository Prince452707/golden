import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';
import 'price_history_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  bool _isGoldSelected = true;
  String _selectedRange = '1M';

  final List<double> _chartPoints = [
    11500, 11620, 11480, 11750, 11600, 11890, 11780, 12050, 11980, 12169.24
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar: Back Arrow + "My Portfolio"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          size: 28,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Portfolio Value Mint Card
                    _buildTotalPortfolioCard(),

                    const SizedBox(height: 16),

                    // Segmented Toggle: Gold | Silver
                    GoldSilverSegmentedToggle(
                      isGoldSelected: _isGoldSelected,
                      onToggle: (val) {
                        setState(() {
                          _isGoldSelected = val;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Holdings Detailed Card
                    _buildHoldingsCard(),
                  ],
                ),
              ),
            ),

            // Bottom "View Price History →" Button
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPortfolioCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7F5), // Mint / light icy teal
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFBBEAE4),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Portfolio Value',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '₹12,480.32',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_drop_up_rounded, size: 16, color: Color(0xFF15803D)),
                    Text(
                      '+2.14% (+₹261.80)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 3 Golden Vertical Bars Graphic
          SizedBox(
            width: 44,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(height: 22, color: const Color(0xFFFDE68A)),
                _buildBar(height: 34, color: const Color(0xFFFCD34D)),
                _buildBar(height: 48, color: const Color(0xFFF59E0B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar({required double height, required Color color}) {
    return Container(
      width: 9,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildHoldingsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top Row: Quantity + Value + 3D Gold Coin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '0.8452 g',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '≈ ₹12,169.24',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const GoldCoinSingleWidget(size: 48),
            ],
          ),

          const SizedBox(height: 16),

          // 3 Stats Columns: Invested, Current Value, Gain
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCol('Invested', '₹8,250.00'),
              _buildStatCol('Current Value', '₹12,169.24'),
              _buildStatCol('Gain', '+6.23%', isGain: true),
            ],
          ),

          const SizedBox(height: 14),

          // Chart
          SmoothTrendLineChart(
            points: _chartPoints,
            lineColor: const Color(0xFFE5A83B),
            gradientStartColor: const Color(0xFFFDE68A),
            height: 75,
          ),

          const SizedBox(height: 10),

          // Filter Pills
          TimeFilterPillsRow(
            selected: _selectedRange,
            onSelected: (val) {
              setState(() {
                _selectedRange = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(String label, String value, {bool isGain = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGain)
              const Icon(Icons.arrow_drop_up_rounded, size: 16, color: Color(0xFF10B981)),
            Text(
              isGain ? '▲ $value' : value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isGain ? const Color(0xFF10B981) : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PriceHistoryScreen()),
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View Price History',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

