import 'package:flutter/material.dart';

/// App color palette inspired by Bangladesh's flag colors.
/// Used subtly and elegantly — not flag-like.
abstract final class AppColors {
  // ── Brand ───────────────────────────────────────────────────────────────
  /// Bangladesh Green — primary brand color
  static const Color primary = Color(0xFF006A4E);
  static const Color primaryLight = Color(0xFF1A8A68);
  static const Color primaryDark = Color(0xFF004D38);
  static const Color primaryContainer = Color(0xFFD0F0E4);
  static const Color onPrimaryContainer = Color(0xFF002117);

  /// Bangladesh Red — secondary accent
  static const Color secondary = Color(0xFFCC2936);
  static const Color secondaryLight = Color(0xFFE53E4B);
  static const Color secondaryDark = Color(0xFF9E1E29);
  static const Color secondaryContainer = Color(0xFFFFDADB);
  static const Color onSecondaryContainer = Color(0xFF410009);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2D9D78);
  static const Color successLight = Color(0xFFD6F5EC);
  static const Color warning = Color(0xFFE67E22);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFCC2936);
  static const Color errorLight = Color(0xFFFFDADB);
  static const Color info = Color(0xFF0066CC);
  static const Color infoLight = Color(0xFFE3F0FF);

  // ── Light Mode ───────────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F3F5);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE8EAED);
  static const Color onBackgroundLight = Color(0xFF1A1A2E);
  static const Color onSurfaceLight = Color(0xFF1A1A2E);
  static const Color onSurfaceVariantLight = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE8EAED);

  // ── Dark Mode ─────────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF08090C); // Deep rich obsidian
  static const Color surfaceDark = Color(0xFF101216);    // Slightly elevated surface
  static const Color surfaceVariantDark = Color(0xFF16191E); // Elevated variant
  static const Color cardDark = Color(0xFF16191E);       // Card background
  static const Color dividerDark = Color(0x14FFFFFF);    // 8% white translucent divider
  static const Color onBackgroundDark = Color(0xFFF5F7FA); // Soft off-white for text
  static const Color onSurfaceDark = Color(0xFFF5F7FA);
  static const Color onSurfaceVariantDark = Color(0xFF8E96A4); // Muted silver-gray
  static const Color borderDark = Color(0x1AFFFFFF);     // 10% white translucent border

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF006A4E), Color(0xFF004D38)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A7C5C), Color(0xFF005A42)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2F28), Color(0xFF0D1E18)],
  );

  // ── Metro Line Colors ─────────────────────────────────────────────────────
  static const Color mrt6 = Color(0xFF006A4E);
  static const Color mrt5 = Color(0xFF0066CC);
  static const Color mrt1 = Color(0xFFE67E22);

  // ── Card Status ────────────────────────────────────────────────────────────
  static const Color activeCard = Color(0xFF2D9D78);
  static const Color inactiveCard = Color(0xFF9CA3AF);
  static const Color expiredCard = Color(0xFFCC2936);
  static const Color lowBalance = Color(0xFFE67E22);
}
