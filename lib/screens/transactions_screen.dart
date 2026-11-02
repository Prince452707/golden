import 'package:flutter/material.dart';
import '../services/golden_api_service.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Buy', 'Sell', 'Gifts', 'Delivery'];

  final List<_TransactionItemData> _allTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    setState(() => _isLoading = true);
    final res = await GoldenApiService.instance.getTransactions();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res.data != null && res.data!.transactions.isNotEmpty) {
          _allTransactions.clear();
          for (final item in res.data!.transactions) {
            final isBuy = item.type.toLowerCase() == 'buy';
            final isSell = item.type.toLowerCase() == 'sell';
            final isSilver = item.metal.toLowerCase() == 'silver';

            _TxIconType iconType;
            if (isBuy) {
              iconType = isSilver ? _TxIconType.silver : _TxIconType.gold;
            } else if (isSell) {
              iconType = isSilver ? _TxIconType.silver : _TxIconType.soldGold;
            } else if (item.type.toLowerCase() == 'gift') {
              iconType = _TxIconType.gift;
            } else {
              iconType = _TxIconType.delivery;
            }

            _allTransactions.add(
              _TransactionItemData(
                orderId: item.orderId,
                type: item.type,
                title: item.title.isNotEmpty ? item.title : '${item.type} ${item.metal}',
                date: item.createdAt,
                amount: '₹${item.amount.toStringAsFixed(2)}',
                weight: '${item.grams.toStringAsFixed(4)} g',
                isCredit: isSell,
                iconType: iconType,
              ),
            );
          }
        }
      });
    }
  }

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
                separatorBuilder: (context, index) => const SizedBox(width: 8),
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF005953),
                      ),
                    )
                  : filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 54,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _selectedFilter == 'All'
                                    ? 'No transactions yet'
                                    : 'No $_selectedFilter transactions found',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 18, color: Color(0xFFF1F5F9)),
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
      onTap: () => _showInvoiceModal(context, item),
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

  /// Official Digital GST Tax Invoice Modal (HSN 7108/7106)
  void _showInvoiceModal(BuildContext context, _TransactionItemData item) async {
    final invRes = await GoldenApiService.instance.getTransactionInvoice(item.orderId);
    if (!context.mounted) return;

    final invoice = invRes.data;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.receipt_long_rounded, color: Color(0xFF005953), size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Tax Invoice',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildInvoiceRow('Invoice No.', invoice?.invoiceNumber ?? 'INV-${item.orderId}'),
                    const Divider(height: 14),
                    _buildInvoiceRow('Order ID', item.orderId),
                    const Divider(height: 14),
                    _buildInvoiceRow('Refiner HSN Code', invoice?.hsnCode ?? (item.type == 'Sell' ? '7106' : '7108')),
                    const Divider(height: 14),
                    _buildInvoiceRow('Seller GSTIN', invoice?.sellerGstin ?? '07AAAAA0000A1Z5'),
                    const Divider(height: 14),
                    _buildInvoiceRow('Taxable Base Amount', '₹${invoice?.taxableBaseAmount.toStringAsFixed(2) ?? '1,955.34'}'),
                    const Divider(height: 14),
                    _buildInvoiceRow('CGST (1.5%)', '₹${invoice?.cgstAmount.toStringAsFixed(2) ?? '29.33'}'),
                    const Divider(height: 14),
                    _buildInvoiceRow('SGST (1.5%)', '₹${invoice?.sgstAmount.toStringAsFixed(2) ?? '29.33'}'),
                    const Divider(height: 14),
                    _buildInvoiceRow(
                      'Total Invoice Amount',
                      '₹${invoice?.totalPayableAmount.toStringAsFixed(2) ?? item.amount}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 16),
                  SizedBox(width: 6),
                  Text(
                    '100% Insured Brink\'s Global Vault Physical Allocation',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF047857), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvoiceRow(String label, String value, {bool isBold = false}) {
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
            color: isBold ? const Color(0xFF005953) : const Color(0xFF0F172A),
          ),
        ),
      ],
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
  final String orderId;
  final String type;
  final String title;
  final String date;
  final String amount;
  final String weight;
  final bool isCredit;
  final _TxIconType iconType;

  _TransactionItemData({
    required this.orderId,
    required this.type,
    required this.title,
    required this.date,
    required this.amount,
    required this.weight,
    required this.isCredit,
    required this.iconType,
  });
}

