import 'package:flutter/material.dart';

class AppTheme {
  static const Color scaffoldBackground = Color(0xFFF4F7F6);

  // Mapper Warna dari Tailwind Laravel ke Flutter MaterialColor
  static MaterialColor getColorPalette(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'rose':
      case 'red':
        return Colors.pink; // Paling mendekati rose
      case 'blue':
        return Colors.blue;
      case 'amber':
      case 'yellow':
        return Colors.amber;
      case 'purple':
        return Colors.purple;
      case 'emerald':
      case 'green':
      default:
        return Colors.teal; // Paling mendekati emerald
    }
  }

  static ThemeData getTheme({MaterialColor primarySwatch = Colors.teal}) {
    return ThemeData(
      primarySwatch: primarySwatch,
      primaryColor: primarySwatch.shade600,
      scaffoldBackgroundColor: scaffoldBackground,
      fontFamily: 'ElMessiri', // Pastikan font sudah didaftarkan di pubspec
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySwatch.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primarySwatch.shade500, width: 2),
        ),
      ),
    );
  }
}
