import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class AuthHeadingText extends StatelessWidget {
  final String text;

  const AuthHeadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: isLightMode ? AppColors.textDark : AppColors.textLight,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
    );
  }
}
