import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/app_colors.dart';
import '../viewmodels/airtime_view_model.dart';
import '../widgets/airtime_balance_card.dart';
import '../widgets/amount_input.dart';
import '../widgets/cloud_fade_overlay.dart';
import '../widgets/network_selection.dart';
import '../widgets/phone_number_input.dart';
import '../widgets/preset_amount_chips.dart';
import '../widgets/transaction_pin_sheet.dart';

/// Screen for purchasing airtime for any Nigerian network provider.
///
/// This is a pure UI widget — all business logic lives in [AirtimeViewModel].
class AirtimePurchaseView extends StatelessWidget {
  const AirtimePurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      backgroundColor:
          isDarkMode ? AppColors.darkScaffold : AppColors.lightScaffold,
      appBar: const _AirtimeAppBar(),
      body: const Stack(
        children: [
          // ── Scrollable content ──
          _AirtimeBody(),

          // ── Cloud / fade gradient overlay ──
          CloudFadeOverlay(),

          // ── Floating CTA button ──
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: _FloatingCtaButton(),
          ),
        ],
      ),
    );
  }
}

// ── Private Sub-Widgets ──────────────────────────────────────────────────────

/// Transparent app bar for the Buy Airtime screen.
class _AirtimeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AirtimeAppBar();

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
        'Buy Airtime',
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

/// Scrollable main content column for the Buy Airtime screen.
class _AirtimeBody extends ConsumerWidget {
  const _AirtimeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airtimeState = ref.watch(airtimeProvider);
    final airtimeNotifier = ref.read(airtimeProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 16.0,
        bottom: 150.0, // Reserve space for the floating CTA
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AirtimeBalanceCard(balance: AirtimeViewModel.mockWalletBalance),
          const SizedBox(height: 20),

          PhoneNumberInput(
            resolvedName: airtimeState.resolvedName,
            isLoadingName: airtimeState.isLoadingName,
            onChanged: airtimeNotifier.updatePhoneNumber,
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Select Network'),
          const SizedBox(height: 12),
          NetworkSelection(
            selectedNetwork: airtimeState.networkProvider,
            onNetworkSelected: airtimeNotifier.updateNetworkProvider,
          ),
          const SizedBox(height: 24),

          const AmountInput(),
          const SizedBox(height: 16),

          const PresetAmountChips(
            presetAmounts: AirtimeViewModel.presetAmounts,
          ),
        ],
      ),
    );
  }
}

/// A small themed section heading used throughout the Buy Airtime screen.
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

/// Blurred floating CTA button pinned to the bottom of the screen.
class _FloatingCtaButton extends ConsumerWidget {
  const _FloatingCtaButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final airtimeState = ref.watch(airtimeProvider);
    final airtimeNotifier = ref.read(airtimeProvider.notifier);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              disabledBackgroundColor: isDarkMode
                  ? AppColors.glassDark
                  : AppColors.primaryBlue.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            onPressed: () {
              if (airtimeNotifier
                  .validateAndSetError(AirtimeViewModel.mockWalletBalance)) {
                _showTransactionPinSheet(context, airtimeState);
              } else {
                final error = ref.read(airtimeProvider).errorMessage;
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
            child: const Text(
              'Proceed to Top-Up',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTransactionPinSheet(BuildContext context, AirtimeState data) {
    TransactionPinSheet.show(
      context,
      title: 'Confirm Top-Up',
      subtitle:
          'Airtime of ₦${data.amount.toStringAsFixed(0)} to ${data.phoneNumber}',
    );
  }
}
