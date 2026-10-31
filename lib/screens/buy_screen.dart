import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';
import '../widgets/transaction_success_dialog.dart';

class BuyScreen extends StatefulWidget {
  final bool initialIsGold;
  final String? goalName;
  final double? initialAmount;

  const BuyScreen({
    super.key,
    this.initialIsGold = true,
    this.goalName,
    this.initialAmount,
  });

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late bool _isGoldSelected;
  late double _amount;
  late final TextEditingController _amountController;

  final double _goldRatePerGm = 14370.20;
  final double _silverRatePerGm = 92.14;

  final List<double> _presetAmounts = [500, 1000, 2500, 5000, 10000, 25000];

  double get _currentRate => _isGoldSelected ? _goldRatePerGm : _silverRatePerGm;
  double get _calculatedGrams => _amount / _currentRate;

  // 3% GST calculation
  double get _gstAmount => _amount * (3 / 103);
  double get _basePrice => _amount - _gstAmount;

  int _countdownSeconds = 299; // 5 minute price lock
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _isGoldSelected = widget.initialIsGold;
    _amount = widget.initialAmount ?? 10000;
    _amountController = TextEditingController(text: _formatCurrency(_amount));
    _startPriceLockTimer();
  }

  void _startPriceLockTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        setState(() {
          _countdownSeconds = 300;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  void _selectPreset(double amt) {
    setState(() {
      _amount = amt;
      _amountController.text = _formatCurrency(amt);
    });
  }

  void _onAmountChanged(String val) {
    final clean = val.replaceAll(',', '').trim();
    final parsed = double.tryParse(clean);
    if (parsed != null && parsed > 0) {
      setState(() {
        _amount = parsed;
      });
    }
  }

  String _formatCurrency(double val) {
    return val.toInt().toString().replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        );
  }

  String _getCountdownText() {
    final mins = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_countdownSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final liveRateStr = _isGoldSelected ? '₹14,370.20/g' : '₹92.14/g';
    final gramsStr = _calculatedGrams.toStringAsFixed(4);
    final metalName = _isGoldSelected ? '24K Gold' : '99.9% Silver';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.22, 0.55, 1.0],
            colors: [
              Color(0xFFFFE898),
              Color(0xFFFEF3C7),
              Color(0xFFFFFDF5),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Warm Golden Navigation Bar
              _buildWarmAppBar(liveRateStr),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Goal Destination Banner (if allocating to a specific Gullak)
                      if (widget.goalName != null) ...[
                        _buildGoalAllocationBanner(),
                        const SizedBox(height: 14),
                      ],

                      // Gold | Silver Warm Selector Cards
                      _buildMetalSelectorRow(),

                      const SizedBox(height: 16),

                      // Live Rate & Price Lock Card
                      _buildPriceLockCard(liveRateStr),

                      const SizedBox(height: 18),

                      // Big Amount Input Container
                      _buildWarmInputBox(gramsStr, metalName),

                      const SizedBox(height: 14),

                      // Preset Chips Row (₹500, ₹1000, ₹2500, ₹5000, ₹10000, ₹25000)
                      _buildPresetChipsRow(),

                      const SizedBox(height: 20),

                      // Transparent Price Breakdown Receipt
                      _buildPriceBreakdownCard(metalName),

                      const SizedBox(height: 18),

                      // Trust & Security Pillars
                      _buildTrustRow(),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              // 3. Fixed Bottom Pay Button
              _buildBottomPayButton(metalName, gramsStr),
            ],
          ),
        ),
      ),
    );
  }

  /// Warm App Bar with translucent rounded back button & live price badge
  Widget _buildWarmAppBar(String liveRateStr) {
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
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 22,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
          Text(
            'Buy ${_isGoldSelected ? "24K Gold" : "99.9% Silver"}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    liveRateStr,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Warm Goal Allocation Banner
  Widget _buildGoalAllocationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB45309).withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.savings_rounded, size: 20, color: Color(0xFFB45309)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SAVING FOR GOAL',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB45309),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${widget.goalName} Goal',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF78350F),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, size: 20, color: Color(0xFF059669)),
        ],
      ),
    );
  }

  /// Metal Selector with Warm 3D Cards
  Widget _buildMetalSelectorRow() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          // 24K GOLD OPTION
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isGoldSelected = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: _isGoldSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                        )
                      : null,
                  color: _isGoldSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isGoldSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFD97706).withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '24K Gold (99.9%)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 99.9% SILVER OPTION
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isGoldSelected = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: !_isGoldSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                        )
                      : null,
                  color: !_isGoldSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: !_isGoldSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Silver (99.9%)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
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

  /// Live Buying Price & 5-minute price lock timer card
  Widget _buildPriceLockCard(String liveRateStr) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 3D Asset
          _isGoldSelected
              ? const GoldBar3DWidget(width: 58, height: 44, isSilver: false)
              : const GoldBar3DWidget(width: 58, height: 44, isSilver: true),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Rate (incl. 3% GST)',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    // Price Lock Countdown Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 12, color: Color(0xFFB45309)),
                          const SizedBox(width: 3),
                          Text(
                            _getCountdownText(),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      liveRateStr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '+0.8%',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Price locked for 5 minutes • Zero hidden fees',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Big warm amount input box + live gram calculation badge
  Widget _buildWarmInputBox(String gramsStr, String metalName) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: "Enter Investment Amount" + Mode Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ENTER AMOUNT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB45309),
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'Starting at ₹10',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Big Currency Input Box
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '₹',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: _onAmountChanged,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.6,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Live Gram Output Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFEF3C7), Color(0xFFFFFBEB)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFFD97706)),
                    const SizedBox(width: 6),
                    Text(
                      'You receive (approx.):',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF78350F),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$gramsStr gm',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Preset Quick Chips
  Widget _buildPresetChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _presetAmounts.map((amt) {
          final isSelected = amt == _amount;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _selectPreset(amt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF005953), Color(0xFF00796B)],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF005953).withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.02),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '+ ₹${_formatCurrency(amt)}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Warm Price Breakdown Card
  Widget _buildPriceBreakdownCard(String metalName) {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRow('$metalName Base Price', '₹${_formatCurrency(_basePrice)}.00'),
          const SizedBox(height: 10),
          _buildRow('Applicable GST (3%)', '₹${_formatCurrency(_gstAmount)}.00'),
          const SizedBox(height: 10),
          _buildRow('Brink\'s Secure Vaulting', 'FREE (Lifetime)', isGreen: true),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          _buildRow('Total Payable Amount', '₹${_formatCurrency(_amount)}.00', isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 12.5,
            color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isGreen
                ? const Color(0xFF059669)
                : (isBold ? const Color(0xFF0F172A) : const Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }

  /// Trust & Security 3-column row
  Widget _buildTrustRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A).withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _TrustItem(icon: Icons.security_rounded, label: '100% Insured'),
          _TrustItem(icon: Icons.verified_rounded, label: '24K Hallmark'),
          _TrustItem(icon: Icons.flash_on_rounded, label: 'Instant UPI'),
        ],
      ),
    );
  }

  /// Fixed Bottom Pay Button
  Widget _buildBottomPayButton(String metalName, String gramsStr) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            TransactionSuccessDialog.showBuySuccess(
              context: context,
              isGold: _isGoldSelected,
              grams: _calculatedGrams,
              amount: _amount,
              ratePerGram: _currentRate,
              goalName: widget.goalName,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005953),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded, size: 16, color: Color(0xFFFDE68A)),
              const SizedBox(width: 8),
              Text(
                'Pay ₹${_formatCurrency(_amount)} & Add to Vault',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF00796B)),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF004D40),
          ),
        ),
      ],
    );
  }
}
