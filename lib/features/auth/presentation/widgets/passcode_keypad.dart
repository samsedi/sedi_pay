import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/app_colors.dart';

class PasscodeKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricsPressed; // Optional for FaceID/TouchID

  const PasscodeKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _KeypadButton(
              onPressed: onBiometricsPressed ?? () {},
              child: onBiometricsPressed != null
                  ? PhosphorIcon(PhosphorIcons.fingerprint(), size: 32)
                  : const SizedBox(width: 72, height: 72),
            ),
            _KeypadButton(
              onPressed: () => onDigitPressed('0'),
              child: const Text('0'),
            ),
            _KeypadButton(
              onPressed: onBackspacePressed,
              child: PhosphorIcon(PhosphorIcons.backspace(), size: 32),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        return _KeypadButton(
          onPressed: () => onDigitPressed(digit),
          child: Text(digit),
        );
      }).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _KeypadButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final textColor = isLightMode ? AppColors.textDark : AppColors.textLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(36),
        splashColor: isLightMode
            ? AppColors.primaryBlue.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.1),
        highlightColor: isLightMode
            ? AppColors.primaryBlue.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.05),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            child: IconTheme(
              data: IconThemeData(color: textColor),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
