import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneInputCard extends StatefulWidget {
  final Function(CountryCode country, String phone) onSubmit;
  final bool isLoading;
  final String? initialPhone;
  final String? initialCountryCode;

  const PhoneInputCard({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.initialPhone,
    this.initialCountryCode,
  });

  @override
  State<PhoneInputCard> createState() => _PhoneInputCardState();
}

class _PhoneInputCardState extends State<PhoneInputCard> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  CountryCode _selectedCountry = CountryCode(
    name: 'India',
    code: 'IN',
    dialCode: '+91',
  );
  bool _isFocused = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialCountryCode != null &&
        widget.initialCountryCode!.isNotEmpty) {
      final code = widget.initialCountryCode!;
      _selectedCountry = CountryCode(
        dialCode: code.startsWith('+') ? code : '+$code',
        code: code.replaceAll('+', ''),
      );
    }
    if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _phoneController.text = _formatPhoneNumber(widget.initialPhone!);
    }
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  String _formatPhoneNumber(String raw) {
    final clean = raw.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      buffer.write(clean[i]);
      if (i == 4 && i != clean.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _rawNumber => _phoneController.text.replaceAll(' ', '');

  bool get _isValid {
    final clean = _rawNumber;
    if (clean.isEmpty) return false;
    final dial = _selectedCountry.dialCode ?? '+91';
    if (dial == '+91') {
      return clean.length == 10;
    }
    return clean.length >= 7 && clean.length <= 15;
  }

  void _handleSubmit() {
    if (widget.isLoading) return;

    if (!_isValid) {
      setState(() {
        final dial = _selectedCountry.dialCode ?? '+91';
        if (dial == '+91') {
          _errorMessage = 'Please enter a valid 10-digit mobile number';
        } else {
          _errorMessage = 'Please enter a valid mobile number (7-15 digits)';
        }
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });
    widget.onSubmit(_selectedCountry, _rawNumber);
  }

  void _showTermsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  '1. Digital Gold Storage: All gold bought through this platform is 24 Karat 99.99% pure bullion, stored in institutional Brink\'s vaults.\n\n'
                  '2. Account Security: Never share your one-time password (OTP) with anyone. Support staff will never ask for your verification code.\n\n'
                  '3. Liquidity: Buy, sell, or request physical door-step delivery anytime at live transparent market rates.\n\n'
                  '4. Privacy: We safeguard your private data using banking-grade AES-256 encryption.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AAA1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('I Understand'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header Row with Glowing Turquoise Accent Dot
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00AAA1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00AAA1).withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Login or Sign up',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Subtitle / Tagline
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Enter your mobile number to get started',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ),

        const SizedBox(height: 16),
        Container(
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _errorMessage != null
                  ? Colors.redAccent
                  : _isFocused
                      ? const Color(0xFF00AAA1)
                      : const Color(0xFFE2E8F0),
              width: _isFocused ? 1.8 : 1.2,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: const Color(0xFF00AAA1).withValues(alpha: 0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Country Code Picker with international catalog
              CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    _selectedCountry = country;
                    _errorMessage = null;
                  });
                },
                onInit: (country) {
                  if (country != null) {
                    _selectedCountry = country;
                  }
                },
                initialSelection: widget.initialCountryCode ?? '+91',
                favorite: const [
                  '+91',
                  'IN',
                  '+971',
                  'AE',
                  '+1',
                  'US',
                  '+44',
                  'GB',
                  '+65',
                  'SG',
                ],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                pickerStyle: PickerStyle.bottomSheet,
                boxDecoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                searchDecoration: InputDecoration(
                  hintText: 'Search country or code...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF00AAA1),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
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
                    borderSide: const BorderSide(
                      color: Color(0xFF00AAA1),
                      width: 1.5,
                    ),
                  ),
                ),
                searchStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
                dialogTextStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
                closeIcon: const Icon(
                  Icons.close,
                  color: Color(0xFF64748B),
                  size: 22,
                ),
                builder: (countryCode) {
                  final flagUri = countryCode?.flagUri;
                  final dialCode = countryCode?.dialCode ?? '+91';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (flagUri != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Image.asset(
                              flagUri,
                              package: 'country_code_picker',
                              width: 24,
                              height: 16,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Text(
                                '🇮🇳',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          dialCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Vertical Divider
              Container(
                height: 26,
                width: 1.2,
                color: const Color(0xFFCBD5E1),
              ),

              const SizedBox(width: 12),

              // Mobile Number Input Field
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: Color(0xFF0F172A),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      _selectedCountry.dialCode == '+91' ? 10 : 15,
                    ),
                    _PhoneNumberFormatter(),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.1,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (val) {
                    if (_errorMessage != null) {
                      setState(() {
                        _errorMessage = null;
                      });
                    } else {
                      setState(() {});
                    }
                  },
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),

              if (_phoneController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Color(0xFF94A3B8),
                    size: 18,
                  ),
                  onPressed: () {
                    _phoneController.clear();
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                ),
            ],
          ),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Action CTA Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: !widget.isLoading ? _handleSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00AAA1),
              foregroundColor: Colors.white,
              elevation: 3,
              shadowColor: const Color(0xFF00AAA1).withValues(alpha: 0.45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 14),

        // Subtext / Terms & Conditions
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'By proceeding, you agree to our ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            GestureDetector(
              onTap: () => _showTermsDialog(context),
              child: const Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00AAA1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 4 && i != text.length - 1) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
