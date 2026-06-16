import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class AuthSubheadingText extends StatelessWidget {
  final String text;

  const AuthSubheadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isLightMode 
                ? AppColors.textSubtleDark 
                : AppColors.textSubtleLightAlt,
            height: 1.5,
          ),
    );
  }
}
