import 'package:flutter/material.dart';

/// PinyaCure App Color Palette
/// Extracted from logo: Vibrant Green (leaves), Golden Yellow (fruit), Light Blue (accent)
class AppColors {
  AppColors._();

  // Primary Colors - Based on logo green (pineapple leaves)
  static const Color primaryGreen = Color(0xFF2E7D32); // Main green from logo
  static const Color primaryGreenLight = Color(0xFF4CAF50); // Lighter green variant
  static const Color primaryGreenDark = Color(0xFF1B5E20); // Darker green for text/shadow
  
  // Secondary Colors - Based on logo yellow (pineapple fruit)
  static const Color accentYellow = Color(0xFFFFC107); // Bright golden yellow from logo
  static const Color accentYellowLight = Color(0xFFFFE082); // Light yellow variant
  static const Color accentYellowDark = Color(0xFFFFA000); // Darker yellow/amber
  
  // Tertiary Colors - Based on logo light blue accent
  static const Color accentBlue = Color(0xFF64B5F6); // Light blue from logo
  static const Color accentBlueLight = Color(0xFFBBDEFB); // Pale blue variant
  static const Color accentBlueDark = Color(0xFF1976D2); // Deeper blue
  
  // Neutral Colors - Light Mode
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF616161);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color cardBorder = Color(0xFFEEEEEE);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textDarkLight = Color(0xFFE0E0E0);
  static const Color textDarkMedium = Color(0xFFB0B0B0);
  static const Color textDarkLightMode = Color(0xFF757575);
  static const Color dividerDark = Color(0xFF3C3C3C); // More visible in dark mode
  static const Color cardBorderDark = Color(0xFF3C3C3C); // More visible in dark mode

  // Theme-aware color getters
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundWhite;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardDark
        : cardWhite;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textDarkLight
        : textDark;
  }

  static Color getTextMediumColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textDarkMedium
        : textMedium;
  }

  static Color getTextLightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textDarkLightMode
        : textLight;
  }

  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dividerDark
        : divider;
  }

  static Color getCardBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardBorderDark
        : cardBorder;
  }

  // Shadow colors - theme-aware
  static Color getShadowColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.1);
  }

  static Color getLightShadowColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.05);
  }
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreenLight, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sweetnessGradient = LinearGradient(
    colors: [
      Color(0xFFFFE0B2), // Light orange
      Color(0xFFFFB74D), // Orange
      Color(0xFFFF8A65), // Deep orange
      Color(0xFFE57373), // Red
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient headerGradient = LinearGradient(
    colors: [accentYellowLight, primaryGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
