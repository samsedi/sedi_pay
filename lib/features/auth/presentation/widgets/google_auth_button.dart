import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';

class GoogleAuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const GoogleAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: isPrimary
          ? _buildPrimaryButton(context)
          : _buildSecondaryButton(context),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    final Widget button = Container(
      decoration: BoxDecoration(
        color: isLightMode
            ? AppColors.iconBackgroundLight
            : AppColors.glassModalDark,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(26),
          child: _ButtonContent(label: label),
        ),
      ),
    );

    return isLightMode ? button : _applyGlassEffect(button);
  }

  Widget _buildSecondaryButton(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    final Widget button = Container(
      decoration: BoxDecoration(
        color: isLightMode
            ? Colors.black.withValues(alpha: 0.03)
            : AppColors.glassDark,
        borderRadius: BorderRadius.circular(26),
        border: isLightMode
            ? Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1)
            : null, // No border in dark mode
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(26),
          child: _ButtonContent(label: label),
        ),
      ),
    );

    return isLightMode ? button : _applyGlassEffect(button);
  }

  Widget _applyGlassEffect(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: child,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;

  const _ButtonContent({required this.label});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _GoogleLogo(),
        const SizedBox(width: AppDimensions.paddingSmall),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isLightMode ? AppColors.textDark : AppColors.textLight,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset('assets/images/GoogleLogo.png', fit: BoxFit.cover),
    );
  }
}
