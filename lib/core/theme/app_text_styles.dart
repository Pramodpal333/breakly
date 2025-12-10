import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'Roboto';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
    fontSize: 57, // Material 3 default for Display Large
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
    fontSize: 45, // Material 3 default for Display Large
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
    fontSize: 35, // Material 3 default for Display Large
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 28, // Material 3 default
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
  );
}

extension TextStyleExtensions on TextStyle {
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);
}
