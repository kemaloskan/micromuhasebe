import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryLight = Color(0xFF8789FF);
  static const Color primaryMain = Color(0xFF696CFF);
  static const Color primaryDark = Color(0xFF5E61E6);
  
  // Secondary Colors
  static const Color secondaryLight = Color(0xFF9DA8B5);
  static const Color secondaryMain = Color(0xFF8592A3);
  static const Color secondaryDark = Color(0xFF788393);
  
  // Error Colors
  static const Color errorLight = Color(0xFFFF654A);
  static const Color errorMain = Color(0xFFFF3E1D);
  static const Color errorDark = Color(0xFFE6381A);
  
  // Warning Colors
  static const Color warningLight = Color(0xFFFFBC33);
  static const Color warningMain = Color(0xFFFFAB00);
  static const Color warningDark = Color(0xFFE69A00);
  
  // Info Colors
  static const Color infoLight = Color(0xFF35CFF0);
  static const Color infoMain = Color(0xFF03C3EC);
  static const Color infoDark = Color(0xFF03AFD4);
  
  // Success Colors
  static const Color successLight = Color(0xFF8DE45F);
  static const Color successMain = Color(0xFF71DD37);
  static const Color successDark = Color(0xFF66C732);
  
  // Primary Opacity Colors
  static const Color primaryLighterOpacity = Color.fromRGBO(105, 108, 255, 0.08);
  static const Color primaryLightOpacity = Color.fromRGBO(105, 108, 255, 0.16);
  static const Color primaryMainOpacity = Color.fromRGBO(105, 108, 255, 0.24);
  static const Color primaryDarkOpacity = Color.fromRGBO(105, 108, 255, 0.32);
  static const Color primaryDarkerOpacity = Color.fromRGBO(105, 108, 255, 0.38);
  
  // Neutral Colors
  static const Color textPrimary = Color(0xFF384551);
  static const Color textSecondary = Color(0xFF6F7B88);
  static const Color textTertiary = Color(0xFF9AA0A6);
  
  // Background Colors
  static const Color backgroundPrimary = Color(0xFFF8F9FF);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color backgroundTertiary = Color(0xFFF1F3F4);
  
  // Border Colors
  static const Color borderPrimary = Color(0xFFDADCE0);
  static const Color borderSecondary = Color(0xFFE8EAED);
  
  // Surface Colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8F9FF);
  
  // Active/Selected States
  static const Color activeBackground = Color(0xFFE7E7FF);
  static const Color selectedBorder = primaryMain;
}

class AppColorScheme {
  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: AppColors.primaryMain,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondaryMain,
    secondaryContainer: AppColors.secondaryLight,
    surface: AppColors.surfacePrimary,
    surfaceContainerHighest: AppColors.surfaceSecondary,
    error: AppColors.errorMain,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
    outline: AppColors.borderPrimary,
  );
} 