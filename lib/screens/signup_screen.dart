import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/hero_video_widget.dart';
import '../widgets/phone_input_card.dart';
import '../widgets/otp_verification_view.dart';
import '../widgets/country_picker_modal.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isOtpStep = false;
  bool _isSubmitting = false;
  String _enteredPhone = '';
  String _selectedCountryCode = '+91';

  void _onPhoneSubmit(Country country, String phone) async {
    setState(() {
      _isSubmitting = true;
      _selectedCountryCode = country.code;
      _enteredPhone = phone;
    });

    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _isOtpStep = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification code sent to ${country.code} $phone'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF00AAA1),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onVerificationSuccess() {
    final TextEditingController nameController =
        TextEditingController(text: 'Prince');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF00AAA1).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF00AAA1),
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Verification Successful',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Account verified for $_selectedCountryCode $_enteredPhone',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              // Name personalization input
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: Color(0xFF00AAA1),
                    ),
                    hintText: 'Enter your name',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final userName = nameController.text.trim().isNotEmpty
                        ? nameController.text.trim()
                        : 'Prince';
                    Navigator.pop(dialogContext);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(
                          userName: userName,
                          phoneNumber: '$_selectedCountryCode $_enteredPhone',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00AAA1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardInset > 0;
    // Perfectly proportioned bottom sheet height
    final loginBoxHeight = (screenHeight * 0.40).clamp(320.0, 390.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Upper Section: Box-fitted 3D video asset
            Expanded(
              flex: isKeyboardOpen ? 1 : 2,
              child: const SizedBox(
                width: double.infinity,
                child: ClipRect(
                  child: HeroVideoWidget(
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Lower Section: Redesigned Executive Bottom Sheet
            Container(
              height: isKeyboardOpen ? null : loginBoxHeight,
              constraints: isKeyboardOpen
                  ? BoxConstraints(maxHeight: screenHeight * 0.6)
                  : null,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                border: const Border(
                  top: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, -6),
                  ),
                  BoxShadow(
                    color: const Color(0xFF00AAA1).withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 14),
              child: Column(
                mainAxisSize: isKeyboardOpen ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  // Sheet Drag Handle Pill
                  Center(
                    child: Container(
                      width: 40,
                      height: 4.5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // Sheet Form Body
                  Expanded(
                    flex: isKeyboardOpen ? 0 : 1,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _isOtpStep
                            ? OtpVerificationView(
                                key: const ValueKey('otp_view'),
                                phoneNumber: _enteredPhone,
                                countryCode: _selectedCountryCode,
                                onEditNumber: () {
                                  setState(() {
                                    _isOtpStep = false;
                                  });
                                },
                                onVerificationSuccess:
                                    _onVerificationSuccess,
                              )
                            : PhoneInputCard(
                                key: const ValueKey('phone_view'),
                                initialPhone: _enteredPhone,
                                initialCountryCode: _selectedCountryCode,
                                onSubmit: _onPhoneSubmit,
                                isLoading: _isSubmitting,
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
    );
  }
}
