import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Main theme configuration for Rapid Pass BD.
/// Provides light and dark ThemeData with premium iOS-inspired styling.
abstract final class AppTheme {
  // ── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        textTheme: _textTheme(AppColors.onBackgroundLight),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        cardTheme: _cardThemeLight,
        appBarTheme: _appBarThemeLight,
        navigationBarTheme: _navigationBarThemeLight,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationThemeLight,
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerLight,
          thickness: 1,
          space: 1,
        ),
        chipTheme: _chipThemeLight,
        iconTheme: const IconThemeData(
          color: AppColors.onSurfaceLight,
          size: AppSpacing.iconLg,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLg),
            ),
          ),
        ),
        extensions: const [AppThemeExtension.light],
      );

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _darkColorScheme,
        textTheme: _textTheme(AppColors.onBackgroundDark),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardTheme: _cardThemeDark,
        appBarTheme: _appBarThemeDark,
        navigationBarTheme: _navigationBarThemeDark,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationThemeDark,
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerDark,
          thickness: 1,
          space: 1,
        ),
        chipTheme: _chipThemeDark,
        iconTheme: const IconThemeData(
          color: AppColors.onSurfaceDark,
          size: AppSpacing.iconLg,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLg),
            ),
          ),
        ),
        extensions: const [AppThemeExtension.dark],
      );

  // ── Color Schemes ─────────────────────────────────────────────────────────
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
    surfaceContainerHighest: AppColors.surfaceVariantLight,
    onSurfaceVariant: AppColors.onSurfaceVariantLight,
    outline: AppColors.borderLight,
    outlineVariant: AppColors.dividerLight,
    shadow: Color(0x1A000000),
    scrim: Color(0x80000000),
    inverseSurface: AppColors.surfaceDark,
    onInverseSurface: AppColors.onSurfaceDark,
    inversePrimary: AppColors.primaryLight,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryLight,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryContainer,
    secondary: AppColors.secondaryLight,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.secondaryContainer,
    error: AppColors.secondaryLight,
    onError: Colors.white,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    surfaceContainerHighest: AppColors.surfaceVariantDark,
    onSurfaceVariant: AppColors.onSurfaceVariantDark,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.dividerDark,
    shadow: Color(0x40000000),
    scrim: Color(0x80000000),
    inverseSurface: AppColors.surfaceLight,
    onInverseSurface: AppColors.onSurfaceLight,
    inversePrimary: AppColors.primary,
  );

  // ── Text Theme ────────────────────────────────────────────────────────────
  static TextTheme _textTheme(Color defaultColor) => TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: defaultColor),
        displayMedium: AppTypography.displayMedium.copyWith(color: defaultColor),
        displaySmall: AppTypography.displaySmall.copyWith(color: defaultColor),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: defaultColor),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: defaultColor),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: defaultColor),
        titleLarge: AppTypography.titleLarge.copyWith(color: defaultColor),
        titleMedium: AppTypography.titleMedium.copyWith(color: defaultColor),
        titleSmall: AppTypography.titleSmall.copyWith(color: defaultColor),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: defaultColor),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: defaultColor),
        bodySmall: AppTypography.bodySmall.copyWith(color: defaultColor),
        labelLarge: AppTypography.labelLarge.copyWith(color: defaultColor),
        labelMedium: AppTypography.labelMedium.copyWith(color: defaultColor),
        labelSmall: AppTypography.labelSmall.copyWith(color: defaultColor),
      );

  // ── AppBar Themes ─────────────────────────────────────────────────────────
  static final AppBarTheme _appBarThemeLight = AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: AppColors.onBackgroundLight,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    shadowColor: const Color(0x1A000000),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    titleTextStyle: AppTypography.titleLarge.copyWith(
      color: AppColors.onBackgroundLight,
    ),
    centerTitle: true,
  );

  static final AppBarTheme _appBarThemeDark = AppBarTheme(
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.onBackgroundDark,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    shadowColor: const Color(0x40000000),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: AppTypography.titleLarge.copyWith(
      color: AppColors.onBackgroundDark,
    ),
    centerTitle: true,
  );

  // ── Card Themes ───────────────────────────────────────────────────────────
  static final CardThemeData _cardThemeLight = CardThemeData(
    color: AppColors.cardLight,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      side: const BorderSide(color: AppColors.borderLight, width: 1),
    ),
    margin: EdgeInsets.zero,
  );

  static final CardThemeData _cardThemeDark = CardThemeData(
    color: AppColors.cardDark,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      side: const BorderSide(color: AppColors.borderDark, width: 1),
    ),
    margin: EdgeInsets.zero,
  );

  // ── Navigation Bar Themes ─────────────────────────────────────────────────
  static final NavigationBarThemeData _navigationBarThemeLight =
      NavigationBarThemeData(
    backgroundColor: AppColors.surfaceLight.withOpacity(0.95),
    indicatorColor: AppColors.primaryContainer,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTypography.labelSmall.copyWith(color: AppColors.primary);
      }
      return AppTypography.labelSmall
          .copyWith(color: AppColors.onSurfaceVariantLight);
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: AppColors.primary, size: 22);
      }
      return const IconThemeData(
          color: AppColors.onSurfaceVariantLight, size: 22);
    }),
    elevation: 0,
    height: 65,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  );

  static final NavigationBarThemeData _navigationBarThemeDark =
      NavigationBarThemeData(
    backgroundColor: AppColors.surfaceDark.withOpacity(0.95),
    indicatorColor: AppColors.primaryDark.withOpacity(0.4),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTypography.labelSmall.copyWith(color: AppColors.primaryLight);
      }
      return AppTypography.labelSmall
          .copyWith(color: AppColors.onSurfaceVariantDark);
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: AppColors.primaryLight, size: 22);
      }
      return const IconThemeData(
          color: AppColors.onSurfaceVariantDark, size: 22);
    }),
    elevation: 0,
    height: 65,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  );

  // ── Button Themes ─────────────────────────────────────────────────────────
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      textStyle: AppTypography.labelLarge.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.lg,
      ),
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      textStyle: AppTypography.labelLarge.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.lg,
      ),
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    ),
  );

  // ── Input Decoration ──────────────────────────────────────────────────────
  static final InputDecorationTheme _inputDecorationThemeLight =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariantLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    hintStyle:
        AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariantLight),
  );

  static final InputDecorationTheme _inputDecorationThemeDark =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariantDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    hintStyle:
        AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariantDark),
  );

  // ── Chip Themes ───────────────────────────────────────────────────────────
  static final ChipThemeData _chipThemeLight = ChipThemeData(
    backgroundColor: AppColors.surfaceVariantLight,
    selectedColor: AppColors.primaryContainer,
    labelStyle: AppTypography.labelMedium.copyWith(
      color: AppColors.onSurfaceLight,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.borderLight),
    ),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
  );

  static final ChipThemeData _chipThemeDark = ChipThemeData(
    backgroundColor: AppColors.surfaceVariantDark,
    selectedColor: AppColors.primaryDark,
    labelStyle: AppTypography.labelMedium.copyWith(
      color: AppColors.onSurfaceDark,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.borderDark),
    ),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
  );
}

// ── Theme Extension ───────────────────────────────────────────────────────────
/// Custom theme extension for app-specific semantic values.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardGradient,
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.subtleBackground,
    required this.balanceTextColor,
    required this.isDark,
  });

  final LinearGradient cardGradient;
  final Color successColor;
  final Color warningColor;
  final Color infoColor;
  final Color subtleBackground;
  final Color balanceTextColor;
  final bool isDark;

  static const light = AppThemeExtension(
    cardGradient: AppColors.cardGradient,
    successColor: AppColors.success,
    warningColor: AppColors.warning,
    infoColor: AppColors.info,
    subtleBackground: AppColors.surfaceVariantLight,
    balanceTextColor: Colors.white,
    isDark: false,
  );

  static const dark = AppThemeExtension(
    cardGradient: AppColors.darkCardGradient,
    successColor: AppColors.success,
    warningColor: AppColors.warning,
    infoColor: AppColors.info,
    subtleBackground: AppColors.surfaceVariantDark,
    balanceTextColor: Colors.white,
    isDark: true,
  );

  @override
  AppThemeExtension copyWith({
    LinearGradient? cardGradient,
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
    Color? subtleBackground,
    Color? balanceTextColor,
    bool? isDark,
  }) {
    return AppThemeExtension(
      cardGradient: cardGradient ?? this.cardGradient,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      subtleBackground: subtleBackground ?? this.subtleBackground,
      balanceTextColor: balanceTextColor ?? this.balanceTextColor,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
      subtleBackground: Color.lerp(subtleBackground, other.subtleBackground, t)!,
      balanceTextColor:
          Color.lerp(balanceTextColor, other.balanceTextColor, t)!,
      isDark: t > 0.5 ? other.isDark : isDark,
    );
  }
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
