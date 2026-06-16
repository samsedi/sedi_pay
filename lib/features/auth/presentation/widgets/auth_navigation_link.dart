import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class AuthNavigationLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onPressed;

  const AuthNavigationLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isLightMode 
                ? AppColors.textSubtleDark 
                : AppColors.textSubtleLightAlt,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
