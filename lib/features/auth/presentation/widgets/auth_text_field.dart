import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool autoFocus;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.prefixIcon,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.inputBorderDark
                  : AppColors.inputBorderLight,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            autofocus: autoFocus,
            style: TextStyle(
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDarkMode
                    ? AppColors.textSubtleLight
                    : AppColors.textSubtleDark,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: isDarkMode
                    ? AppColors.textSubtleLight
                    : AppColors.textSubtleDark,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
