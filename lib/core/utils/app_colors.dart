import 'package:flutter/material.dart';

/// Central color palette for SediPay.
///
/// All colors in the app must reference this class.
/// Never use raw `Color(...)` or `Colors.*` literals in widgets or views.
class AppColors {
  AppColors._(); // Prevent instantiation

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF5BA4FF);
  static const Color primaryDark = Color(0xFF0F172A);

  // ── Auth Backgrounds ─────────────────────────────────────────────────────
  static const Color authLightGradientTop = Color(0xFF5BA4FF);
  static const Color authLightGradientMid = Color(0xFFA5CFFF);
  static const Color authDarkGradientTop = Color(0xFF0A1628);
  static const Color authDarkGradientMid = Color(0xFF0F172A);

  // ── Scaffold Backgrounds ─────────────────────────────────────────────────
  /// Light mode scaffold / page background
  static const Color lightScaffold = Color(0xFFF8FAFC);
  /// Dark mode scaffold / page background (pure black for OLED)
  static const Color darkScaffold = Colors.black;

  // ── Card Backgrounds ─────────────────────────────────────────────────────
  static const Color cardDarkBackground = Color(0xFF0A1628);
  static const Color cardDarkBackgroundAlt = Color(0xFF1E293B);
  static const Color cardLightBackground = Color(0xFFF8FAFC);
  static const Color iconBackgroundDark = Color(0xFF1F2937);
  static const Color iconBackgroundLight = Color(0xFFF1F5F9);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textSubtleLight = Colors.white54;
  static const Color textSubtleLightAlt = Color(0xB3FFFFFF); // White 70% opacity
  static const Color textSubtleDark = Color(0xFF94A3B8);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color errorLight = Color(0xFFE24B4A);
  static Color errorDark = Colors.redAccent.shade100;
  static const Color errorBackground = Color(0x1AE24B4A); // 10% opacity error

  static const Color successLight = Color(0xFF3B6D11);
  static Color successDark = Colors.greenAccent.shade100;
  static const Color successGreen = Color(0xFF10B981);

  // ── Borders & Inputs ─────────────────────────────────────────────────────
  static const Color inputBorderLight = Color(0xFFE0E0E0);
  static const Color inputBorderDark = Color(0xFF374151); // grey.shade700 equivalent

  // ── Glass / Frost ─────────────────────────────────────────────────────────
  /// Frosted glass background for dark mode overlays (5% white)
  static const Color glassDark = Color(0x0DFFFFFF);
  /// Frosted glass background for modals (7% white)
  static const Color glassModalDark = Color(0x12FFFFFF);
  /// Subtle white border for glass cards (10% white)
  static const Color glassBorderDark = Color(0x1AFFFFFF);
  /// Frosted glass surface for light mode widgets (60% white)
  static const Color glassLight = Color(0x99FFFFFF);

  // ── Navigation ───────────────────────────────────────────────────────────
  static const Color navActiveColor = primaryBlue;
  static const Color navInactiveColor = Color(0xFF9CA3AF); // grey.shade500 equivalent

  // ── Balance Card Glows (reusable across BalanceCard & AirtimeBalanceCard) ─
  static const Color glowDeepBlue = Color(0x992563EB);
  static const Color glowBrightBlue = Color(0x4D60A5FA);
  static const Color glowPrimaryBlue = Color(0x333B82F6);
  static const Color glowSkyBlue = Color(0x1F63B3FF);
  static const Color glowIntenseBlue = Color(0x992563EB);
  static const Color glowRichBlue = Color(0x732563EB);   // Airtime card extra glow
  static const Color glowNavy = Color(0x990052FF);        // Airtime card primary glow

  // ── "View All" / Action Pill Buttons ─────────────────────────────────────
  /// Semi-transparent primary blue used on light backgrounds (e.g., "View All" pill)
  static const Color pillButtonLight = Color(0x992563EB);
}
