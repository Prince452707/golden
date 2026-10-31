import 'package:flutter/material.dart';
import '../widgets/gold_3d_widgets.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Buy', 'Sell', 'Gifts', 'Delivery'];

  final List<_TransactionItemData> _allTransactions = [
    _TransactionItemData(
      type: 'Buy',
      title: 'Bought Gold',
      date: '12 Oct 2026, 11:34 AM',
      amount: '₹2,014.00',
      weight: '1.0380 g',
      isCredit: false,
      iconType: _TxIconType.gold,
    ),
    _TransactionItemData(
      type: 'Sell',
      title: 'Sold Silver',
      date: '5 Oct 2026, 4:12 PM',
      amount: '₹460.50',
      weight: '5.000 g',
      isCredit: true,
      iconType: _TxIconType.silver,
    ),
    _TransactionItemData(
      type: 'Gifts',
      title: 'Gifted Gold',
      date: '1 Oct 2026, 9:18 AM',
      amount: '₹500.00',
      weight: '0.0500 g',
      isCredit: false,
      iconType: _TxIconType.gift,
    ),
    _TransactionItemData(
      type: 'Buy',
      title: 'Bought Gold',
      date: '22 Sept 2026, 11:30 AM',
      amount: '₹2,014.00',
      weight: '2.000 g',
      isCredit: false,
      iconType: _TxIconType.gold,
    ),
    _TransactionItemData(
      type: 'Sell',
      title: 'Sold Gold',
      date: '10 Sept 2026, 2:14 PM',
      amount: '₹505.00',
      weight: '0.0600 g',
      isCredit: true,
      iconType: _TxIconType.soldGold,
    ),
    _TransactionItemData(
      type: 'Delivery',
      title: 'Delivery Order',
      date: '3 Sept 2026, 6:20 PM',
      amount: '₹8,934.00',
      weight: '1 coin (10 g)',
      isCredit: false,
      iconType: _TxIconType.delivery,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedFilter == 'All'
        ? _allTransactions
        : _allTransactions.where((t) => t.type == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar: Back Arrow + "Transactions"
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
                    'Transactions',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Filter Pills Row
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF005953) : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF005953) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Transactions List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: filteredList.length,
                separatorBuilder: (_, __) => const Divider(height: 18, color: Color(0xFFF1F5F9)),
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return _buildTransactionItemRow(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItemRow(_TransactionItemData item) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title}: ${item.amount} (${item.weight}) • 24K Certified'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            // Icon
            _buildIcon(item.iconType),

            const SizedBox(width: 14),

            // Title + Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Amount + Weight
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.amount,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: item.isCredit ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.weight,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 6),

            // Chevron
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(_TxIconType type) {
    Color bg;
    Widget icon;

    switch (type) {
      case _TxIconType.gold:
        bg = const Color(0xFFFEF3C7);
        icon = Container(
          width: 20,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B),
            borderRadius: BorderRadius.circular(2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD97706).withValues(alpha: 0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'G',
              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
        );
        break;

      case _TxIconType.silver:
        bg = const Color(0xFFF1F5F9);
        icon = Container(
          width: 20,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFF94A3B8),
            borderRadius: BorderRadius.circular(2.5),
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
        );
        break;

      case _TxIconType.gift:
        bg = const Color(0xFFFFEDD5);
        icon = const Icon(Icons.card_giftcard_rounded, size: 20, color: Color(0xFFEA580C));
        break;

      case _TxIconType.soldGold:
        bg = const Color(0xFFFEE2E2);
        icon = const Icon(Icons.arrow_downward_rounded, size: 20, color: Color(0xFFDC2626));
        break;

      case _TxIconType.delivery:
        bg = const Color(0xFFFEF3C7);
        icon = const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFFD97706));
        break;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }
}

enum _TxIconType {
  gold,
  silver,
  gift,
  soldGold,
  delivery,
}

class _TransactionItemData {
  final String type;
  final String title;
  final String date;
  final String amount;
  final String weight;
  final bool isCredit;
  final _TxIconType iconType;

  _TransactionItemData({
    required this.type,
    required this.title,
    required this.date,
    required this.amount,
    required this.weight,
    required this.isCredit,
    required this.iconType,
  });
}

