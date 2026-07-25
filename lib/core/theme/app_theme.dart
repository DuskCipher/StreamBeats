import 'package:flutter/material.dart';

/// Canonical app theme.
///
/// Use [AppTheme] in new code. The [Default_Theme] typedef at the bottom of
/// this file provides backward-compatible access for existing callers while
/// imports are being migrated.
class AppTheme {
  // ── Text Styles ─────────────────────────────────────────────────────────────
  static const primaryTextStyle = TextStyle(fontFamily: "Arial");
  static const secondoryTextStyle = TextStyle(fontFamily: "Arial");
  static const secondoryTextStyleMedium =
      TextStyle(fontFamily: "Arial", fontWeight: FontWeight.w700);
  static const tertiaryTextStyle = TextStyle(fontFamily: "Arial");
  static const fontAwesomeRegularFont =
      TextStyle(fontFamily: "FontAwesome-Regular");
  static const fontAwesomeSolidFont =
      TextStyle(fontFamily: "FontAwesome-Solids");

  // ── Colors ──────────────────────────────────────────────────────────────────
  static const themeColor = Color(0xFF000000);         // Hitam murni
  static const primaryColor1 = Color(0xFFFFFFFF);      // Putih
  static const primaryColor2 = Color(0xFF1A1A1A);      // Abu-abu sangat gelap
  static const accentColor1 = Color(0xFFAAAAAA);       // Abu-abu terang
  static const accentColor1light = Color(0xFFCCCCCC);  // Abu-abu muda
  static const accentColor2 = Color(0xFFFFFFFF);       // Putih (pengganti pink)
  static const successColor = Color(0xFF5EFF43);

  // ── Theme Data ───────────────────────────────────────────────────────────────
  ThemeData get defaultThemeData {
    const darkScheme = ColorScheme.dark(
      primary: accentColor2,
      secondary: accentColor1,
      surface: themeColor,
      surfaceContainerHighest: Color(0xFF1A1A1A),
      onPrimary: themeColor,
      onSecondary: themeColor,
      onSurface: primaryColor1,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: themeColor,
      dialogBackgroundColor: Color(0xFF111111),
      primaryColorDark: accentColor2,
      fontFamily: 'Arial',
      primarySwatch: MaterialColor(
        accentColor2.value,
        {
          50: accentColor2.withValues(alpha: 0.1),
          100: accentColor2.withValues(alpha: 0.2),
          200: accentColor2.withValues(alpha: 0.3),
          300: accentColor2.withValues(alpha: 0.4),
          400: accentColor2.withValues(alpha: 0.5),
          500: accentColor2.withValues(alpha: 0.6),
          600: accentColor2.withValues(alpha: 0.7),
          700: accentColor2.withValues(alpha: 0.8),
          800: accentColor2.withValues(alpha: 0.9),
          900: accentColor2,
        },
      ),
      colorScheme: darkScheme.copyWith(
        primary: accentColor2,
        secondary: accentColor1,
      ),
      iconTheme: const IconThemeData(color: primaryColor1),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(accentColor1),
        interactive: true,
        radius: const Radius.circular(10),
        thickness: WidgetStateProperty.all(5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: themeColor,
        foregroundColor: primaryColor1,
        surfaceTintColor: themeColor,
        iconTheme: IconThemeData(color: primaryColor1),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: accentColor1),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: accentColor1,
        selectionColor: accentColor1,
        selectionHandleColor: accentColor1,
      ),
      brightness: Brightness.dark,
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(themeColor),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? primaryColor1
                : accentColor1),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? primaryColor1
                : primaryColor2.withValues(alpha: 0.5)),
      ),
      searchBarTheme: const SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF111111)),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFF111111),
        textStyle: TextStyle(color: primaryColor1),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFF111111)),
        ),
        textStyle: TextStyle(color: primaryColor1),
      ),
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFF111111)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF111111),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

/// Backward-compat alias for [AppTheme].
/// Prefer importing from [core/theme/app_theme.dart] and using [AppTheme] directly.
// ignore: camel_case_types
typedef Default_Theme = AppTheme;
