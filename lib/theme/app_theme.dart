import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors matching exact inspiration
  static const Color primaryTeal = Color(0xFF00AAA1);
  static const Color primaryTealDark = Color(0xFF008E86);
  static const Color mintBorder = Color(0xFFCDE1E0);
  static const Color mintInputBorder = Color(0xFFB4E0DD);
  static const Color stepperDot = Color(0xFF87E1DF);
  static const Color stepperLine = Color(0xFFD6ECEB);

  // Background & Surfaces
  static const Color background = Color(0xFFF7F7F7);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF1E293B);
  static const Color textTitle = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFF8E1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        surface: surfaceWhite,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
