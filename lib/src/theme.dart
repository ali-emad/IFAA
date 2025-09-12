import 'package:flutter/material.dart';

// Modern Soccer/Sports Theme Colors - Inspired by professional soccer websites
class SoccerThemeColors {
  // Primary brand colors
  static const Color primaryBlue = Color(0xFF1E3A8A);      // Deep blue
  static const Color primaryGreen = Color(0xFF059669);     // Vibrant green (field)
  static const Color accentOrange = Color(0xFFEA580C);     // Energy orange
  static const Color accentRed = Color(0xFFDC2626);       // Alert red
  
  // Neutral colors
  static const Color darkCharcoal = Color(0xFF1F2937);    // Dark backgrounds
  static const Color lightGray = Color(0xFFF9FAFB);       // Light backgrounds
  static const Color mediumGray = Color(0xFF6B7280);      // Secondary text
  static const Color borderGray = Color(0xFFE5E7EB);      // Borders
  
  // Gradient combinations
  static const List<Color> heroGradient = [
    Color(0xFF1E3A8A), // Primary blue
    Color(0xFF3B82F6), // Lighter blue
  ];
  
  static const List<Color> successGradient = [
    Color(0xFF059669), // Green
    Color(0xFF10B981), // Lighter green
  ];
  
  static const List<Color> energyGradient = [
    Color(0xFFEA580C), // Orange
    Color(0xFFF59E0B), // Yellow-orange
  ];
}

ThemeData buildLightTheme() {
  const primaryColor = SoccerThemeColors.primaryBlue;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    primary: primaryColor,
    secondary: SoccerThemeColors.primaryGreen,
    tertiary: SoccerThemeColors.accentOrange,
    surface: Colors.white,
    background: SoccerThemeColors.lightGray,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: SoccerThemeColors.darkCharcoal,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Roboto', // Modern, sporty font
    
    // Soccer-style AppBar
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: Colors.white,
      foregroundColor: SoccerThemeColors.darkCharcoal,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: -0.5,
      ),
      actionsIconTheme: const IconThemeData(
        color: SoccerThemeColors.mediumGray,
        size: 24,
      ),
    ),
    
    // Modern sports-style cards
    cardTheme: const CardThemeData(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: SoccerThemeColors.borderGray, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    // Dynamic button themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(140, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: SoccerThemeColors.primaryBlue, width: 2),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Sports-style navigation
    navigationBarTheme: NavigationBarThemeData(
      elevation: 8,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.1),
      indicatorColor: SoccerThemeColors.primaryBlue.withOpacity(0.1),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: SoccerThemeColors.primaryBlue,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: SoccerThemeColors.mediumGray,
        );
      }),
    ),
    
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.white,
      elevation: 2,
      indicatorColor: SoccerThemeColors.primaryBlue.withOpacity(0.1),
      selectedIconTheme: const IconThemeData(
        color: SoccerThemeColors.primaryBlue,
        size: 24,
      ),
      unselectedIconTheme: const IconThemeData(
        color: SoccerThemeColors.mediumGray,
        size: 24,
      ),
      selectedLabelTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: SoccerThemeColors.primaryBlue,
      ),
      unselectedLabelTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: SoccerThemeColors.mediumGray,
      ),
    ),
    
    // Modern sports typography
    textTheme: const TextTheme(
      // Headlines - Bold and impactful like sports headers
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: -1.5,
        height: 1.1,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: -1,
        height: 1.2,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: -0.5,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: -0.25,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: 0,
        height: 1.35,
      ),
      
      // Titles - Strong but readable
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: 0.1,
        height: 1.45,
      ),
      
      // Body text - Clean and readable
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: 0.15,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: SoccerThemeColors.mediumGray,
        letterSpacing: 0.25,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: SoccerThemeColors.mediumGray,
        letterSpacing: 0.4,
        height: 1.4,
      ),
      
      // Labels - Strong and clear
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: SoccerThemeColors.darkCharcoal,
        letterSpacing: 0.75,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: SoccerThemeColors.mediumGray,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: SoccerThemeColors.mediumGray,
        letterSpacing: 0.5,
      ),
    ),
    
    // Modern form styling
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: SoccerThemeColors.lightGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: SoccerThemeColors.borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: SoccerThemeColors.borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: SoccerThemeColors.primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: SoccerThemeColors.accentRed),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Clean list tiles
    listTileTheme: const ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    
    // Modern dividers
    dividerTheme: const DividerThemeData(
      color: SoccerThemeColors.borderGray,
      thickness: 1,
      space: 1,
    ),
  );
}

ThemeData buildDarkTheme() {
  const primaryColor = SoccerThemeColors.primaryGreen;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    primary: primaryColor,
    secondary: SoccerThemeColors.accentOrange,
    surface: const Color(0xFF111827),
    background: const Color(0xFF0F172A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Roboto',
    
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
    ),
  );
}