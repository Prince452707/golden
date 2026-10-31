import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GiftBullionScreen extends StatefulWidget {
  final bool initialIsGold;

  const GiftBullionScreen({
    super.key,
    this.initialIsGold = true,
  });

  @override
  State<GiftBullionScreen> createState() => _GiftBullionScreenState();
}

class _GiftOccasion {
  final String id;
  final String title;
  final String icon;
  final String defaultMessage;
  final Color badgeColor;
  final Color bgGradientStart;
  final Color bgGradientEnd;

  const _GiftOccasion({
    required this.id,
    required this.title,
    required this.icon,
    required this.defaultMessage,
    required this.badgeColor,
    required this.bgGradientStart,
    required this.bgGradientEnd,
  });
}

class _GiftBullionScreenState extends State<GiftBullionScreen> {
  late bool _isGold;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _amountController;
  late TextEditingController _messageController;

  bool _isAmountInRupees = true;
  int _selectedOccasionIndex = 0;

  static const double _goldRatePerGram = 14346.67;
  static const double _silverRatePerGram = 92.10;

  final List<_GiftOccasion> _occasions = const [
    _GiftOccasion(
      id: 'birthday',
      title: 'Birthday',
      icon: '🎂',
      defaultMessage: 'Wishing you a very Happy Birthday! May your wealth and happiness shine bright like pure gold.',
      badgeColor: Color(0xFFD97706),
      bgGradientStart: Color(0xFFFFFBEB),
      bgGradientEnd: Color(0xFFFEF3C7),
    ),
    _GiftOccasion(
      id: 'wedding',
      title: 'Wedding',
      icon: '💍',
      defaultMessage: 'Warmest congratulations on your sacred union. A golden token of blessings for a lifetime together.',
      badgeColor: Color(0xFFB45309),
      bgGradientStart: Color(0xFFFFF7ED),
      bgGradientEnd: Color(0xFFFFEDD5),
    ),
    _GiftOccasion(
      id: 'festive',
      title: 'Festive',
      icon: '🪔',
      defaultMessage: 'Shubh Deepavali & Dhanteras! Wishing prosperity, health, and endless golden abundance to your family.',
      badgeColor: Color(0xFF9333EA),
      bgGradientStart: Color(0xFFFAF5FF),
      bgGradientEnd: Color(0xFFF3E8FF),
    ),
    _GiftOccasion(
      id: 'milestone',
      title: 'Milestone',
      icon: '🎓',
      defaultMessage: 'Huge congratulations on achieving your milestone! Proud of you—celebrate with pure 24K bullion.',
      badgeColor: Color(0xFF0D9488),
      bgGradientStart: Color(0xFFF0FDFA),
      bgGradientEnd: Color(0xFFCCFBF1),
    ),
    _GiftOccasion(
      id: 'special',
      title: 'Special Bond',
      icon: '❤️',
      defaultMessage: 'Because you are timeless and precious to me. Enjoy this pure bullion gift!',
      badgeColor: Color(0xFFE11D48),
      bgGradientStart: Color(0xFFFFF1F2),
      bgGradientEnd: Color(0xFFFFE4E6),
    ),
  ];

  final List<int> _goldRupeePresets = [501, 1001, 2100, 5001, 11000];
  final List<int> _silverRupeePresets = [251, 501, 1001, 2500, 5001];

  @override
  void initState() {
    super.initState();
    _isGold = widget.initialIsGold;
    _nameController = TextEditingController(text: 'Ananya Sharma');
    _phoneController = TextEditingController(text: '9876543210');
    _amountController = TextEditingController(text: '1001');
    _messageController = TextEditingController(text: _occasions[0].defaultMessage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  double get _currentRate => _isGold ? _goldRatePerGram : _silverRatePerGram;

  double get _currentAmount {
    final val = double.tryParse(_amountController.text) ?? 0.0;
    return val;
  }

  double get _calculatedGrams {
    if (_isAmountInRupees) {
      if (_currentRate == 0) return 0.0;
      return _currentAmount / _currentRate;
    } else {
      return _currentAmount;
    }
  }

  double get _calculatedRupees {
    if (_isAmountInRupees) {
      return _currentAmount;
    } else {
      return _currentAmount * _currentRate;
    }
  }

  void _onOccasionChanged(int index) {
    setState(() {
      _selectedOccasionIndex = index;
      _messageController.text = _occasions[index].defaultMessage;
    });
  }

  void _onPresetSelected(int val) {
    setState(() {
      _amountController.text = val.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final occasion = _occasions[_selectedOccasionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Gift Gold & Silver',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, size: 22, color: Color(0xFF475569)),
            tooltip: 'Gifts History',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gifts History: 2 gifts sent successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Metal Toggle: 24K Gold vs 99.99% Silver
                  _buildMetalToggle(),

                  const SizedBox(height: 16),

                  // 2. Live Digital Gift Card Preview
                  _buildLiveGiftCardPreview(occasion),

                  const SizedBox(height: 20),

                  // 3. Occasion Selector
                  _buildOccasionSelector(),

                  const SizedBox(height: 20),

                  // 4. Gift Value & Quick Presets
                  _buildAmountSection(),

                  const SizedBox(height: 20),

                  // 5. Recipient Details Card
                  _buildRecipientForm(),

                  const SizedBox(height: 20),

                  // 6. Security & Vault Trust Badges
                  _buildTrustBadges(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Sticky Bottom Checkout Action
          _buildBottomAction(),
        ],
      ),
    );
  }

  /// Segmented Metal Toggle: 24K Gold vs 99.99% Silver
  Widget _buildMetalToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gold Option
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _isGold = true;
                  if (_isAmountInRupees && _currentAmount < 500) {
                    _amountController.text = '1001';
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: _isGold
                      ? const LinearGradient(
                          colors: [Color(0xFFFEDE77), Color(0xFFFBBF24)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/gold_coin.png', width: 22, height: 22),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gold 24K 99.9%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _isGold ? const Color(0xFF78350F) : const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '₹${_goldRatePerGram.toStringAsFixed(2)}/gm',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: _isGold ? const Color(0xFF92400E) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Silver Option
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _isGold = false;
                  if (_isAmountInRupees && _currentAmount < 250) {
                    _amountController.text = '501';
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: !_isGold
                      ? const LinearGradient(
                          colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/silver_coin.png', width: 22, height: 22),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Silver 99.99%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: !_isGold ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '₹${_silverRatePerGram.toStringAsFixed(2)}/gm',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: !_isGold ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
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

  /// Live Digital Gift Card Preview
  Widget _buildLiveGiftCardPreview(_GiftOccasion occasion) {
    final metalName = _isGold ? '24K 99.9% Pure Gold' : '99.99% Pure Silver';
    final formattedWeight = _calculatedGrams.toStringAsFixed(4);
    final formattedRupees = _calculatedRupees.toStringAsFixed(0);
    final recipientName = _nameController.text.trim().isEmpty ? 'Loved One' : _nameController.text.trim();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isGold
              ? [const Color(0xFFFEF3C7), const Color(0xFFFDE68A), const Color(0xFFFEDE77)]
              : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
        ),
        border: Border.all(
          color: _isGold ? const Color(0xFFF59E0B).withValues(alpha: 0.5) : const Color(0xFF94A3B8).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isGold ? const Color(0xFFD97706) : const Color(0xFF475569)).withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Background Festive Watermark
            Positioned(
              right: -15,
              bottom: -15,
              child: Opacity(
                opacity: 0.22,
                child: Image.asset(
                  _isGold ? 'assets/gold_coin.png' : 'assets/silver_coin.png',
                  width: 160,
                  height: 160,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Occasion Badge + Purity Seal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(occasion.icon, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 5),
                            Text(
                              occasion.title,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: occasion.badgeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isGold ? const Color(0xFF78350F) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'BIS HALLMARKED',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Gift Value Heading
                  Text(
                    '₹$formattedRupees',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: _isGold ? const Color(0xFF78350F) : const Color(0xFF0F172A),
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      Image.asset(
                        _isGold ? 'assets/gold_coin.png' : 'assets/silver_coin.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$formattedWeight g of $metalName',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: _isGold ? const Color(0xFF92400E) : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Recipient & Sender Footer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GIFT FOR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              recipientName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'SENT WITH LOVE BY',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Prince Kumar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Occasion Selector Horizontal List
  Widget _buildOccasionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Occasion',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _occasions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final item = _occasions[idx];
              final isSelected = _selectedOccasionIndex == idx;
              return InkWell(
                onTap: () => _onOccasionChanged(idx),
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00796B) : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00796B) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: const Color(0xFF00796B).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(item.icon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Gift Amount / Weight Section
  Widget _buildAmountSection() {
    final presets = _isGold ? _goldRupeePresets : _silverRupeePresets;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gift Value',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              // Unit Switcher
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isAmountInRupees = true;
                          _amountController.text = _calculatedRupees.toStringAsFixed(0);
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isAmountInRupees ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _isAmountInRupees
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : null,
                        ),
                        child: Text(
                          'In Rupees (₹)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: _isAmountInRupees ? FontWeight.w800 : FontWeight.w600,
                            color: _isAmountInRupees ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isAmountInRupees = false;
                          _amountController.text = _calculatedGrams.toStringAsFixed(4);
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: !_isAmountInRupees ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: !_isAmountInRupees
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : null,
                        ),
                        child: Text(
                          'In Grams (g)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: !_isAmountInRupees ? FontWeight.w800 : FontWeight.w600,
                            color: !_isAmountInRupees ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Big Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Text(
                  _isAmountInRupees ? '₹' : 'g',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                    ),
                  ),
                ),
                Text(
                  _isAmountInRupees
                      ? '≈ ${_calculatedGrams.toStringAsFixed(4)} g'
                      : '≈ ₹${_calculatedRupees.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00796B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Quick Selection Chips
          Row(
            children: presets.map((amount) {
              final isCurrent = _calculatedRupees.round() == amount;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: InkWell(
                    onTap: () => _onPresetSelected(amount),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrent ? const Color(0xFFFEF3C7) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isCurrent ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        '₹$amount',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                          color: isCurrent ? const Color(0xFF78350F) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Recipient Information & Personalized Greeting Form
  Widget _buildRecipientForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recipient Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),

          // Recipient Name
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Recipient Name',
              hintText: 'e.g. Rahul Sharma',
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00796B), width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Recipient Phone Number
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              counterText: '',
              labelText: 'Mobile Number',
              hintText: '98765 43210',
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                width: 60,
                child: const Text(
                  '+91',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.contact_phone_outlined, size: 20, color: Color(0xFF00796B)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacts picker ready!')),
                  );
                },
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00796B), width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Personalized Note
          TextField(
            controller: _messageController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Personalized Greeting Message',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00796B), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Trust & Security Row
  Widget _buildTrustBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _TrustPill(icon: Icons.security_rounded, label: '100% Insured Vaults'),
          _TrustPill(icon: Icons.electric_bolt_rounded, label: 'Instant SMS & WhatsApp'),
          _TrustPill(icon: Icons.verified_rounded, label: 'BIS Hallmarked'),
        ],
      ),
    );
  }

  /// Sticky Bottom Checkout Bar
  Widget _buildBottomAction() {
    final amountText = _calculatedRupees.toStringAsFixed(0);
    final weightText = _calculatedGrams.toStringAsFixed(4);
    final metalName = _isGold ? 'Gold' : 'Silver';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹$amountText',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '$weightText g $metalName (Incl. 3% GST)',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _showSuccessDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Send Gift Now',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Celebratory Gift Sent Success Dialog
  void _showSuccessDialog() {
    final recipientName = _nameController.text.trim().isEmpty ? 'Loved One' : _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final amount = _calculatedRupees.toStringAsFixed(0);
    final weight = _calculatedGrams.toStringAsFixed(4);
    final metalName = _isGold ? '24K 99.9% Pure Gold' : '99.99% Pure Silver';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 3D Gift Box
                Image.asset('assets/clean_gift.png', width: 95, height: 95),
                const SizedBox(height: 12),

                const Text(
                  'Gift Sent Successfully! 🎁',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹$amount ($weight g $metalName)\nhas been sent to $recipientName ($phone)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                // Share on WhatsApp Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                    label: const Text(
                      'Share on WhatsApp',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening WhatsApp with gift greeting for $recipientName!'),
                          backgroundColor: const Color(0xFF16A34A),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Copy Link Button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text(
                      'Copy Gift Link',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: 'https://golden.app/gift/claim?id=gft_${DateTime.now().millisecondsSinceEpoch}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gift claim link copied to clipboard!')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context); // back to home
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrustPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF00796B)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}

