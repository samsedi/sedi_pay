import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class AuthDarkBackground extends StatelessWidget {
  final Widget child;

  const AuthDarkBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.authDarkGradientTop, // Deep rich blue at the top
            AppColors.authDarkGradientMid, // Slate/Navy transition
            Colors.black, // Fades to pure black
            Colors.black, // Remains black at the bottom
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
