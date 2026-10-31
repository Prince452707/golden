import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';
import 'price_history_screen.dart';

class LiveRatesScreen extends StatefulWidget {
  const LiveRatesScreen({super.key});

  @override
  State<LiveRatesScreen> createState() => _LiveRatesScreenState();
}

class _LiveRatesScreenState extends State<LiveRatesScreen> {
  bool _isGoldSelected = true;
  String _goldFilter = '1M';
  String _silverFilter = '1M';

  // Sample data points matching screenshot curve
  final List<double> _goldPoints = [
    13950, 14020, 13880, 14100, 13990, 14220, 14180, 14350, 14290, 14370.20
  ];

  final List<double> _silverPoints = [
    88.5, 89.2, 88.0, 90.1, 89.4, 91.0, 90.2, 91.8, 91.2, 92.14
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar: Back Arrow + "Live Rates"
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
                    'Live Rates',
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
                    // Segmented Switcher (Gold | Silver)
                    GoldSilverSegmentedToggle(
                      isGoldSelected: _isGoldSelected,
                      onToggle: (val) {
                        setState(() {
                          _isGoldSelected = val;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Card 1: Gold (24K)
                    _buildGoldRateCard(),

                    const SizedBox(height: 16),

                    // Card 2: Silver (999)
                    _buildSilverRateCard(),

                    const SizedBox(height: 24),

                    // Section: Price Details
                    const Text(
                      'Price Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPriceDetailsTable(),

                    const SizedBox(height: 20),

                    // Footer Info Note with info icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF94A3B8), width: 1.2),
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Prices are live and include applicable GST.\nRates may change based on market conditions.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldRateCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PriceHistoryScreen()),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.0,
          ),
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
            Row(
              children: [
                const GoldBar3DWidget(width: 58, height: 44),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gold (24K)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '₹14,370.20',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            ' / gm',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: const [
                          Icon(Icons.arrow_drop_up_rounded, size: 18, color: Color(0xFF10B981)),
                          Text(
                            '+0.8% today',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Golden Smooth Chart
            SmoothTrendLineChart(
              points: _goldPoints,
              lineColor: const Color(0xFFE5A83B),
              gradientStartColor: const Color(0xFFFDE68A),
              height: 60,
            ),

            const SizedBox(height: 8),

            // Filter Pills Row
            TimeFilterPillsRow(
              selected: _goldFilter,
              onSelected: (val) {
                setState(() {
                  _goldFilter = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSilverRateCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
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
          Row(
            children: [
              const GoldBar3DWidget(width: 58, height: 44, isSilver: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Silver (999)',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '₹92.14',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          ' / gm',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        Icon(Icons.arrow_drop_up_rounded, size: 18, color: Color(0xFF10B981)),
                        Text(
                          '+1.2% today',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Silver / Cyan Smooth Chart
          SmoothTrendLineChart(
            points: _silverPoints,
            lineColor: const Color(0xFF0E948B),
            gradientStartColor: const Color(0xFFA7F3D0),
            height: 60,
          ),

          const SizedBox(height: 8),

          // Filter Pills Row
          TimeFilterPillsRow(
            selected: _silverFilter,
            onSelected: (val) {
              setState(() {
                _silverFilter = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildDetailRow('Gold Buying Price (incl. GST)', '₹14,370.20'),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Gold Selling Price', '₹14,102.30'),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Silver Buying Price (incl. GST)', '₹92.14'),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Silver Selling Price', '₹87.60'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

