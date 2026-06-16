import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/app_colors.dart';
import '../viewmodels/data_purchase_viewmodel.dart';
import '../widgets/airtime_balance_card.dart';
import '../widgets/cloud_fade_overlay.dart';
import '../widgets/data_plan_card.dart';
import "../widgets/data_plan_categories.dart";
import '../widgets/network_selection.dart';
import '../widgets/phone_number_input.dart';
import '../widgets/transaction_pin_sheet.dart';

class DataPurchaseView extends StatelessWidget {
  const DataPurchaseView({super.key});

  static const double _mockCurrentBalance = 15000.00;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      extendBody: true,
      appBar: const _DataPurchaseAppBar(),
      body: const Stack(
        children: [
          // ── Scrollable content ──
          _DataPurchaseBody(balance: DataPurchaseView._mockCurrentBalance),

          // ── Cloud / fade gradient overlay ──
          CloudFadeOverlay(),
        ],
      ),
    );
  }
}

// ── Private Sub-Widgets ──────────────────────────────────────────────────────

/// Transparent app bar for the Buy Data screen.
class _DataPurchaseAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _DataPurchaseAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDarkMode ? AppColors.textLight : AppColors.textDark;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(PhosphorIconsRegular.caretLeft, color: primaryTextColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Buy Data',
        style: TextStyle(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}

/// Scrollable main content column for the Buy Data screen.
class _DataPurchaseBody extends ConsumerWidget {
  final double balance;

  const _DataPurchaseBody({required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataPurchaseProvider);
    final notifier = ref.read(dataPurchaseProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 16.0,
        bottom: 140.0, // leave room for the floating button/fade
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AirtimeBalanceCard(balance: balance),
          const SizedBox(height: 20),

          PhoneNumberInput(
            resolvedName: state.resolvedName,
            isLoadingName: state.isLoadingName,
            onChanged: notifier.updatePhoneNumber,
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Select Network'),
          const SizedBox(height: 12),
          NetworkSelection(
            selectedNetwork: state.networkProvider,
            onNetworkSelected: notifier.updateNetworkProvider,
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Data Plans'),
          const SizedBox(height: 12),
          const DataPlanCategories(),
          const SizedBox(height: 10),
          _DataPlansGrid(balance: balance),
        ],
      ),
    );
  }
}

/// A small themed section heading used throughout the Buy Data screen.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode ? AppColors.textLight : AppColors.textDark,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// 2-column grid of tappable data plan cards, filtered by the selected category.
class _DataPlansGrid extends ConsumerWidget {
  final double balance;

  const _DataPlansGrid({required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataPurchaseProvider);
    final notifier = ref.read(dataPurchaseProvider.notifier);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: state.filteredPlans.length,
      itemBuilder: (context, index) {
        final plan = state.filteredPlans[index];
        final isSelected = state.selectedPlan == plan;

        return DataPlanCard(
          dataSize: plan.size,
          validity: plan.validity,
          price: plan.displayPrice,
          isSelected: isSelected,
          onTap: () {
            notifier.selectDataPlan(plan);

            final updatedState = state.copyWith(
              selectedPlan: plan,
              clearError: true,
            );

            if (notifier.validateAndSetError(balance)) {
              _showTransactionPinSheet(context, updatedState);
            } else {
              final error = ref.read(dataPurchaseProvider).errorMessage;
              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.errorLight,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  void _showTransactionPinSheet(BuildContext context, DataPurchaseState data) {
    TransactionPinSheet.show(
      context,
      title: 'Confirm Purchase',
      subtitle:
          '${data.selectedPlan?.size} for ${data.selectedPlan?.displayPrice} to ${data.phoneNumber}',
    );
  }
}
