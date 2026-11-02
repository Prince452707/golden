import 'package:flutter/material.dart';
import '../../services/golden_api_service.dart';
import '../../core/models/bank_model.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  List<BankAccountModel> _accounts = [];
  bool _isLoading = true;
  bool _isLinkingNew = false;
  bool _isSubmitting = false;

  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _confirmAccountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _holderNameController = TextEditingController();
  String _accountType = 'Savings';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _confirmAccountController.dispose();
    _ifscController.dispose();
    _holderNameController.dispose();
    super.dispose();
  }

  void _fetchAccounts() async {
    setState(() => _isLoading = true);
    final res = await GoldenApiService.instance.getBankAccounts();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _accounts = res.data ?? [];
      });
    }
  }

  void _linkAccount() async {
    final bankName = _bankNameController.text.trim();
    final accNum = _accountNumberController.text.trim();
    final confirmNum = _confirmAccountController.text.trim();
    final ifsc = _ifscController.text.trim().toUpperCase();
    final holder = _holderNameController.text.trim();

    if (bankName.isEmpty || accNum.isEmpty || ifsc.isEmpty || holder.isEmpty) {
      setState(() => _errorMessage = 'Please fill all required banking details.');
      return;
    }

    if (accNum != confirmNum) {
      setState(() => _errorMessage = 'Account numbers do not match.');
      return;
    }

    if (ifsc.length < 11) {
      setState(() => _errorMessage = 'Please enter a valid 11-digit IFSC code.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final res = await GoldenApiService.instance.linkBankAccount(
      bankName: bankName,
      accountNumber: accNum,
      ifscCode: ifsc,
      accountHolderName: holder,
      accountType: _accountType,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (res.success && res.data != null) {
      setState(() {
        _isLinkingNew = false;
        _bankNameController.clear();
        _accountNumberController.clear();
        _confirmAccountController.clear();
        _ifscController.clear();
        _holderNameController.clear();
      });
      _fetchAccounts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message.isNotEmpty ? res.message : 'Bank Account Linked & Verified!'),
          backgroundColor: const Color(0xFF005953),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() => _errorMessage = res.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bank & Payout Accounts',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF005953)),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Linked Accounts List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Linked Accounts',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (!_isLinkingNew)
                          TextButton.icon(
                            onPressed: () => setState(() => _isLinkingNew = true),
                            icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFF005953)),
                            label: const Text(
                              'Add New',
                              style: TextStyle(
                                color: Color(0xFF005953),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_accounts.isEmpty && !_isLinkingNew)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEF3C7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_outlined,
                                color: Color(0xFFD97706),
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'No Bank Account Linked',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Link a verified bank account to enable instant IMPS withdrawals for bullion sell orders.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF64748B),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: () => setState(() => _isLinkingNew = true),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Link Bank Account'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005953),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ..._accounts.map((acc) => _buildAccountCard(acc)),

                    if (_isLinkingNew) ...[
                      const SizedBox(height: 20),
                      _buildAddAccountForm(),
                    ],

                    const SizedBox(height: 24),

                    // Security Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.lock_clock_outlined, color: Color(0xFF005953), size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Instant IMPS payouts are directly credited within 60 seconds of selling allocated vault bullion.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF475569),
                                height: 1.3,
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

  Widget _buildAccountCard(BankAccountModel acc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      acc.bankName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Account: ${acc.maskedAccountNumber}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              if (acc.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_rounded, size: 14, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'IFSC: ${acc.ifscCode}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              Text(
                'Instant IMPS Active',
                style: const TextStyle(fontSize: 12, color: Color(0xFF005953), fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF005953).withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005953).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                'Link Bank Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _isLinkingNew = false),
                icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildInputField('Bank Name', _bankNameController, 'e.g. HDFC Bank, ICICI Bank, SBI'),
          const SizedBox(height: 14),

          _buildInputField('Account Number', _accountNumberController, 'e.g. 5010049284219', isNumeric: true),
          const SizedBox(height: 14),

          _buildInputField('Confirm Account Number', _confirmAccountController, 'Re-enter account number', isNumeric: true),
          const SizedBox(height: 14),

          _buildInputField('IFSC Code', _ifscController, 'e.g. HDFC0000128', isCapital: true),
          const SizedBox(height: 14),

          _buildInputField('Account Holder Name', _holderNameController, 'Full name as in bank records'),
          const SizedBox(height: 14),

          // Account Type Radio
          const Text(
            'Account Type',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              ChoiceChip(
                label: const Text('Savings'),
                selected: _accountType == 'Savings',
                onSelected: (val) => setState(() => _accountType = 'Savings'),
                selectedColor: const Color(0xFF005953),
                labelStyle: TextStyle(
                  color: _accountType == 'Savings' ? Colors.white : const Color(0xFF334155),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Current'),
                selected: _accountType == 'Current',
                onSelected: (val) => setState(() => _accountType = 'Current'),
                selectedColor: const Color(0xFF005953),
                labelStyle: TextStyle(
                  color: _accountType == 'Current' ? Colors.white : const Color(0xFF334155),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _linkAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005953),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Verify & Save Account',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
    bool isCapital = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          textCapitalization: isCapital ? TextCapitalization.characters : TextCapitalization.words,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF005953), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

