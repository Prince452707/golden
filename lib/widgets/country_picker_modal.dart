import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Country {
  final String name;
  final String code;
  final String flag;
  final int maxLength;

  const Country({
    required this.name,
    required this.code,
    required this.flag,
    this.maxLength = 10,
  });
}

const List<Country> supportedCountries = [
  Country(name: 'India', code: '+91', flag: '🇮🇳', maxLength: 10),
  Country(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪', maxLength: 9),
  Country(name: 'United States', code: '+1', flag: '🇺🇸', maxLength: 10),
  Country(name: 'United Kingdom', code: '+44', flag: '🇬🇧', maxLength: 10),
  Country(name: 'Singapore', code: '+65', flag: '🇸🇬', maxLength: 8),
  Country(name: 'Australia', code: '+61', flag: '🇦🇺', maxLength: 9),
  Country(name: 'Canada', code: '+1', flag: '🇨🇦', maxLength: 10),
];

class CountryPickerModal extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onSelect;

  const CountryPickerModal({
    super.key,
    required this.selectedCountry,
    required this.onSelect,
  });

  static Future<Country?> show(BuildContext context, Country current) {
    return showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryPickerModal(
        selectedCountry: current,
        onSelect: (country) => Navigator.pop(context, country),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Select Country Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ...supportedCountries.map((c) {
              final isSelected = c.code == selectedCountry.code && c.name == selectedCountry.name;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: isSelected ? AppTheme.textLight.withValues(alpha: 0.5) : Colors.transparent,
                leading: Text(
                  c.flag,
                  style: const TextStyle(fontSize: 26),
                ),
                title: Text(
                  c.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
                trailing: Text(
                  c.code,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.primaryTeal : AppTheme.textMuted,
                  ),
                ),
                onTap: () => onSelect(c),
              );
            }),
          ],
        ),
      ),
    );
  }
}
