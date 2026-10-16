import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData tema = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.fundo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.principal,
      primary: AppColors.principal,
      secondary: AppColors.secundaria,
      error: AppColors.erro,
      surface: AppColors.branco,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.principal,
      foregroundColor: AppColors.branco,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.principal,
      foregroundColor: AppColors.branco,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.texto),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.principal),
      ),
    ),
  );
}
