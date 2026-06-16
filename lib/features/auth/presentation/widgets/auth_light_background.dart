import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class AuthLightBackground extends StatelessWidget {
  final Widget child;

  const AuthLightBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.authLightGradientTop, // Vibrant sky blue at the top
            AppColors.authLightGradientMid, // Soft mid blue
            Colors.white,      // Fades to pure white
            Colors.white,      // Remains white at the bottom
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
