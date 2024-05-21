import 'package:blog_app_with_bloc_supabase_hive/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static border({Color color = AppPalette.borderColor}) => OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: color,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppPalette.backgroundColor),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        AppPalette.backgroundColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(color: AppPalette.gradient2),
      errorBorder: border(color: AppPalette.errorColor),
    ),
  );
}
