// Purpose: Centralized theme data for the app: colors, fonts, text styles, and button themes to match the designs.
import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF2F80ED);
  static final Color lightBackgroundColor = Color(0xFFF9F9F9);
  static final Color cardBackgroundColor = Colors.white;
  static final Color primaryTextColor = Color(0xFF333333);
  static final Color secondaryTextColor = Color(0xFF828282);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: lightBackgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    fontFamily: 'Inter', // A good modern, clean font
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryTextColor),
      titleTextStyle: TextStyle(
        color: primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
          color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 24),
      titleLarge: TextStyle(
          color: primaryTextColor, fontWeight: FontWeight.w600, fontSize: 18),
      titleMedium: TextStyle(
          color: primaryTextColor, fontWeight: FontWeight.w500, fontSize: 16),
      bodyLarge: TextStyle(color: primaryTextColor, fontSize: 16),
      bodyMedium: TextStyle(color: secondaryTextColor, fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      labelStyle: TextStyle(color: secondaryTextColor),
      hintStyle: TextStyle(color: secondaryTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );
}
