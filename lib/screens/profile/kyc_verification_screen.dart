import 'package:flutter/material.dart';
import '../../services/golden_api_service.dart';
import '../../core/models/user_model.dart';

class KycVerificationScreen extends StatefulWidget {
  final UserModel? user;

  const KycVerificationScreen({super.key, this.user});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  late final TextEditingController _panController;
  late final TextEditingController _aadhaarController;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _panController = TextEditingController(text: widget.user?.panNumber ?? '');
    _aadhaarController = TextEditingController(text: widget.user?.aadhaarNumber ?? '');
    _isVerified = widget.user?.kycStatus == 'verified';
  }

  @override
  void dispose() {
    _panController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  void _submitKyc() async {
    final pan = _panController.text.trim().toUpperCase();
    final aadhaar = _aadhaarController.text.trim();

    if (pan.isEmpty || pan.length < 10) {
      setState(() => _errorMessage = 'Please enter a valid 10-character PAN number');
      return;
    }

    if (aadhaar.isEmpty || aadhaar.replaceAll(' ', '').length < 12) {
      setState(() => _errorMessage = 'Please enter a valid 12-digit Aadhaar number');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final res = await GoldenApiService.instance.submitKyc(
      panNumber: pan,
      aadhaarNumber: aadhaar.replaceAll(' ', ''),
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (res.success) {
      setState(() => _isVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message.isNotEmpty ? res.message : 'KYC Documents Verified Successfully!'),
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
          onPressed: () => Navigator.pop(context, _isVerified),
        ),
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isVerified ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isVerified ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isVerified ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isVerified ? Icons.check_rounded : Icons.pending_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isVerified ? 'KYC Status: Verified' : 'KYC Status: Action Required',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _isVerified ? const Color(0xFF065F46) : const Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isVerified
                                ? 'Your identity is fully verified. Unlimited buy, sell & physical delivery unlocked.'
                                : 'Complete statutory verification to comply with Indian PMLA bullion regulations.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _isVerified ? const Color(0xFF047857) : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Section Card
              Container(
                padding: const EdgeInsets.all(20),
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
                    const Text(
                      'Document Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your PAN and Aadhaar details as they appear on your government-issued cards.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // PAN Field
                    const Text(
                      'PAN Card Number',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _panController,
                      enabled: !_isVerified,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'e.g. ABCDE1234F',
                        counterText: '',
                        prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF005953)),
                        filled: true,
                        fillColor: _isVerified ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF005953), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Aadhaar Field
                    const Text(
                      'Aadhaar Number (12 Digits)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _aadhaarController,
                      enabled: !_isVerified,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      decoration: InputDecoration(
                        hintText: 'e.g. 123456789012',
                        counterText: '',
                        prefixIcon: const Icon(Icons.fingerprint_rounded, color: Color(0xFF005953)),
                        filled: true,
                        fillColor: _isVerified ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF005953), width: 1.5),
                        ),
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Submit Button
                    if (!_isVerified)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitKyc,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005953),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text(
                                  'Submit & Verify KYC',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Trust Badges
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildTrustPoint(
                      Icons.shield_outlined,
                      '100% Insured Brink\'s Custody',
                      'Every gram of 24K Gold is physically allocated and fully insured by Lloyds of London.',
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildTrustPoint(
                      Icons.lock_outline_rounded,
                      '256-Bit Financial Encryption',
                      'Your personal government identifiers are encrypted and never shared with third parties.',
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildTrustPoint(
                      Icons.verified_outlined,
                      'Statutory PMLA & RBI Compliance',
                      'Meets mandatory statutory precious metals anti-money laundering requirements.',
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

  Widget _buildTrustPoint(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFD97706), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

