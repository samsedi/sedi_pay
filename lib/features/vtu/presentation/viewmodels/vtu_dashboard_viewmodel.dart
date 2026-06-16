import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../views/airtime_purchase_view.dart';
import '../views/data_purchase_view.dart';
import 'vtu_dashboard_state.dart';

/// ViewModel for the VTU dashboard.
///
/// Owns all dashboard data: user profile, balances, quick services, and
/// the recent transactions list. In production each data source would be
/// fetched via a dedicated UseCase injected into the constructor.
class VtuDashboardViewModel extends Notifier<VtuDashboardState> {
  @override
  VtuDashboardState build() {
    // TODO(dev): Replace mock data with real UseCases
    return VtuDashboardState(
      userName: 'Sedi',
      isBalanceHidden: false,
      ngnBalance: 45000.50,
      usdtBalance: 120.75,
      isTransactionSheetExpanded: false,

      // ServiceItem.destination holds the page builder — no string-matching needed
      quickServices: [
        ServiceItem(
          icon: Icons.phone_android,
          label: 'Airtime',
          color: Colors.orange,
          destination: (_) => const AirtimePurchaseView(),
        ),
        ServiceItem(
          icon: Icons.wifi,
          label: 'Data',
          color: Colors.blue,
          destination: (_) => const DataPurchaseView(),
        ),
        ServiceItem(
          icon: Icons.lightbulb_outline,
          label: 'Electricity',
          color: Colors.amber,
          // destination is null — feature not yet implemented
        ),
        ServiceItem(
          icon: Icons.currency_exchange,
          label: 'Airtime2Cash',
          color: Colors.green,
          // destination is null — feature not yet implemented
        ),
      ],

      recentTransactions: const [
        TransactionItem(
          icon: PhosphorIconsRegular.deviceMobile,
          title: 'MTN Airtime Recharge',
          subtitle: 'Airtime • Wallet',
          time: 'Today, 10:42 AM',
          amount: '-₦1,000.00',
          isDebit: true,
        ),
        TransactionItem(
          icon: PhosphorIconsRegular.wifiHigh,
          title: 'Airtel 5GB Data Bundle',
          subtitle: 'Data • Wallet',
          time: 'Yesterday, 09:00 AM',
          amount: '-₦1,500.00',
          isDebit: true,
        ),
        TransactionItem(
          icon: PhosphorIconsRegular.lightbulb,
          title: 'IKEDC Prepaid Token',
          subtitle: 'Electricity • Wallet',
          time: 'May 28, 08:15 PM',
          amount: '-₦5,000.00',
          isDebit: true,
        ),
        TransactionItem(
          icon: PhosphorIconsRegular.arrowsLeftRight,
          title: 'Glo Airtime to Cash',
          subtitle: 'Airtime2Cash • Conversion',
          time: 'May 27, 02:30 PM',
          amount: '+₦3,800.00',
          isDebit: false,
        ),
        TransactionItem(
          icon: PhosphorIconsRegular.television,
          title: 'DSTV Premium',
          subtitle: 'Cable TV • Wallet',
          time: 'May 25, 11:10 AM',
          amount: '-₦24,500.00',
          isDebit: true,
        ),
        TransactionItem(
          icon: PhosphorIconsRegular.bank,
          title: 'Wallet Funding',
          subtitle: 'Deposit • Bank Transfer',
          time: 'May 24, 01:15 PM',
          amount: '+₦50,000.00',
          isDebit: false,
        ),
      ],
    );
  }

  /// Toggles the balance visibility between masked and unmasked.
  void toggleBalanceVisibility() {
    state = state.copyWith(isBalanceHidden: !state.isBalanceHidden);
  }

  /// Expands or collapses the recent transactions bottom sheet.
  void toggleTransactionSheet() {
    state = state.copyWith(
      isTransactionSheetExpanded: !state.isTransactionSheetExpanded,
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final vtuDashboardViewModelProvider =
    NotifierProvider<VtuDashboardViewModel, VtuDashboardState>(
  VtuDashboardViewModel.new,
);
