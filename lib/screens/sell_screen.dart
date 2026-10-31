import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';
import '../widgets/transaction_success_dialog.dart';

class SellScreen extends StatefulWidget {
  final bool initialIsGold;

  const SellScreen({
    super.key,
    this.initialIsGold = true,
  });

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  late bool _isGoldSelected;
  final bool _isQuantityMode = true; // true = Quantity (gm), false = Amount (₹)
  double _grams = 0.5000;
  final TextEditingController _inputController = TextEditingController(text: '0.5000');

  final double _goldSellingRate = 14102.30;
  final double _silverSellingRate = 87.60;

  final double _goldMaxAvailableGrams = 0.8452;
  final double _silverMaxAvailableGrams = 35.5000;

  double get _currentRate => _isGoldSelected ? _goldSellingRate : _silverSellingRate;
  double get _maxAvailableGrams => _isGoldSelected ? _goldMaxAvailableGrams : _silverMaxAvailableGrams;
  double get _calculatedAmount => _grams * _currentRate;

  @override
  void initState() {
    super.initState();
    _isGoldSelected = widget.initialIsGold;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _onPercentageSelected(double fraction) {
    setState(() {
      _grams = double.parse((_maxAvailableGrams * fraction).toStringAsFixed(4));
      if (_isQuantityMode) {
        _inputController.text = _grams.toStringAsFixed(4);
      } else {
        _inputController.text = _formatCurrency(_calculatedAmount);
      }
    });
  }

  void _onInputChanged(String val) {
    final clean = val.replaceAll(',', '').trim();
    final parsed = double.tryParse(clean);
    if (parsed != null && parsed > 0) {
      setState(() {
        if (_isQuantityMode) {
          _grams = parsed.clamp(0.0, _maxAvailableGrams);
        } else {
          final computedGrams = parsed / _currentRate;
          _grams = computedGrams.clamp(0.0, _maxAvailableGrams);
        }
      });
    }
  }

  String _formatCurrency(double val) {
    return val.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final liveRateStr = _isGoldSelected ? '₹14,102.30/g' : '₹87.60/g';
    final metalName = _isGoldSelected ? '24K Gold' : '99.9% Silver';
    final availableValueStr = _formatCurrency(_maxAvailableGrams * _currentRate);
    final payoutStr = _formatCurrency(_calculatedAmount);

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
              Color(0xFFF0FDF4),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Warm App Bar
              _buildWarmAppBar(liveRateStr),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gold | Silver Selector
                      _buildMetalSelectorRow(),

                      const SizedBox(height: 16),

                      // Available Balance In Vault Card
                      _buildAvailableBalanceCard(metalName, availableValueStr),

                      const SizedBox(height: 16),

                      // Quick Percentage Chips: 25% | 50% | 75% | MAX
                      _buildPercentageChipsRow(),

                      const SizedBox(height: 16),

                      // Big Quantity / Amount Input Box
                      _buildWarmInputBox(payoutStr, metalName),

                      const SizedBox(height: 18),

                      // Destination Verified Bank Account Card
                      _buildDestinationBankCard(),

                      const SizedBox(height: 18),

                      // Transparent Breakdown Receipt
                      _buildBreakdownReceipt(metalName, payoutStr),

                      const SizedBox(height: 18),

                      // Trust & Security Row
                      _buildTrustRow(),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              // 3. Fixed Bottom Continue Button
              _buildBottomWithdrawButton(payoutStr),
            ],
          ),
        ),
      ),
    );
  }

  /// Warm App Bar with circular translucent back button & live rate badge
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
            'Sell ${_isGoldSelected ? "Gold" : "Silver"}',
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
                      color: Color(0xFF10B981),
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

  /// Gold | Silver Warm Selector Cards
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
                  _grams = 0.5000;
                  _inputController.text = '0.5000';
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
                      'Sell 24K Gold',
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
                  _grams = 10.0000;
                  _inputController.text = '10.0000';
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
                      'Sell Silver',
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

  /// Available Balance Card
  Widget _buildAvailableBalanceCard(String metalName, String availableValueStr) {
    final maxGramsStr = _isGoldSelected
        ? '${_maxAvailableGrams.toStringAsFixed(4)} gm'
        : '${_maxAvailableGrams.toStringAsFixed(2)} gm';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AVAILABLE TO WITHDRAW / SELL',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB45309),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                maxGramsStr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '≈ ₹$availableValueStr (Live Vault Value)',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00796B),
                ),
              ),
            ],
          ),
          const GoldCoinsStackWidget(width: 65, height: 50),
        ],
      ),
    );
  }

  /// Quick percentage allocation chips (25% | 50% | 75% | MAX)
  Widget _buildPercentageChipsRow() {
    final percentages = [
      {'label': '25%', 'fraction': 0.25},
      {'label': '50%', 'fraction': 0.50},
      {'label': '75%', 'fraction': 0.75},
      {'label': '100% (MAX)', 'fraction': 1.00},
    ];

    return Row(
      children: percentages.map((p) {
        final fraction = p['fraction'] as double;
        final isSelected = (_grams / _maxAvailableGrams - fraction).abs() < 0.02;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => _onPercentageSelected(fraction),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF005953), Color(0xFF00796B)],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF005953).withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.02),
                      blurRadius: isSelected ? 6 : 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    p['label'] as String,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Big warm quantity input box
  Widget _buildWarmInputBox(String payoutStr, String metalName) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QUANTITY TO SELL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB45309),
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: () => _onPercentageSelected(1.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Text(
                    'Sell All (MAX)',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Big Grams Input
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _onInputChanged,
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
                    hintText: '0.0000',
                    hintStyle: TextStyle(
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'Grams (gm)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Payout Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFF059669)),
                    SizedBox(width: 6),
                    Text(
                      'Direct Bank Payout:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹$payoutStr',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF065F46),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Destination Verified Bank Account Card
  Widget _buildDestinationBankCard() {
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Color(0xFF00796B),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Text(
                      'HDFC Bank Account',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'A/C •••• 4219 • Instant IMPS / UPI',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Verified',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF059669),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Breakdown Receipt
  Widget _buildBreakdownReceipt(String metalName, String payoutStr) {
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
          _buildRow('Live Selling Rate', '₹${_formatCurrency(_currentRate)} / gm'),
          const SizedBox(height: 10),
          _buildRow('Quantity Withdrawn', '${_grams.toStringAsFixed(4)} gm'),
          const SizedBox(height: 10),
          _buildRow('Vault Exit & Processing Charges', '₹0.00 (Zero Fee)', isGreen: true),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          _buildRow('Net Payout to Bank', '₹$payoutStr', isBold: true, isGreen: true),
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
            fontSize: isBold ? 16 : 13,
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
        color: const Color(0xFFECFDF5).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA7F3D0).withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _TrustItem(icon: Icons.flash_on_rounded, label: 'Instant IMPS'),
          _TrustItem(icon: Icons.money_off_rounded, label: 'Zero Hidden Fees'),
          _TrustItem(icon: Icons.shield_rounded, label: 'Bank-Grade'),
        ],
      ),
    );
  }

  /// Fixed Bottom Withdraw Button
  Widget _buildBottomWithdrawButton(String payoutStr) {
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
            TransactionSuccessDialog.showSellSuccess(
              context: context,
              isGold: _isGoldSelected,
              grams: _grams,
              amount: _calculatedAmount,
              ratePerGram: _currentRate,
              bankAccount: 'HDFC Bank •••• 4219',
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
              const Icon(Icons.account_balance_rounded, size: 16, color: Color(0xFFFDE68A)),
              const SizedBox(width: 8),
              Text(
                'Withdraw ₹$payoutStr to Bank',
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
