import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';

/// A reusable bottom sheet for collecting a 4-digit transaction PIN.
///
/// Used across all transaction flows (airtime, data, electricity, etc.).
/// Pass [title] and [subtitle] to contextualise the confirmation message
/// for each flow.
///
/// Example usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => TransactionPinSheet(
///     title: 'Confirm Purchase',
///     subtitle: '5GB for ₦2,000 to 08031234567',
///     onConfirm: (pin) { /* process pin */ },
///   ),
/// );
/// ```
class TransactionPinSheet extends StatelessWidget {
  /// The heading text shown at the top of the sheet.
  final String title;

  /// A descriptive line that summarises the transaction being confirmed,
  /// e.g. "Airtime of ₦500 to 08031234567".
  final String subtitle;

  /// Optional callback invoked when the user submits their PIN.
  /// Receives the entered 4-digit PIN string.
  ///
  /// If null, the confirm button is disabled (sheet is display-only).
  final void Function(String pin)? onConfirm;

  const TransactionPinSheet({
    super.key,
    required this.title,
    required this.subtitle,
    this.onConfirm,
  });

  /// Convenience static method to show this sheet from any screen.
  ///
  /// Use this instead of calling [showModalBottomSheet] directly so all
  /// callers benefit from consistent presentation settings.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    void Function(String pin)? onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionPinSheet(
        title: title,
        subtitle: subtitle,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.glassModalDark : AppColors.lightScaffold,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: isDarkMode
                ? Border.all(color: AppColors.glassBorderDark, width: 0.5)
                : null,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ──
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.glassBorderDark
                      : AppColors.inputBorderLight,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 24),

              // ── Title ──
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              // ── Transaction summary subtitle ──
              Text(
                subtitle,
                style: TextStyle(
                  color: isDarkMode ? AppColors.textSubtleLight : AppColors.textSubtleDark,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // ── 4-digit PIN boxes ──
              // TODO(dev): Replace with a real PinInput widget that handles
              //            keyboard input and passes the assembled PIN to [onConfirm].
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _PinDigitBox(isDarkMode: isDarkMode),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private sub-widget ────────────────────────────────────────────────────────

/// A single PIN digit input box.
class _PinDigitBox extends StatelessWidget {
  final bool isDarkMode;

  const _PinDigitBox({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.glassDark : AppColors.cardLightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppColors.glassBorderDark : AppColors.inputBorderLight,
        ),
      ),
    );
  }
}
