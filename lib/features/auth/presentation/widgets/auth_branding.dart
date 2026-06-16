import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';

class AuthBranding extends StatelessWidget {
  const AuthBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoWithPlatform(),
        const SizedBox(height: AppDimensions.paddingLarge),
        _buildTitle(context),
        const SizedBox(height: AppDimensions.paddingSmall),
        _buildSubtitle(context),
      ],
    );
  }

  /// Icon sitting on a glowing platform hex — mirrors the SpeechLab 3D disc.
  Widget _buildLogoWithPlatform() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer diffuse glow ring
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.glowBrightBlue.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          // 3D-style ellipse platform (the disc/hex base)
          Positioned(bottom: 18, child: _Platform3D()),
          // Icon container
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.glassDark,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.glassBorderDark.withValues(alpha: 0.8),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glowBrightBlue.withValues(alpha: 0.6),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.glowSkyBlue.withValues(alpha: 0.3),
                  blurRadius: 48,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              PhosphorIconsFill.wallet,
              size: 34,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Sedi Pay',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppColors.textLight,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Seamless Payments, Instantly.',
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: AppColors.textSubtleDark),
      textAlign: TextAlign.center,
    );
  }
}

/// The elliptical glowing platform the logo sits on, mimicking the 3D disc in the reference.
class _Platform3D extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(55),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.glowBrightBlue.withValues(alpha: 0.45),
            AppColors.glowDeepBlue.withValues(alpha: 0.15),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowBrightBlue.withValues(alpha: 0.5),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
