import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';
import 'price_history_screen.dart';
import '../services/golden_api_service.dart';
import '../core/models/rate_models.dart';

class LiveRatesScreen extends StatefulWidget {
  const LiveRatesScreen({super.key});

  @override
  State<LiveRatesScreen> createState() => _LiveRatesScreenState();
}

class _LiveRatesScreenState extends State<LiveRatesScreen> {
  bool _isGoldSelected = true;
  String _goldFilter = '1M';
  String _silverFilter = '1M';

  StreamSubscription<LiveRatesData>? _rateSub;
  LiveRatesData? _ratesData;
  LockQuoteModel? _lockedQuote;
  bool _isLocking = false;

  List<double> _goldPoints = [];
  List<double> _silverPoints = [];

  @override
  void initState() {
    super.initState();
    _initRates();
  }

  void _initRates() async {
    _rateSub = GoldenApiService.instance.liveRateStream.listen((data) {
      if (mounted) setState(() => _ratesData = data);
    });

    final res = await GoldenApiService.instance.getLiveRates();
    if (mounted && res.data != null) {
      setState(() => _ratesData = res.data);
    }

    _loadGoldHistory(_goldFilter);
    _loadSilverHistory(_silverFilter);
  }

  void _loadGoldHistory(String range) async {
    final res = await GoldenApiService.instance.getPriceHistory(metal: 'gold', range: range);
    if (mounted && res.data != null && res.data!.points.isNotEmpty) {
      setState(() {
        _goldPoints = res.data!.points.map((p) => p.price).toList();
      });
    }
  }

  void _loadSilverHistory(String range) async {
    final res = await GoldenApiService.instance.getPriceHistory(metal: 'silver', range: range);
    if (mounted && res.data != null && res.data!.points.isNotEmpty) {
      setState(() {
        _silverPoints = res.data!.points.map((p) => p.price).toList();
      });
    }
  }

  @override
  void dispose() {
    _rateSub?.cancel();
    super.dispose();
  }

  void _lockCurrentPrice() async {
    setState(() => _isLocking = true);
    final res = await GoldenApiService.instance.lockPriceQuote(
      metal: _isGoldSelected ? 'gold' : 'silver',
    );
    if (!mounted) return;

    setState(() {
      _isLocking = false;
      _lockedQuote = res.data;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔒 Price locked at ₹${res.data?.ratePerGram ?? _ratesData?.gold.buyPricePerGram ?? 0.0}/gm for 5 minutes!'),
        backgroundColor: const Color(0xFF005953),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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

                    const SizedBox(height: 16),

                    // 5-Minute Price Lock Guarantee Action Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD97706),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.lock_clock_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lockedQuote != null
                                      ? 'Price Locked: ₹${_lockedQuote!.ratePerGram}/g'
                                      : '5-Minute Price Lock',
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _lockedQuote != null
                                      ? 'Quote ID: ${_lockedQuote!.quoteId} (valid for 5m)'
                                      : 'Protect against market volatility during checkout',
                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF78350F)),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isLocking ? null : _lockCurrentPrice,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005953),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(_isLocking ? '...' : (_lockedQuote != null ? 'Re-lock' : 'Lock Price')),
                          ),
                        ],
                      ),
                    ),

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
                        children: [
                          Text(
                            _ratesData != null && _ratesData!.gold.buyPricePerGram > 0
                                ? '₹${_ratesData!.gold.buyPricePerGram.toStringAsFixed(2)}'
                                : '--',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Text(
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
                        children: [
                          Icon(
                            (_ratesData?.gold.changeTodayPercentage ?? 0.0) >= 0
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded,
                            size: 18,
                            color: (_ratesData?.gold.changeTodayPercentage ?? 0.0) >= 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                          Text(
                            _ratesData != null
                                ? '${_ratesData!.gold.changeTodayPercentage >= 0 ? '+' : ''}${_ratesData!.gold.changeTodayPercentage.toStringAsFixed(1)}% today'
                                : '--',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: (_ratesData?.gold.changeTodayPercentage ?? 0.0) >= 0
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
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
                _loadGoldHistory(val);
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
                      children: [
                        Text(
                          _ratesData != null && _ratesData!.silver.buyPricePerGram > 0
                              ? '₹${_ratesData!.silver.buyPricePerGram.toStringAsFixed(2)}'
                              : '--',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const Text(
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
                      children: [
                        Icon(
                          (_ratesData?.silver.changeTodayPercentage ?? 0.0) >= 0
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                          size: 18,
                          color: (_ratesData?.silver.changeTodayPercentage ?? 0.0) >= 0
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        Text(
                          _ratesData != null
                              ? '${_ratesData!.silver.changeTodayPercentage >= 0 ? '+' : ''}${_ratesData!.silver.changeTodayPercentage.toStringAsFixed(1)}% today'
                              : '--',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: (_ratesData?.silver.changeTodayPercentage ?? 0.0) >= 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
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
              _loadSilverHistory(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsTable() {
    final goldBuy = _ratesData != null ? '₹${_ratesData!.gold.buyPricePerGram.toStringAsFixed(2)}' : '--';
    final goldSell = _ratesData != null ? '₹${_ratesData!.gold.sellPricePerGram.toStringAsFixed(2)}' : '--';
    final silverBuy = _ratesData != null ? '₹${_ratesData!.silver.buyPricePerGram.toStringAsFixed(2)}' : '--';
    final silverSell = _ratesData != null ? '₹${_ratesData!.silver.sellPricePerGram.toStringAsFixed(2)}' : '--';
    final goldSpread = _ratesData != null ? '₹${_ratesData!.gold.spreadPerGram.toStringAsFixed(2)}' : '--';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildDetailRow('Gold Buying Price (incl. 3% GST)', goldBuy),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Gold Selling Price', goldSell),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Gold Spread / gm', goldSpread),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Silver Buying Price (incl. 3% GST)', silverBuy),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),
          _buildDetailRow('Silver Selling Price', silverSell),
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

