import 'package:flutter/material.dart';

class AppColors {
  // Light Mode - Calm & easy on eyes (Sage/Teal/Natural)
  static const Color primaryLight = Color(0xFF6B9080); // Calm Sage
  static const Color secondaryLight = Color(0xFFA4C3B2); // Soft Green
  static const Color surfaceLight = Color(0xFFF6FFF8); // Mint White
  static const Color seedColor = Color(0xFF354F52); // Dark Slate

  // Dark Mode
  static const Color primaryDark = Color(0xFFA7C4BC); // Light Sage
  static const Color secondaryDark = Color(0xFFCCE3DE); // Mist

  // Neutral
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static final Color primary = HexColor('#1E1E1E');
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
