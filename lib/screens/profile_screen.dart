import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import '../widgets/gullak/gullak_bottom_nav.dart';
import 'signup_screen.dart';
import 'gift_bullion_screen.dart';
import 'profile/kyc_verification_screen.dart';
import 'profile/bank_accounts_screen.dart';
import 'profile/referral_rewards_screen.dart';
import 'profile/advisor_support_screen.dart';
import 'profile/security_trust_screen.dart';
import 'profile/complete_profile_screen.dart';
import '../services/golden_api_service.dart';
import '../core/models/user_model.dart';
import '../core/models/bank_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;

  const ProfileScreen({
    super.key,
    this.userName = 'Golden Member',
    this.phoneNumber = '',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  BankAccountModel? _primaryBank;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = GoldenApiService.instance.currentUser;
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    setState(() => _isLoading = true);
    
    // 1. Fetch Latest Profile
    final userRes = await GoldenApiService.instance.getUserProfile();
    // 2. Fetch Linked Bank Accounts
    final bankRes = await GoldenApiService.instance.getBankAccounts();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (userRes.data != null) {
          _user = userRes.data;
        }
        if (bankRes.data != null && bankRes.data!.isNotEmpty) {
          _primaryBank = bankRes.data!.firstWhere(
            (b) => b.isPrimary,
            orElse: () => bankRes.data!.first,
          );
        }
      });
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        backgroundColor: const Color(0xFF005953),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _user?.fullName.isNotEmpty == true
        ? _user!.fullName
        : (widget.userName.isNotEmpty ? widget.userName : 'Golden Member');
    final displayPhone = _user != null && _user!.phoneNumber.isNotEmpty
        ? '${_user!.countryCode} ${_user!.phoneNumber}'
        : widget.phoneNumber;
    final initials = _user?.avatarInitials.isNotEmpty == true
        ? _user!.avatarInitials
        : (displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G');
    final email = _user?.email.isNotEmpty == true ? _user!.email : 'Not provided yet';
    final state = _user?.state?.isNotEmpty == true ? _user!.state! : 'All-India Tax Jurisdiction';
    final isKycVerified = _user?.kycStatus == 'verified';
    final goldGrams = _user?.goldVaultBalanceGrams ?? 0.0;
    final silverGrams = _user?.silverVaultBalanceGrams ?? 0.0;
    final cashBalance = _user?.gullakCashBalance ?? 0.0;
    final referralCode = _user?.referralCode.isNotEmpty == true ? _user!.referralCode : 'GOLD777999';

    // Live rates for valuation
    final rates = GoldenApiService.instance.latestRates;
    final goldRate = rates?.gold.buyPricePerGram ?? 0.0;
    final silverRate = rates?.silver.buyPricePerGram ?? 0.0;
    final estimatedGoldValue = goldGrams * goldRate;
    final estimatedSilverValue = silverGrams * silverRate;
    final totalPortfolioEst = estimatedGoldValue + estimatedSilverValue + cashBalance;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const HomeScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, _, _) => const HomeScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
        title: const Text(
          'My Investor Profile',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF005953)),
            tooltip: 'Edit Profile Details',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CompleteProfileScreen(
                    phoneNumber: _user?.phoneNumber ?? '',
                    countryCode: _user?.countryCode ?? '+91',
                  ),
                ),
              );
              _loadUserProfile();
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_isLoading)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFFD4AF37),
                backgroundColor: Colors.transparent,
              ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Executive Identity Card
                    _buildExecutiveIdentityCard(
                      initials: initials,
                      displayName: displayName,
                      displayPhone: displayPhone,
                      email: email,
                      state: state,
                      referralCode: referralCode,
                      isKycVerified: isKycVerified,
                    ),

                    const SizedBox(height: 18),

                    // 2. Statutory KYC & Regulatory Identity Card
                    _buildStatutoryKycCard(
                      isVerified: isKycVerified,
                      panNumber: _user?.panNumber,
                      aadhaarNumber: _user?.aadhaarNumber,
                      onVerifyTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => KycVerificationScreen(user: _user),
                          ),
                        );
                        _loadUserProfile();
                      },
                    ),

                    const SizedBox(height: 18),

                    // 3. Physical Bullion Vault & Portfolio Assets
                    _buildVaultHoldingsCard(
                      goldGrams: goldGrams,
                      silverGrams: silverGrams,
                      cashBalance: cashBalance,
                      estimatedGoldValue: estimatedGoldValue,
                      estimatedSilverValue: estimatedSilverValue,
                      totalPortfolioEst: totalPortfolioEst,
                    ),

                    const SizedBox(height: 18),

                    // 4. Linked Banking & IMPS Payout Account
                    _buildLinkedBankCard(context),

                    const SizedBox(height: 20),

                    // Section Heading: Platform Services & Trust
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'VAULT SERVICES & COMPLIANCE',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    // 5. Navigation Hub
                    _buildNavigationHub(context, isKycVerified),

                    const SizedBox(height: 24),

                    // 6. Logout Button
                    _buildLogoutButton(context),

                    const SizedBox(height: 16),

                    // Footer security badge
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock_rounded, size: 13, color: Color(0xFF94A3B8)),
                          SizedBox(width: 6),
                          Text(
                            'Brink\'s Global Custody • Lloyd\'s of London Insured • 256-Bit SSL',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar with Profile selected (index 3)
            const GullakBottomNav(selectedIndex: 3),
          ],
        ),
      ),
    ),
  );
}

  /// 1. Executive Identity Card with Gold Badge
  Widget _buildExecutiveIdentityCard({
    required String initials,
    required String displayName,
    required String displayPhone,
    required String email,
    required String state,
    required String referralCode,
    required bool isKycVerified,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF005953), Color(0xFF044843)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005953).withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar Circle with Golden Accent
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF005953),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Name, Phone & KYC Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.phone_iphone_rounded, size: 14, color: Color(0xFF93C5FD)),
                        const SizedBox(width: 4),
                        Text(
                          displayPhone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFE2E8F0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isKycVerified ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isKycVerified ? Icons.verified_rounded : Icons.pending_actions_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isKycVerified ? 'Verified Vault Custody' : 'KYC Verification Pending',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFF1B6A64)),
          const SizedBox(height: 14),

          // Email & State Details
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 15, color: Color(0xFF93C5FD)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFFE2E8F0), fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state,
                  style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Referral Code Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.share_rounded, size: 15, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Referral Code:',
                      style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      referralCode,
                      style: const TextStyle(
                        color: Color(0xFFFDE68A),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => _copyToClipboard(referralCode, 'Referral code'),
                  child: const Text(
                    'COPY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Statutory KYC & Regulatory Credentials
  Widget _buildStatutoryKycCard({
    required bool isVerified,
    required String? panNumber,
    required String? aadhaarNumber,
    required VoidCallback onVerifyTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
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
              Row(
                children: const [
                  Icon(Icons.shield_outlined, color: Color(0xFF005953), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Statutory KYC Credentials',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              InkWell(
                onTap: onVerifyTap,
                child: Text(
                  isVerified ? 'View' : 'Verify Now',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isVerified ? const Color(0xFF005953) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('PAN Card (10-char):', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              Text(
                panNumber?.isNotEmpty == true ? panNumber! : 'Pending Submission',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: panNumber?.isNotEmpty == true ? const Color(0xFF0F172A) : const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Aadhaar Verification:', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              Text(
                aadhaarNumber?.isNotEmpty == true ? aadhaarNumber! : 'Pending Submission',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: aadhaarNumber?.isNotEmpty == true ? const Color(0xFF0F172A) : const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'PMLA Compliant • Allocated at Brink\'s Global Bullion Vault',
                    style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Physical Bullion Vault & Portfolio Assets
  Widget _buildVaultHoldingsCard({
    required double goldGrams,
    required double silverGrams,
    required double cashBalance,
    required double estimatedGoldValue,
    required double estimatedSilverValue,
    required double totalPortfolioEst,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
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
              Row(
                children: const [
                  Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFD4AF37), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Vault Holdings & Balances',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Text(
                '≈ ₹${totalPortfolioEst.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF005953),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3-Column Asset Breakdown
          Row(
            children: [
              // 24K Gold
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '24K GOLD',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${goldGrams.toStringAsFixed(4)}g',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        '≈ ₹${estimatedGoldValue.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFFB45309)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // 999 Silver
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '999 SILVER',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${silverGrams.toStringAsFixed(4)}g',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        '≈ ₹${estimatedSilverValue.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Gullak Cash
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GULLAK CASH',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF065F46)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${cashBalance.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                      const Text(
                        'Instant IMPS',
                        style: TextStyle(fontSize: 10.5, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4. Linked Banking & IMPS Payout Account
  Widget _buildLinkedBankCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
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
              Row(
                children: const [
                  Icon(Icons.account_balance_rounded, color: Color(0xFF005953), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Payout Bank Account',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BankAccountsScreen()),
                  );
                  _loadUserProfile();
                },
                child: const Text(
                  'Manage',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF005953)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_primaryBank != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_outlined, size: 20, color: Color(0xFF16A34A)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _primaryBank!.bankName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          'A/C: ${_primaryBank!.maskedAccountNumber} • IFSC: ${_primaryBank!.ifscCode}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Verified',
                      style: TextStyle(color: Color(0xFF15803D), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Text(
                'No bank account linked yet. Link your verified bank account for instant IMPS liquidations.',
                style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 5. Navigation Hub
  Widget _buildNavigationHub(BuildContext context, bool isKycVerified) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.badge_outlined,
            label: 'KYC Verification',
            badge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isKycVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isKycVerified ? 'Verified' : 'Pending',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isKycVerified ? const Color(0xFF15803D) : const Color(0xFFB45309),
                ),
              ),
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KycVerificationScreen(user: _user),
                ),
              );
              _loadUserProfile();
            },
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildMenuItem(
            icon: Icons.account_balance_outlined,
            label: 'My Bank Accounts',
            badge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _primaryBank?.bankName ?? 'Link Bank',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                ),
              ),
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BankAccountsScreen(),
                ),
              );
              _loadUserProfile();
            },
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildMenuItem(
            icon: Icons.card_giftcard_rounded,
            label: 'Gift Gold & Silver',
            badge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Send 24K',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GiftBullionScreen()),
              );
            },
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildMenuItem(
            icon: Icons.share_rounded,
            label: 'Refer & Earn ₹1,000',
            badge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Win ₹1000',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReferralRewardsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildMenuItem(
            icon: Icons.support_agent_rounded,
            label: '24/7 Gold Advisor Support',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AdvisorSupportScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            label: 'Trust Pillars & Brink\'s Vaulting',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SecurityTrustScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    Widget? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF334155)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            if (badge != null) ...[
              badge,
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: () async {
          await GoldenApiService.instance.logout();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignupScreen()),
              (route) => false,
            );
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFEF2F2),
          foregroundColor: const Color(0xFFEF4444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFFEF4444),
          ),
        ),
      ),
    );
  }
}
