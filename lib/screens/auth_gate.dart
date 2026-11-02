import 'package:flutter/material.dart';
import '../core/storage/secure_token_storage.dart';
import '../services/golden_api_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'profile/complete_profile_screen.dart';

/// AuthGate serves as the security gateway for Golden.
///
/// It checks whether a valid, non-expired token exists in hardware-backed Secure Storage:
/// - If token is NOT present or EXPIRED -> Routes directly to Login/Sign-up screen.
/// - If token is valid & profile is incomplete -> Routes to CompleteProfileScreen.
/// - If token is valid & profile is complete -> Restores session and routes to HomeScreen.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Artificial micro-pause for smooth frame transition
    await Future.delayed(const Duration(milliseconds: 300));

    final storage = SecureTokenStorage.instance;
    final token = await storage.getToken();
    final isExpired = storage.isTokenExpired(token);

    // If token is missing or has expired, ensure credentials are wiped and go to login
    if (token == null || token.trim().isEmpty || isExpired) {
      await storage.clearAuth();
      GoldenApiService.instance.clearSession();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignupScreen()),
      );
      return;
    }

    // Valid token present: initialize client authentication
    GoldenApiService.instance.setAuthToken(token);

    // Restore cached/remote user profile
    final user = await GoldenApiService.instance.restoreUserSession();

    if (!mounted) return;

    if (user == null || user.needsFirstTimeProfileSetup || !user.hasProfileData) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(
            phoneNumber: user?.phoneNumber ?? '',
            countryCode: user?.countryCode ?? '+91',
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gold Ingot Icon container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE5C07B), Color(0xFFD4AF37), Color(0xFFB8860B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Color(0xFF0F172A),
                size: 42,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GOLDEN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Secure Vault Verification',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00AAA1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

