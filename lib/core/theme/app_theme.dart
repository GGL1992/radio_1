import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

class AppTheme {
  // 复古配色
  static const Color woodBrown = Color(0xFF8B4513);
  static const Color darkWood = Color(0xFF5D4037);
  static const Color brass = Color(0xFFB8860B);
  static const Color copper = Color(0xFFB87333);
  static const Color cream = Color(0xFFFFF8DC);
  static const Color agedPaper = Color(0xFFF5F5DC);
  static const Color dialGreen = Color(0xFF00FF00);
  static const Color indicatorRed = Color(0xFFFF4444);
  static const Color indicatorAmber = Color(0xFFFFBF00);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: woodBrown,
        brightness: Brightness.light,
        surface: cream,
      ),
      scaffoldBackgroundColor: agedPaper,
      appBarTheme: const AppBarTheme(
        backgroundColor: woodBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brass,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: darkWood,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkWood,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkWood,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: woodBrown,
        brightness: Brightness.dark,
        surface: const Color(0xFF1A1A2E),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A2E),
        foregroundColor: cream,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1A1A2E),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: copper,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: brass,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: cream,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: cream,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}
