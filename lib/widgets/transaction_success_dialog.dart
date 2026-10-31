import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/portfolio_screen.dart';
import 'gold_3d_widgets.dart';

class TransactionSuccessDialog extends StatelessWidget {
  final bool isBuy; // true = Buy, false = Sell
  final bool isGold; // true = Gold, false = Silver
  final double grams;
  final double amount;
  final double ratePerGram;
  final String? goalName;
  final String? bankAccount;

  const TransactionSuccessDialog({
    super.key,
    required this.isBuy,
    required this.isGold,
    required this.grams,
    required this.amount,
    required this.ratePerGram,
    this.goalName,
    this.bankAccount,
  });

  static Future<void> showBuySuccess({
    required BuildContext context,
    required bool isGold,
    required double grams,
    required double amount,
    required double ratePerGram,
    String? goalName,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TransactionSuccessDialog(
        isBuy: true,
        isGold: isGold,
        grams: grams,
        amount: amount,
        ratePerGram: ratePerGram,
        goalName: goalName,
      ),
    );
  }

  static Future<void> showSellSuccess({
    required BuildContext context,
    required bool isGold,
    required double grams,
    required double amount,
    required double ratePerGram,
    String? bankAccount,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TransactionSuccessDialog(
        isBuy: false,
        isGold: isGold,
        grams: grams,
        amount: amount,
        ratePerGram: ratePerGram,
        bankAccount: bankAccount ?? 'HDFC Bank •••• 4219',
      ),
    );
  }

  String _formatCurrency(double val) {
    return '₹${val.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final metalName = isGold ? '24K Gold' : '99.9% Silver';
    final gramsStr = isGold ? '${grams.toStringAsFixed(4)} gm' : '${grams.toStringAsFixed(2)} gm';
    final rateStr = '${_formatCurrency(ratePerGram)} / gm';
    final orderId = isBuy
        ? 'GLD-BUY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'
        : 'GLD-SELL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Top Decorative Festive Aura Header
              _buildHeaderAura(),

              // 2. Body Details
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    // Title
                    Text(
                      isBuy ? 'Purchase Successful!' : 'Withdrawal Initiated!',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBuy
                          ? 'Added to your physical secure vault'
                          : 'Amount will reflect in your account within 15 mins',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Big Highlight Box
                    _buildHighlightBanner(gramsStr, metalName),

                    const SizedBox(height: 14),

                    // Receipt Details Table
                    _buildReceiptCard(orderId, rateStr, metalName),

                    const SizedBox(height: 14),

                    // Trust Assurance Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF00897B)),
                        SizedBox(width: 5),
                        Text(
                          '100% Insured • LBMA Certified • Brink\'s Vaults',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00796B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 3. Primary Action: View in Portfolio / Dashboard
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          // Navigate to Portfolio Dashboard
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => PortfolioScreen(initialIsGold: isGold),
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
                            Icon(Icons.pie_chart_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'View in Portfolio',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Secondary Action: Done / Close
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop(); // Return to previous screen
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF64748B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Aura with glowing background and 3D Asset / Checkmark
  Widget _buildHeaderAura() {
    return Container(
      width: double.infinity,
      height: 125,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isBuy
              ? [const Color(0xFFFEF3C7), const Color(0xFFFFFBEB), Colors.white]
              : [const Color(0xFFD1FAE5), const Color(0xFFECFDF5), Colors.white],
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient soft circular glow
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isBuy ? const Color(0xFFFBBF24) : const Color(0xFF10B981)).withValues(alpha: 0.2),
              ),
            ),

            // Icon / 3D Asset
            if (isBuy)
              const GoldCoinSingleWidget(size: 64)
            else
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3310B981),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 38,
                  color: Colors.white,
                ),
              ),

            // Small green checkmark badge overlay on Gold coin
            if (isBuy)
              Positioned(
                right: 0,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Big prominent quantity / amount highlight container
  Widget _buildHighlightBanner(String gramsStr, String metalName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: isBuy ? const Color(0xFFFFFDF5) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isBuy ? const Color(0xFFFDE68A) : const Color(0xFFA7F3D0),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Text(
            isBuy ? '+ $gramsStr' : '- $gramsStr',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: isBuy ? const Color(0xFF0F172A) : const Color(0xFF065F46),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isBuy
                ? '${_formatCurrency(amount)} • $metalName'
                : 'Payout: ${_formatCurrency(amount)}',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isBuy ? const Color(0xFFB45309) : const Color(0xFF047857),
            ),
          ),
        ],
      ),
    );
  }

  /// Receipt details table
  Widget _buildReceiptCard(String orderId, String rateStr, String metalName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildRow('Transaction Type', isBuy ? 'Buy Metal' : 'Sell / Withdraw'),
          const SizedBox(height: 8),
          _buildRow('Asset', metalName),
          if (goalName != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Allocated Goal',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.savings_rounded, size: 12, color: Color(0xFFB45309)),
                      const SizedBox(width: 4),
                      Text(
                        goalName!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (!isBuy && bankAccount != null) ...[
            const SizedBox(height: 8),
            _buildRow('Bank Account', bankAccount!),
          ],
          const SizedBox(height: 8),
          _buildRow('Execution Rate', rateStr),
          const SizedBox(height: 8),
          _buildRow('Order ID', orderId),
          const SizedBox(height: 8),
          _buildRow('Status', 'Completed (Instant)', isSuccess: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isSuccess = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isSuccess ? const Color(0xFF059669) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

