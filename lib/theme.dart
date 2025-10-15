import 'package:flutter/material.dart';

class MindfulnessTheme {
  static const Color softTeal = Color.fromRGBO(164, 217, 205, 1.0);
  static const Color lavenderMist = Color.fromRGBO(228, 221, 255, 1.0);
  static const Color offWhite = Color.fromRGBO(250, 249, 246, 1.0);
  static const Color skyBlue = Color.fromRGBO(178, 204, 255, 1.0);
  static const Color mutedCoral = Color.fromRGBO(255, 182, 171, 1.0);
  static const Color paleYellow = Color.fromRGBO(255, 243, 176, 1.0);
  static const Color softGray = Color.fromRGBO(136, 136, 136, 1.0);
  static const Color deepSlate = Color.fromRGBO(60, 63, 65, 1.0);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: softTeal,
      scaffoldBackgroundColor: offWhite,
      canvasColor: offWhite,
      splashColor: skyBlue.withValues(alpha: 0.2),
      highlightColor: mutedCoral.withValues(alpha: 0.3),
      dividerColor: softGray.withValues(alpha: 0.3),

      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: mutedCoral,
        onPrimary: lavenderMist,
        secondary: skyBlue,
        onSecondary: deepSlate,
        surface: offWhite,
        onSurface: deepSlate,
        error: mutedCoral,
        onError: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: lavenderMist,
        foregroundColor: deepSlate,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Arial',
          fontSize: 22,
          color: mutedCoral,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: deepSlate,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: deepSlate,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: deepSlate,
        ),
        bodyLarge: TextStyle(fontSize: 20, color: deepSlate),
        bodyMedium: TextStyle(fontSize: 16, color: deepSlate),
        bodySmall: TextStyle(fontSize: 14, color: softGray),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: offWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: softTeal, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: skyBlue, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lavenderMist,
          foregroundColor: deepSlate,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lavenderMist,
        selectedItemColor: mutedCoral,
        unselectedItemColor: softGray,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
