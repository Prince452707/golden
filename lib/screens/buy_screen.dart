import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  bool _isGoldSelected = true;
  bool _isAmountMode = true; // true = Amount (₹), false = Quantity (gm)
  double _amount = 10000;
  final TextEditingController _amountController = TextEditingController(text: '10,000');

  final double _goldRatePerGm = 14370.20;
  final double _silverRatePerGm = 92.14;

  final List<double> _presetAmounts = [500, 1000, 5000, 10000];

  double get _currentRate => _isGoldSelected ? _goldRatePerGm : _silverRatePerGm;

  double get _calculatedGrams => _amount / _currentRate;

  // Exact math breakdown matching ₹10,000 -> 3% GST (approx ₹267.90) and base price
  double get _gstAmount => _amount * (3 / 103);
  double get _basePrice => _amount - _gstAmount;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectPreset(double amt) {
    setState(() {
      _amount = amt;
      _amountController.text = _formatCurrency(amt);
    });
  }

  String _formatCurrency(double val) {
    return val.toInt().toString().replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final liveRateStr = _isGoldSelected ? '₹14,370.20 / gm' : '₹92.14 / gm';
    final liveChangeStr = _isGoldSelected ? '+0.8%' : '+1.2%';
    final gramsStr = _calculatedGrams.toStringAsFixed(4);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar: Back Arrow + "Buy"
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
                    'Buy',
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

                    // Live Buying Price Card
                    _buildLivePriceCard(liveRateStr, liveChangeStr),

                    const SizedBox(height: 16),

                    // Amount / Quantity Mode Pill Switcher
                    _buildModeToggle(),

                    const SizedBox(height: 14),

                    // Big Amount Input Box
                    _buildAmountInputBox(),

                    const SizedBox(height: 14),

                    // Quick Preset Chips (₹500, ₹1000, ₹5000, ₹10,000)
                    _buildPresetChipsRow(),

                    const SizedBox(height: 20),

                    // "You will get (approx.)"
                    const Text(
                      'You will get (approx.)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Grams result
                    Text(
                      '$gramsStr gm',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Price Breakdown Table
                    _buildPriceBreakdownCard(),
                  ],
                ),
              ),
            ),

            // Bottom "Continue to Pay →" Button
            _buildBottomPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePriceCard(String rateStr, String changeStr) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: Row(
        children: [
          GoldBar3DWidget(width: 54, height: 40, isSilver: !_isGoldSelected),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Buying Price (incl. GST)',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      rateStr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.arrow_drop_up_rounded, size: 16, color: Color(0xFF10B981)),
                    Text(
                      changeStr,
                      style: const TextStyle(
                        fontSize: 11.5,
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
    );
  }

  Widget _buildModeToggle() {
    return Row(
      children: [
        // Mode 1: Amount (₹)
        GestureDetector(
          onTap: () {
            setState(() {
              _isAmountMode = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: _isAmountMode ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Amount (₹)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: _isAmountMode ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Mode 2: Quantity (gm)
        GestureDetector(
          onTap: () {
            setState(() {
              _isAmountMode = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: !_isAmountMode ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Quantity (gm)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: !_isAmountMode ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInputBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Text(
            '₹ ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (text) {
                final cleaned = text.replaceAll(',', '').replaceAll(' ', '');
                final parsed = double.tryParse(cleaned);
                if (parsed != null) {
                  setState(() {
                    _amount = parsed;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChipsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _presetAmounts.map((amt) {
        final isSelected = amt == _amount;
        return GestureDetector(
          onTap: () => _selectPreset(amt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Text(
              '₹${_formatCurrency(amt)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF005953) : const Color(0xFF475569),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceBreakdownCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          _buildRow('Gold Price', _amount == 10000 ? '₹14,102.30' : '₹${_basePrice.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _buildRow('GST (3%)', _amount == 10000 ? '₹267.90' : '₹${_gstAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _buildRow('Total Amount', '₹${_formatCurrency(_amount)}.00', isBold: true),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Price Breakup: 24K 99.9% Pure Gold with LBMA Accreditation'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.assignment_outlined, size: 16, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Text(
                  'Price Breakup',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPayButton() {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎉 Payment Successful! Added ${_calculatedGrams.toStringAsFixed(4)} gm to your Gullak.'),
                backgroundColor: const Color(0xFF005953),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005953),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continue to Pay', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

