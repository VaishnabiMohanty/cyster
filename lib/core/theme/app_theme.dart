import 'package:flutter/material.dart';

/// Centralized color + theme definitions for Cyster.
///
/// Light theme: soft pink & white — warm, airy, approachable.
/// Dark theme: deep charcoal/black base with a vivid dark-pink/magenta hue —
/// keeps the "cyster" identity recognizable even at night without being
/// harsh on the eyes.
class AppColors {
  AppColors._();

  // ---- Light theme palette ----
  static const Color lightPrimary = Color(0xFFE0578F); // rose pink
  static const Color lightPrimaryDeep = Color(0xFFC73E72); // deeper rose
  static const Color lightSecondary = Color(0xFFF7A6C4); // soft blush pink
  static const Color lightTertiary = Color(0xFFFFD6E8); // pale pink
  static const Color lightBackground = Color(0xFFFFFBFD); // near-white, pink tint
  static const Color lightSurface = Color(0xFFFFFFFF); // pure white
  static const Color lightSurfaceVariant = Color(0xFFFDEFF4); // whisper pink
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF3A2630); // warm near-black
  static const Color lightOutline = Color(0xFFF0C9DA);

  // ---- Dark theme palette ----
  static const Color darkBackground = Color(0xFF120A10); // near-black with a pink whisper
  static const Color darkSurface = Color(0xFF1D1117); // charcoal-plum
  static const Color darkSurfaceVariant = Color(0xFF2A1620); // raised surface
  static const Color darkPrimary = Color(0xFFFF4F9A); // vivid hot/dark pink hue
  static const Color darkPrimaryDeep = Color(0xFFD6306F);
  static const Color darkSecondary = Color(0xFFE85C9B);
  static const Color darkTertiary = Color(0xFF8A3A5C); // muted plum-pink for accents
  static const Color darkOnPrimary = Color(0xFF1A0510);
  static const Color darkOnBackground = Color(0xFFF6E3EC);
  static const Color darkOutline = Color(0xFF4A2C39);

  // ---- Cycle-phase colors (used across light & dark, kept identical for
  // recognizability — just rendered on different backgrounds) ----
  static const Color phaseMenstrual = Color(0xFFE0578F);
  static const Color phaseFollicular = Color(0xFFFFB562);
  static const Color phaseOvulation = Color(0xFF6FCF97);
  static const Color phaseLuteal = Color(0xFF9B8AE6);

  // ---- Semantic accents ----
  static const Color success = Color(0xFF4CAF7D);
  static const Color warning = Color(0xFFE0A53C);
  static const Color danger = Color(0xFFD64550);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      tertiary: AppColors.lightTertiary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnBackground,
      surfaceTint: AppColors.lightPrimary,
      outline: AppColors.lightOutline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightOnBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.lightOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: AppColors.lightOutline.withOpacity(0.6)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: Color(0xFFBFA1AD),
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.lightTertiary,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.lightPrimaryDeep : const Color(0xFF9A7E89),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.lightPrimaryDeep : const Color(0xFF9A7E89),
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimaryDeep,
          side: const BorderSide(color: AppColors.lightPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.lightPrimary,
        labelStyle: const TextStyle(color: AppColors.lightOnBackground),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        side: BorderSide(color: AppColors.lightOutline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.lightOutline.withOpacity(0.6)),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.lightPrimary,
        thumbColor: AppColors.lightPrimaryDeep,
        inactiveTrackColor: AppColors.lightTertiary,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.lightPrimaryDeep,
        unselectedLabelColor: Color(0xFF9A7E89),
        indicatorColor: AppColors.lightPrimary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.lightPrimary : null),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.lightTertiary : null),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      tertiary: AppColors.darkTertiary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnBackground,
      outline: AppColors.darkOutline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkOnBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.darkOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: AppColors.darkOutline),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkOnBackground.withOpacity(0.45),
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.darkTertiary,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.darkPrimary : AppColors.darkOnBackground.withOpacity(0.5),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.darkPrimary : AppColors.darkOnBackground.withOpacity(0.5),
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.darkPrimary,
        labelStyle: TextStyle(color: AppColors.darkOnBackground),
        secondaryLabelStyle: const TextStyle(color: AppColors.darkOnPrimary),
        side: BorderSide(color: AppColors.darkOutline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.darkOutline),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.darkPrimary,
        thumbColor: AppColors.darkPrimary,
        inactiveTrackColor: AppColors.darkTertiary,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.darkPrimary,
        unselectedLabelColor: AppColors.darkOnBackground.withOpacity(0.5),
        indicatorColor: AppColors.darkPrimary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.darkPrimary : null),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.darkTertiary : null),
      ),
    );
  }
}
