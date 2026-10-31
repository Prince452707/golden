import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';
import '../widgets/gullak/gullak_bottom_nav.dart';
import 'buy_screen.dart';
import 'sell_screen.dart';
import 'live_rates_screen.dart';
import 'price_history_screen.dart';
import 'gullaks_screen.dart';
import 'gullak_goals_screen.dart';

class PortfolioScreen extends StatefulWidget {
  final bool initialIsGold;

  const PortfolioScreen({
    super.key,
    this.initialIsGold = true,
  });

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late bool _isGoldSelected;
  String _selectedRange = '1M';

  // Live Market Rates
  final double _goldLiveRate = 14370.20;
  final double _silverLiveRate = 92.14;

  // Gold Holdings Data
  final double _goldGrams = 0.8474;
  final double _goldInvested = 10500.00;
  double get _goldCurrentValue => _goldGrams * _goldLiveRate;
  double get _goldGain => _goldCurrentValue - _goldInvested;
  double get _goldGainPct => (_goldGain / _goldInvested) * 100;
  double get _goldAvgPrice => _goldInvested / _goldGrams;

  // Silver Holdings Data
  final double _silverGrams = 35.5000;
  final double _silverInvested = 2800.00;
  double get _silverCurrentValue => _silverGrams * _silverLiveRate;
  double get _silverGain => _silverCurrentValue - _silverInvested;
  double get _silverGainPct => (_silverGain / _silverInvested) * 100;
  double get _silverAvgPrice => _silverInvested / _silverGrams;

  // Total Combined Portfolio
  double get _totalPortfolioValue => _goldCurrentValue + _silverCurrentValue;
  double get _totalInvested => _goldInvested + _silverInvested;
  double get _totalGain => _totalPortfolioValue - _totalInvested;
  double get _totalGainPct => (_totalGain / _totalInvested) * 100;

  final List<double> _goldChartPoints = [
    11500, 11620, 11480, 11750, 11600, 11890, 11780, 12050, 11980, 12177.31
  ];

  final List<double> _silverChartPoints = [
    2750, 2820, 2790, 2890, 2950, 3020, 3110, 3180, 3210, 3270.97
  ];

  // Goals allocation breakdown for Gold
  final List<Map<String, dynamic>> _goldGoalAllocations = [
    {
      'title': 'Daily Saving',
      'subtitle': 'Daily Auto-Save Goal',
      'grams': 0.3000,
      'targetAmount': 10000.0,
      'savedAmount': 4311.06,
      'asset': 'assets/clean_coins_stack.png',
      'tag': 'Active Daily',
      'tagColor': Color(0xFF00897B),
    },
    {
      'title': 'Dream House',
      'subtitle': 'Long Term Home Goal',
      'grams': 0.3500,
      'targetAmount': 500000.0,
      'savedAmount': 5029.57,
      'asset': 'assets/clean_house.png',
      'tag': 'Target: 2028',
      'tagColor': Color(0xFF6366F1),
    },
    {
      'title': 'Perfect Wedding',
      'subtitle': 'Wedding Gold Savings',
      'grams': 0.1300,
      'targetAmount': 200000.0,
      'savedAmount': 1868.13,
      'asset': 'assets/clean_wedding.png',
      'tag': 'Target: 2026',
      'tagColor': Color(0xFFEC4899),
    },
    {
      'title': 'Flexible (Free) Gold',
      'subtitle': 'Unallocated • Ready to withdraw or move',
      'grams': 0.0674,
      'targetAmount': 0.0,
      'savedAmount': 968.58,
      'asset': null,
      'tag': 'Free Gold',
      'tagColor': Color(0xFFD97706),
    },
  ];

  // Goals allocation breakdown for Silver
  final List<Map<String, dynamic>> _silverGoalAllocations = [
    {
      'title': 'Silver Coins & Bars',
      'subtitle': 'Physical Pure Silver reserve',
      'grams': 25.0000,
      'targetAmount': 4607.0,
      'savedAmount': 2303.50,
      'asset': null,
      'tag': '50% of 50g',
      'tagColor': Color(0xFF475569),
    },
    {
      'title': 'Festive Gifting Silver',
      'subtitle': 'Silver coins for family & festivals',
      'grams': 10.5000,
      'targetAmount': 1842.0,
      'savedAmount': 967.47,
      'asset': 'assets/clean_gift.png',
      'tag': 'Festive',
      'tagColor': Color(0xFFB45309),
    },
  ];

  @override
  void initState() {
    super.initState();
    _isGoldSelected = widget.initialIsGold;
  }

  String _formatCurrency(double val) {
    return '₹${val.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App Bar: Back Arrow + "My Portfolio"
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Total Combined Portfolio Value Card
                    _buildTotalPortfolioCard(),

                    const SizedBox(height: 14),

                    // 2. High-Visibility "Buy Gold" & "Buy Silver" Action Buttons
                    _buildQuickBuySection(),

                    const SizedBox(height: 16),

                    // 3. Asset Selector Toggle: Gold | Silver
                    GoldSilverSegmentedToggle(
                      isGoldSelected: _isGoldSelected,
                      onToggle: (val) {
                        setState(() {
                          _isGoldSelected = val;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // 4. Detailed Metal Holdings Card with Live Quantity, Invested, Return & Chart
                    _buildHoldingsCard(),

                    const SizedBox(height: 22),

                    // 5. Holdings by Goal Section (The Goal Allocations requested by user)
                    _buildHoldingsByGoalSection(),

                    const SizedBox(height: 20),

                    // 6. View Full Price History Button
                    _buildPriceHistoryButton(),
                  ],
                ),
              ),
            ),

            // Pinned 4-Tab Bottom Navigation Bar (Dashboard selected - index 2)
            const GullakBottomNav(selectedIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
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
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LiveRatesScreen()),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.sensors_rounded, size: 14, color: Color(0xFFB45309)),
                    SizedBox(width: 4),
                    Text(
                      'Live Rates',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Top Card showing the Total Combined Portfolio Value across Gold & Silver
  Widget _buildTotalPortfolioCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6F7F5),
            Color(0xFFDCF3F0),
            Color(0xFFCEECE8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF99DCD4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00796B).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL PORTFOLIO VALUE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF004D40),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatCurrency(_totalPortfolioValue),
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),

              // 3D Visual Asset
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const GoldCoinSingleWidget(size: 40),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Gain Badge & Invested
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_drop_up_rounded, size: 18, color: Color(0xFF059669)),
                    Text(
                      '+${_totalGainPct.toStringAsFixed(2)}% (+${_formatCurrency(_totalGain)})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Invested: ${_formatCurrency(_totalInvested)}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFB2DFDB)),
          const SizedBox(height: 12),

          // Metal Quantity Breakdown Badges
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '24K Gold Holding',
                            style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${_goldGrams.toStringAsFixed(4)} g',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '99.9% Silver Holding',
                            style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${_silverGrams.toStringAsFixed(2)} g',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Easy, Prominent "Buy Gold" & "Buy Silver" Quick-Action Buttons
  Widget _buildQuickBuySection() {
    return Column(
      children: [
        Row(
          children: [
            // BUY GOLD BUTTON
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BuyScreen(initialIsGold: true),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD97706).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline_rounded, size: 20, color: Colors.white),
                        SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Buy Gold',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '₹14,370/gm',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFEF3C7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // BUY SILVER BUTTON
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BuyScreen(initialIsGold: false),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF334155), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline_rounded, size: 20, color: Colors.white),
                        SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Buy Silver',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '₹92.14/gm',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFCBD5E1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Quick Withdraw / Sell link
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SellScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: const [
                    // Text(
                    //   'Need Cash? Sell / Withdraw Gold',
                    //   style: TextStyle(
                    //     fontSize: 11.5,
                    //     fontWeight: FontWeight.w700,
                    //     color: Color(0xFF00796B),
                    //   ),
                    // ),
                    Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF00796B)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 4. Detailed Metal Holdings Card with live quantities and performance
  Widget _buildHoldingsCard() {
    final quantityStr = _isGoldSelected
        ? '${_goldGrams.toStringAsFixed(4)} g'
        : '${_silverGrams.toStringAsFixed(2)} g';
    final currentValueStr = _formatCurrency(_isGoldSelected ? _goldCurrentValue : _silverCurrentValue);
    final investedStr = _formatCurrency(_isGoldSelected ? _goldInvested : _silverInvested);
    final gainStr = '+${(_isGoldSelected ? _goldGainPct : _silverGainPct).toStringAsFixed(2)}%';
    final avgPriceStr = '₹${(_isGoldSelected ? _goldAvgPrice : _silverAvgPrice).toStringAsFixed(2)}/g';
    final chartPoints = _isGoldSelected ? _goldChartPoints : _silverChartPoints;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Quantity + Value + 3D Asset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isGoldSelected ? '24K 99.9% Pure Gold' : '99.9% Fine Silver',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quantityStr,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '≈ $currentValueStr',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00796B),
                    ),
                  ),
                ],
              ),
              _isGoldSelected
                  ? const GoldBar3DWidget(width: 58, height: 44, isSilver: false)
                  : const GoldBar3DWidget(width: 58, height: 44, isSilver: true),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // 4 Stats Grid: Invested, Current Value, Gain, Avg Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCol('Invested', investedStr),
              _buildStatCol('Current Value', currentValueStr),
              _buildStatCol('Return', gainStr, isGain: true),
              _buildStatCol('Avg Buy Price', avgPriceStr),
            ],
          ),

          const SizedBox(height: 16),

          // Chart
          SmoothTrendLineChart(
            points: chartPoints,
            lineColor: _isGoldSelected ? const Color(0xFFE5A83B) : const Color(0xFF64748B),
            gradientStartColor: _isGoldSelected ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
            height: 80,
          ),

          const SizedBox(height: 10),

          // Timeframe Filter Pills
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
            fontSize: 10.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGain)
              const Icon(Icons.arrow_drop_up_rounded, size: 15, color: Color(0xFF10B981)),
            Text(
              isGain ? '▲ $value' : value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: isGain ? const Color(0xFF10B981) : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 5. "Holdings by Goal" Section showing exact goal allocations
  Widget _buildHoldingsByGoalSection() {
    final allocations = _isGoldSelected ? _goldGoalAllocations : _silverGoalAllocations;
    final metalName = _isGoldSelected ? 'Gold' : 'Silver';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Holdings by Goal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Allocated across your ${_isGoldSelected ? "Gold Goals" : "Silver Goals"}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            // "View Goals" shortcut
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GullaksScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Text(
                      'All Goals',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00796B),
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF00796B)),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // List of Allocated Goal Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allocations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = allocations[index];
            final grams = item['grams'] as double;
            final targetAmt = item['targetAmount'] as double;
            final savedAmt = item['savedAmount'] as double;
            final hasTarget = targetAmt > 0;
            final progress = hasTarget ? (savedAmt / targetAmt).clamp(0.0, 1.0) : 1.0;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Goal Icon or Asset
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: item['asset'] != null
                              ? Image.asset(
                                  item['asset'] as String,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Color(0xFF00897B),
                                  size: 24,
                                ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Goal Title & Tag
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (item['tagColor'] as Color).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item['tag'] as String,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: item['tagColor'] as Color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['subtitle'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quantity in grams & Value
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _isGoldSelected
                                ? '${grams.toStringAsFixed(4)} g'
                                : '${grams.toStringAsFixed(2)} g',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            _formatCurrency(savedAmt),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Progress Bar if target exists
                  if (hasTarget) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                item['tagColor'] as Color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}% of ${_formatCurrency(targetAmt)}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFF8FAFC)),
                  const SizedBox(height: 8),

                  // Bottom Action: Add More Gold / Silver to this Goal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['asset'] == null ? 'Available balance' : 'Auto-saving enabled',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BuyScreen(
                                initialIsGold: _isGoldSelected,
                                goalName: item['title'] as String,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                size: 14,
                                color: _isGoldSelected ? const Color(0xFFD97706) : const Color(0xFF334155),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+ Add $metalName',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _isGoldSelected ? const Color(0xFFD97706) : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // "Set up a new Goal" prompt
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GullakGoalsScreen()),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_rounded, size: 18, color: Color(0xFF00897B)),
                SizedBox(width: 6),
                Text(
                  'Set up a new Goal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00897B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 6. Price History Navigation Button
  Widget _buildPriceHistoryButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PriceHistoryScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF0F172A),
          side: const BorderSide(color: Color(0xFFCBD5E1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insights_rounded, size: 18, color: Color(0xFF0F172A)),
            SizedBox(width: 8),
            Text(
              'View Historical Price Charts & Trends',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
