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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userName: 'Prince Kumar',
          phoneNumber: '$_selectedCountryCode $_enteredPhone',
        ),
      ),
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
