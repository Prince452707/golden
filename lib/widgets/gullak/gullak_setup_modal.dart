import 'package:flutter/material.dart';
import 'gullak_models.dart';

class GullakSetupModal extends StatefulWidget {
  final GullakGoal goal;
  final VoidCallback? onSaved;
  final void Function(double initialDeposit, double targetAmount, String frequency)? onProceedToPayment;

  const GullakSetupModal({
    super.key,
    required this.goal,
    this.onSaved,
    this.onProceedToPayment,
  });

  static Future<void> show({
    required BuildContext context,
    required GullakGoal goal,
    VoidCallback? onSaved,
    void Function(double initialDeposit, double targetAmount, String frequency)? onProceedToPayment,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GullakSetupModal(
        goal: goal,
        onSaved: onSaved,
        onProceedToPayment: onProceedToPayment,
      ),
    );
  }

  @override
  State<GullakSetupModal> createState() => _GullakSetupModalState();
}

class _GullakSetupModalState extends State<GullakSetupModal> {
  late double _targetAmount;
  int _selectedFrequencyIndex = 0; // 0: Daily, 1: Weekly, 2: Monthly
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];
  final List<double> _quickAmounts = [10000, 25000, 50000, 100000, 250000, 500000];

  double _initialDeposit = 1000;
  final List<double> _depositPresets = [500, 1000, 2500, 5000];

  static const double _goldRatePerGram = 14139.83;

  @override
  void initState() {
    super.initState();
    _targetAmount = widget.goal.defaultTarget;
  }

  @override
  Widget build(BuildContext context) {
    final goldGrams = (_targetAmount / _goldRatePerGram).toStringAsFixed(3);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header with Goal Image & Title
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.goal.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.goal.cleanImageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.goal.prefix,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      widget.goal.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                        color: widget.goal.titleColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Target Goal Amount Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Savings Amount',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${_targetAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_rounded, size: 14, color: Color(0xFFD97706)),
                          const SizedBox(width: 4),
                          Text(
                            '≈ $goldGrams gm 24K Gold',
                            style: const TextStyle(
                              fontSize: 11.5,
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
            ),
          ),

          const SizedBox(height: 14),

          // Quick Amount Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickAmounts.map((amt) {
                final isSelected = _targetAmount == amt;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      '₹${(amt / 1000).toInt()}k',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF334155),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF00897B),
                    backgroundColor: const Color(0xFFF1F5F9),
                    showCheckmark: false,
                    onSelected: (val) {
                      setState(() {
                        _targetAmount = amt;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 18),

          // Saving Frequency Selector
          const Text(
            'Saving Frequency',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_frequencies.length, (i) {
              final isSel = _selectedFrequencyIndex == i;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 8.0 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFrequencyIndex = i;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFE0F2F1) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? const Color(0xFF00897B) : const Color(0xFFE2E8F0),
                          width: isSel ? 1.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _frequencies[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? const Color(0xFF00897B) : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          // First Deposit to Activate Gullak Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'First Deposit to Start',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '≈ ${(_initialDeposit / _goldRatePerGram).toStringAsFixed(4)} gm Gold',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00796B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: _depositPresets.map((amt) {
              final isSel = _initialDeposit == amt;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _initialDeposit = amt;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF00897B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSel ? const Color(0xFF00796B) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '₹${amt.toInt()}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                            color: isSel ? Colors.white : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          // Primary CTA Button: Proceed to Pay & Start Gullak
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              if (widget.onProceedToPayment != null) {
                widget.onProceedToPayment!(
                  _initialDeposit,
                  _targetAmount,
                  _frequencies[_selectedFrequencyIndex],
                );
              } else if (widget.onSaved != null) {
                widget.onSaved!();
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF00897B),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00897B).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, size: 16, color: Color(0xFFFDE68A)),
                  const SizedBox(width: 8),
                  Text(
                    'Proceed to Pay ₹${_initialDeposit.toInt()} & Start Gullak',
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

