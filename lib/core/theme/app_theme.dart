import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Application theme configuration
class AppTheme {
  // Primary color
  static const Color primaryColor = Color(AppConstants.primaryColorValue);
  static const Color accentColor = Color(AppConstants.accentColorValue);

  // Get light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
    );
  }

  // App colors
  static const Color checkInColor = Colors.blue;
  static const Color checkOutColor = Colors.teal;
  static const Color settingsColor = Colors.green;
  static const Color reportColor = Colors.yellow;
  static const Color aboutColor = Colors.purple;
  static const Color versionColor = Colors.red;

  // Private constructor to prevent instantiation
  AppTheme._();
}
