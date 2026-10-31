import 'package:flutter/material.dart';

class GullakGoal {
  final String id;
  final String prefix;
  final String title;
  final String cleanImageAsset;
  final Color titleColor;
  final List<Color> gradientColors;
  final double defaultTarget;
  final String description;

  const GullakGoal({
    required this.id,
    required this.prefix,
    required this.title,
    required this.cleanImageAsset,
    required this.titleColor,
    required this.gradientColors,
    this.defaultTarget = 50000,
    this.description = '',
  });

  static const List<GullakGoal> allGoals = [
    GullakGoal(
      id: 'house',
      prefix: 'Dream',
      title: 'House',
      cleanImageAsset: 'assets/clean_house.png',
      titleColor: Color(0xFF1E1B4B),
      gradientColors: [Color(0xFFEDE9FE), Color(0xFFE0E7FF)],
      defaultTarget: 500000,
      description: 'Build your dream home stone by stone with gold savings',
    ),
    GullakGoal(
      id: 'gold',
      prefix: 'My',
      title: 'Gold Savings',
      cleanImageAsset: 'assets/clean_gold_savings.png',
      titleColor: Color(0xFF451A03),
      gradientColors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
      defaultTarget: 100000,
      description: 'Accumulate physical 24K 999.9 pure hallmarked gold',
    ),
    GullakGoal(
      id: 'wedding',
      prefix: 'Perfect',
      title: 'Wedding',
      cleanImageAsset: 'assets/clean_wedding.png',
      titleColor: Color(0xFF881337),
      gradientColors: [Color(0xFFFFF1F2), Color(0xFFFCE7F3)],
      defaultTarget: 300000,
      description: 'Save gold jewelry for the most special day of your life',
    ),
    GullakGoal(
      id: 'gift',
      prefix: 'Gifting',
      title: 'Goal',
      cleanImageAsset: 'assets/clean_gift.png',
      titleColor: Color(0xFF78350F),
      gradientColors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
      defaultTarget: 25000,
      description: 'Gift timeless pure gold to loved ones on birthdays & festivals',
    ),
    GullakGoal(
      id: 'education',
      prefix: "Child's",
      title: 'Future',
      cleanImageAsset: 'assets/clean_education.png',
      titleColor: Color(0xFF0F172A),
      gradientColors: [Color(0xFFF0FDF4), Color(0xFFE0F2FE)],
      defaultTarget: 200000,
      description: 'Secure higher education and future career milestones',
    ),
    GullakGoal(
      id: 'travel',
      prefix: 'Travel',
      title: 'Dream',
      cleanImageAsset: 'assets/clean_travel.png',
      titleColor: Color(0xFF0C4A6E),
      gradientColors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
      defaultTarget: 75000,
      description: 'Fund your dream international vacation without debt',
    ),
    GullakGoal(
      id: 'emergency',
      prefix: 'Emergency',
      title: 'Fund',
      cleanImageAsset: 'assets/clean_emergency.png',
      titleColor: Color(0xFF1E293B),
      gradientColors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
      defaultTarget: 150000,
      description: 'A liquid, inflation-protected safety net for rainy days',
    ),
    GullakGoal(
      id: 'custom',
      prefix: 'Custom',
      title: 'Goal',
      cleanImageAsset: 'assets/clean_custom.png',
      titleColor: Color(0xFF7C2D12),
      gradientColors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
      defaultTarget: 50000,
      description: 'Create your own personalized gold saving goal',
    ),
  ];
}
