import 'package:flutter/material.dart';
import '../../services/golden_api_service.dart';
import '../../core/models/support_model.dart';

class SecurityTrustScreen extends StatefulWidget {
  const SecurityTrustScreen({super.key});

  @override
  State<SecurityTrustScreen> createState() => _SecurityTrustScreenState();
}

class _SecurityTrustScreenState extends State<SecurityTrustScreen> {
  TrustFaqsModel? _trustData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrustData();
  }

  void _fetchTrustData() async {
    setState(() => _isLoading = true);
    final res = await GoldenApiService.instance.getTrustFaqs();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _trustData = res.data;
      });
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
          'Vault Security & Trust',
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
                    // Golden Vault Hero Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.security_rounded,
                              color: Color(0xFFD97706),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Brink's Global Custody",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '100% physically backed & verified in institutional bank-grade vaults.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF78350F),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Trust Badges Grid
                    const Text(
                      'Security Guarantees',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_trustData != null && _trustData!.trustBadges.isNotEmpty)
                      ..._trustData!.trustBadges.map((badge) => _buildBadgeCard(badge))
                    else ...[
                      _buildStaticBadge(
                        Icons.shield_outlined,
                        '100% Insured by Lloyds of London',
                        'All vaulted bullion carries full insurance against theft, damage, and natural disasters.',
                      ),
                      _buildStaticBadge(
                        Icons.verified_outlined,
                        '24K 99.9% Pure & BIS Hallmarked',
                        'Direct wholesale sourcing strictly conforming to HSN 7108/7106 purity standards.',
                      ),
                      _buildStaticBadge(
                        Icons.fact_check_outlined,
                        'Quarterly Independent Audits',
                        'Third-party security audits independently verify every physical bar and gram.',
                      ),
                    ],

                    const SizedBox(height: 24),

                    // FAQs Accordion
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_trustData != null && _trustData!.faqs.isNotEmpty)
                      ..._trustData!.faqs.map((faq) => _buildFaqCard(faq.question, faq.answer))
                    else ...[
                      _buildFaqCard(
                        'Where is my gold stored?',
                        'Your digital gold is physically stored in world-class, bank-grade vaults managed by Brink\'s Global Services, the world leader in secure logistics and vaulted custody.',
                      ),
                      _buildFaqCard(
                        'Can I convert digital gold to physical coins?',
                        'Yes, anytime! You can request physical delivery of 24K pure BIS-hallmarked gold coins and bars directly to your doorstep in tamper-proof insured packaging.',
                      ),
                      _buildFaqCard(
                        'Are my transactions safe?',
                        'All orders are processed through bank-grade 256-bit SSL encrypted channels, with instant IMPS payouts credited directly to your verified bank account.',
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBadgeCard(TrustBadgeModel badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  badge.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticBadge(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF16A34A), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCard(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF005953),
          collapsedIconColor: const Color(0xFF64748B),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

