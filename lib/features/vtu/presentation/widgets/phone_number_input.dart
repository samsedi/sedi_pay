import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/app_colors.dart';

/// A shared phone-number input widget.
class PhoneNumberInput extends StatelessWidget {
  final String resolvedName;
  final bool isLoadingName;
  final ValueChanged<String> onChanged;

  const PhoneNumberInput({
    super.key,
    required this.resolvedName,
    required this.isLoadingName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? AppColors.textLight : AppColors.textDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.phone,
          maxLength: 11,
          style: TextStyle(color: primaryTextColor),
          onChanged: onChanged,
          decoration: InputDecoration(
            counterText: '',
            hintText: '0803 000 0000',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: false,
            prefixIcon: Icon(
              PhosphorIconsRegular.phone,
              color: Colors.grey.shade500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (isLoadingName)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Resolving number registry...',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          )
        else if (resolvedName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4),
            child: Text(
              'Receiver: $resolvedName',
              style: const TextStyle(
                color: AppColors.successGreen,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
