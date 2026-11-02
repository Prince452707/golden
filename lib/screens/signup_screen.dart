import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile/complete_profile_screen.dart';
import '../widgets/hero_video_widget.dart';
import '../widgets/phone_input_card.dart';
import '../widgets/otp_verification_view.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../services/golden_api_service.dart';

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

  void _onPhoneSubmit(CountryCode country, String phone) async {
    // Clear any previous session so the new phone number starts completely fresh
    GoldenApiService.instance.currentUser = null;

    final dialCode = country.dialCode ?? '+91';
    setState(() {
      _isSubmitting = true;
      _selectedCountryCode = dialCode;
      _enteredPhone = phone;
    });

    final res = await GoldenApiService.instance.sendOtp(
      phone,
      countryCode: dialCode,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _isOtpStep = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.message.isNotEmpty
            ? res.message
            : 'Verification code sent to $dialCode $phone'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF00AAA1),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onVerificationSuccess() {
    final user = GoldenApiService.instance.currentUser;
    final cleanEntered = _enteredPhone.replaceAll(' ', '');
    final cleanUserPhone = (user?.phoneNumber ?? '').replaceAll(' ', '');
    final phoneMatches = cleanUserPhone.isNotEmpty && cleanUserPhone == cleanEntered;

 
    final needsProfileSetup = user == null ||
        user.isNewUser ||
        user.needsFirstTimeProfileSetup ||
        (!phoneMatches && cleanEntered.isNotEmpty);

    if (needsProfileSetup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(
            phoneNumber: _enteredPhone,
            countryCode: _selectedCountryCode,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            userName: user.fullName,
            phoneNumber: '${user.countryCode} ${user.phoneNumber}',
          ),
        ),
      );
    }
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
