import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Padding & Margins
  static const double paddingSmall = 10.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingExtraLarge = 32.0;

  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: paddingLarge);

  // Border Radii
  static const double radiusSmall = 10.0;
  static const double radiusMedium = 20.0;
  static const double radiusLarge = 30.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);
}
