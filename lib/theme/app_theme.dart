// TEMA GLOBAL DE UDITFLIX
// Estilo inspirado en las plataformas de streaming: fondo casi negro,
// superficies gris oscuro, tipografía blanca y acento rojo.

import 'package:flutter/material.dart';

abstract final class AppColors {
    static const background = Color(0xFF0A0A0A);
    static const surface = Color(0xFF181818);
    static const surfaceLight = Color(0xFF232323);
    static const outline = Color(0xFF333333);
    static const primary = Color(0xFFE50914);
    static const secondary = Color(0xFFF5B544);
    static const amber = Color(0xFFF5B544);
    static const text = Color(0xFFFFFFFF);
    static const muted = Color(0xFFB3B3B3);
}

abstract final class AppTheme {
    static ThemeData get theme {
        final colorScheme = ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            secondary: AppColors.secondary,
            onSecondary: AppColors.background,
            surface: AppColors.surface,
            onSurface: AppColors.text,
            error: const Color(0xFFFF5252),
            onError: Colors.white,
        );

        return ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: AppColors.background,
            canvasColor: AppColors.background,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                foregroundColor: AppColors.text,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: false,
                titleSpacing: 20,
                titleTextStyle: TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                ),
            ),
            cardTheme: CardThemeData(
                color: AppColors.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                ),
            ),
            filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                    ),
                ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.text,
                    backgroundColor: const Color(0x66FFFFFF),
                    side: BorderSide.none,
                    minimumSize: const Size.fromHeight(44),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
            ),
            iconTheme: const IconThemeData(color: AppColors.text),
            chipTheme: ChipThemeData(
                backgroundColor: AppColors.surfaceLight,
                selectedColor: AppColors.primary,
                side: BorderSide.none,
                labelStyle: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                ),
                secondaryLabelStyle: const TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
            dividerTheme: const DividerThemeData(
                color: AppColors.outline,
                space: 1,
            ),
            textTheme: const TextTheme(
                displaySmall: TextStyle(
                    color: AppColors.text,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.4,
                ),
                headlineMedium: TextStyle(
                    color: AppColors.text,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                ),
                headlineSmall: TextStyle(
                    color: AppColors.text,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                ),
                titleMedium: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                ),
                bodyMedium: TextStyle(color: AppColors.text, fontSize: 14),
                bodySmall: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
        );
    }
}
