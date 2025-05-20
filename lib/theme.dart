import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  fontFamily: 'Poppins',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.5,
    iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
    titleTextStyle: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF6C5CE7),       // Muted Indigo
    secondary: Color(0xFF6C5CE7),     // Same for simplicity
    background: Color(0xFFFAFAFA),    // Light background
    onPrimary: Colors.white,          // Text/icon color on indigo
    onSecondary: Colors.white,
    onBackground: Color(0xFF1C1C1E),  // Text on background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1C1C1E)),
    bodyMedium: TextStyle(color: Color(0xFF1C1C1E)),
    bodySmall: TextStyle(color: Color(0xFF8E8E93)),
    labelLarge: TextStyle(color: Color(0xFF5E5E5E)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6C5CE7),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    shadowColor: Colors.black.withOpacity(0.05),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF5E5E5E)),
  dividerColor: Color(0xFFE0E0E0),
  useMaterial3: true,
);