import 'package:flutter/material.dart';

/// PinyaCure App Color Palette
/// Based on logo colors: Green, Yellow, Light Blue
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF4CAF50);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  
  // Secondary Colors
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentYellowLight = Color(0xFFFFE082);
  static const Color accentYellowDark = Color(0xFFFFA000);
  
  // Tertiary Colors
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color accentBlueLight = Color(0xFFBBDEFB);
  static const Color accentBlueDark = Color(0xFF1976D2);
  
  // Neutral Colors
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF616161);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color cardBorder = Color(0xFFEEEEEE);
  
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
