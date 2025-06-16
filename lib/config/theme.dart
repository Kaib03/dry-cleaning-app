// Purpose: Centralized theme data for the app: colors, fonts, text styles, and button themes to match the designs.
import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF2F80ED); // The main blue from the buttons
  static final Color lightGreyColor = Color(0xFFF2F2F2); // Light background grey
  static final Color mediumGreyColor = Color(0xFFBDBDBD); // Border and placeholder text color
  static final Color darkGreyColor = Color(0xFF4F4F4F); // Main text color

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: darkGreyColor),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(color: darkGreyColor, fontWeight: FontWeight.bold, fontSize: 24),
      bodyLarge: TextStyle(color: darkGreyColor, fontSize: 16),
      bodyMedium: TextStyle(color: mediumGreyColor, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
} 