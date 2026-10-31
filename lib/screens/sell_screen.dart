import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  bool _isGoldSelected = true;
  bool _isQuantityMode = true; // true = Quantity (gm), false = Amount (₹)
  double _grams = 0.5000;
  final TextEditingController _quantityController = TextEditingController(text: '0.5000');

  final double _goldSellingRate = 14102.30;
  final double _silverSellingRate = 87.60;
  final double _maxAvailableGrams = 0.8452;

  double get _currentRate => _isGoldSelected ? _goldSellingRate : _silverSellingRate;

  double get _calculatedAmount => _grams * _currentRate;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _onMaxPressed() {
    setState(() {
      _grams = _maxAvailableGrams;
      _quantityController.text = _maxAvailableGrams.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rateStr = _isGoldSelected ? '₹14,102.30 / gm' : '₹87.60 / gm';
    final changeStr = _isGoldSelected ? '-0.6%' : '-0.4%';
    final amountStr = _calculatedAmount.toStringAsFixed(2);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar: Back Arrow + "Sell"
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
                    'Sell',
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

                    // Live Selling Price Card + 3D Coins Stack
                    _buildSellingPriceCard(rateStr, changeStr),

                    const SizedBox(height: 16),

                    // Mode Toggle: Quantity (gm) | Amount (₹)
                    _buildModeToggle(),

                    const SizedBox(height: 14),

                    // Quantity Input with "Max" button
                    _buildQuantityInputBox(),

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

                    // Total calculated amount
                    Text(
                      _grams == 0.5000 ? '₹7,051.15' : '₹$amountStr',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Price Breakdown Table
                    _buildBreakdownCard(),
                  ],
                ),
              ),
            ),

            // Bottom "Continue →" Button
            _buildBottomContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSellingPriceCard(String rateStr, String changeStr) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Selling Price',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rateStr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.arrow_drop_down_rounded, size: 16, color: Color(0xFFEF4444)),
                  Text(
                    changeStr,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const GoldCoinsStackWidget(width: 65, height: 50),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Row(
      children: [
        // Mode 1: Quantity (gm)
        GestureDetector(
          onTap: () {
            setState(() {
              _isQuantityMode = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: _isQuantityMode ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Quantity (gm)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: _isQuantityMode ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Mode 2: Amount (₹)
        GestureDetector(
          onTap: () {
            setState(() {
              _isQuantityMode = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: !_isQuantityMode ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Amount (₹)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: !_isQuantityMode ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityInputBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                final parsed = double.tryParse(text);
                if (parsed != null) {
                  setState(() {
                    _grams = parsed;
                  });
                }
              },
            ),
          ),
          InkWell(
            onTap: _onMaxPressed,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Max',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF005953),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          _buildRow('Selling Price', '₹14,102.30'),
          const SizedBox(height: 10),
          _buildRow('GST (0%)', '₹0.00'),
          const SizedBox(height: 10),
          _buildRow('Total Amount', _grams == 0.5000 ? '₹7,051.15' : '₹${_calculatedAmount.toStringAsFixed(2)}', isBold: true),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selling Price Breakup: 0% GST on Gold Sell back as per Indian tax norms'),
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

  Widget _buildBottomContinueButton() {
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
                content: Text('✅ Withdrawal of ₹${_grams == 0.5000 ? '7,051.15' : _calculatedAmount.toStringAsFixed(2)} initiated to your verified bank account!'),
                backgroundColor: const Color(0xFF005953),
              ),
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
                'Continue',
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

