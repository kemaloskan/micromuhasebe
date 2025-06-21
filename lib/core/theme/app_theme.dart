import 'package:flutter/material.dart';

class AppTheme {
  // Sneat Color Palette - Primary
  static const Color primaryLight = Color(0xFF8789FF);
  static const Color primaryMain = Color(0xFF696CFF);
  static const Color primaryDark = Color(0xFF5E61E6);
  
  // Sneat Color Palette - Secondary
  static const Color secondaryLight = Color(0xFF9DA8B5);
  static const Color secondaryMain = Color(0xFF8592A3);
  static const Color secondaryDark = Color(0xFF788393);
  
  // Sneat Color Palette - Error
  static const Color errorLight = Color(0xFFFF654A);
  static const Color errorMain = Color(0xFFFF3E1D);
  static const Color errorDark = Color(0xFFE6381A);
  
  // Sneat Color Palette - Warning
  static const Color warningLight = Color(0xFFFFBC33);
  static const Color warningMain = Color(0xFFFFAB00);
  static const Color warningDark = Color(0xFFE69A00);
  
  // Sneat Color Palette - Info
  static const Color infoLight = Color(0xFF35CFF0);
  static const Color infoMain = Color(0xFF03C3EC);
  static const Color infoDark = Color(0xFF03AFD4);
  
  // Sneat Color Palette - Success
  static const Color successLight = Color(0xFF8DE45F);
  static const Color successMain = Color(0xFF71DD37);
  static const Color successDark = Color(0xFF66C732);
  
  // Light theme colors
  static const Color backgroundColor = Color(0xFFF5F5F9);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF566A7F);
  static const Color textSecondaryColor = Color(0xFFA5A3AE);
  
  // Dark theme colors
  static const Color backgroundColorDark = Color(0xFF282A42);
  static const Color surfaceColorDark = Color(0xFF32344F);
  static const Color cardColorDark = Color(0xFF32344F);
  static const Color textPrimaryColorDark = Color(0xFFDEDED7);
  static const Color textSecondaryColorDark = Color(0xFFBABBCA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMain,
        brightness: Brightness.light,
        primary: primaryMain,
        onPrimary: Colors.white,
        primaryContainer: primaryLight,
        onPrimaryContainer: primaryDark,
        secondary: secondaryMain,
        onSecondary: Colors.white,
        secondaryContainer: secondaryLight,
        onSecondaryContainer: secondaryDark,
        error: errorMain,
        onError: Colors.white,
        errorContainer: errorLight,
        onErrorContainer: errorDark,
        surface: surfaceColor,
        onSurface: textPrimaryColor,
        surfaceContainerHighest: cardColor,
        background: backgroundColor,
        onBackground: textPrimaryColor,
        outline: textSecondaryColor,
        outlineVariant: textSecondaryColor.withOpacity(0.5),
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimaryColor),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: textSecondaryColor.withOpacity(0.2)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMain,
          foregroundColor: Colors.white,
          surfaceTintColor: primaryMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryMain),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorMain),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textSecondaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMain,
        brightness: Brightness.dark,
        primary: primaryMain,
        onPrimary: Colors.white,
        primaryContainer: primaryDark,
        onPrimaryContainer: primaryLight,
        secondary: secondaryMain,
        onSecondary: Colors.white,
        secondaryContainer: secondaryDark,
        onSecondaryContainer: secondaryLight,
        error: errorMain,
        onError: Colors.white,
        errorContainer: errorDark,
        onErrorContainer: errorLight,
        surface: surfaceColorDark,
        onSurface: textPrimaryColorDark,
        surfaceContainerHighest: cardColorDark,
        background: backgroundColorDark,
        onBackground: textPrimaryColorDark,
        outline: textSecondaryColorDark,
        outlineVariant: textSecondaryColorDark.withOpacity(0.5),
      ),
      scaffoldBackgroundColor: backgroundColorDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColorDark,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimaryColorDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimaryColorDark),
      ),
      cardTheme: CardTheme(
        color: cardColorDark,
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: textSecondaryColorDark.withOpacity(0.2)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMain,
          foregroundColor: Colors.white,
          surfaceTintColor: primaryMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: textSecondaryColorDark.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: textSecondaryColorDark.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryMain),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorMain),
        ),
        filled: true,
        fillColor: surfaceColorDark,
        contentPadding: const EdgeInsets.all(16),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimaryColorDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColorDark,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimaryColorDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimaryColorDark,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textPrimaryColorDark,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textSecondaryColorDark,
          fontSize: 12,
        ),
      ),
    );
  }
} 