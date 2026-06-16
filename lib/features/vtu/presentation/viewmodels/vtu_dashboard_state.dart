import 'package:equatable/equatable.dart';

import '../../domain/entities/service_item.dart';
import '../../domain/entities/transaction_item.dart';

export '../../domain/entities/service_item.dart';
export '../../domain/entities/transaction_item.dart';

/// Immutable state snapshot for the VTU dashboard screen.
class VtuDashboardState extends Equatable {
  final String userName;

  /// When true, the NGN/USDT balance is masked with asterisks.
  final bool isBalanceHidden;

  final double ngnBalance;
  final double usdtBalance;

  /// Controls whether the recent transactions bottom sheet is fully expanded.
  final bool isTransactionSheetExpanded;

  final List<TransactionItem> recentTransactions;
  final List<ServiceItem> quickServices;

  const VtuDashboardState({
    this.userName = '',
    this.isBalanceHidden = false,
    this.ngnBalance = 0.0,
    this.usdtBalance = 0.0,
    this.isTransactionSheetExpanded = false,
    this.recentTransactions = const [],
    this.quickServices = const [],
  });

  VtuDashboardState copyWith({
    String? userName,
    bool? isBalanceHidden,
    double? ngnBalance,
    double? usdtBalance,
    bool? isTransactionSheetExpanded,
    List<TransactionItem>? recentTransactions,
    List<ServiceItem>? quickServices,
  }) {
    return VtuDashboardState(
      userName: userName ?? this.userName,
      isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
      ngnBalance: ngnBalance ?? this.ngnBalance,
      usdtBalance: usdtBalance ?? this.usdtBalance,
      isTransactionSheetExpanded:
          isTransactionSheetExpanded ?? this.isTransactionSheetExpanded,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      quickServices: quickServices ?? this.quickServices,
    );
  }

  @override
  List<Object?> get props => [
        userName,
        isBalanceHidden,
        ngnBalance,
        usdtBalance,
        isTransactionSheetExpanded,
        recentTransactions,
        quickServices,
      ];
}
