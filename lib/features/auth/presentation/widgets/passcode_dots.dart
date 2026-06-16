import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/utils/app_colors.dart';

/// A widget that displays a row of animated dots to represent a passcode input.
/// 
/// The dots fill up based on [pinLength] and show an error animation if [isError] is true.
class PasscodeDots extends StatelessWidget {
  final int pinLength;
  final int maxPinLength;
  final bool isError;

  const PasscodeDots({
    super.key,
    required this.pinLength,
    required this.maxPinLength,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    Widget dotsRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxPinLength, (index) {
        final isFilled = index < pinLength;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? (isError
                    ? Colors.red
                    : (isLightMode ? AppColors.primaryBlue : Colors.white))
                : Colors.transparent,
            border: Border.all(
              color: isError
                  ? Colors.red
                  : (isLightMode
                      ? AppColors.primaryBlue.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.5)),
              width: 2,
            ),
          ),
        );
      }),
    );

    if (isError) {
      dotsRow = dotsRow.animate(onPlay: (controller) => controller.repeat()).shakeX(
            duration: 400.ms,
            hz: 4,
            amount: 8,
          );
    }

    return dotsRow;
  }
}
