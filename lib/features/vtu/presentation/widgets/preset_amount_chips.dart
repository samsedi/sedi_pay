import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_colors.dart';
import '../viewmodels/airtime_view_model.dart';

class PresetAmountChips extends ConsumerWidget {
  final List<double> presetAmounts;

  const PresetAmountChips({
    super.key,
    required this.presetAmounts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(airtimeProvider);
    final formNotifier = ref.read(airtimeProvider.notifier);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDarkMode ? AppColors.textLight : AppColors.textDark;
    final cardBgColor =
        isDarkMode ? AppColors.cardDarkBackgroundAlt : AppColors.cardLightBackground;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: presetAmounts.map((amt) {
        final isSelected = formState.amount == amt;
        return ChoiceChip(
          label: Text('₦${amt.toStringAsFixed(0)}'),
          selected: isSelected,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          selectedColor: AppColors.primaryBlue,
          backgroundColor: cardBgColor,
          checkmarkColor: Colors.white,
          onSelected: (bool selected) {
            if (selected) formNotifier.updateAmount(amt);
          },
        );
      }).toList(),
    );
  }
}
