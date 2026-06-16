import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../viewmodels/vtu_dashboard_state.dart';
import '../viewmodels/vtu_dashboard_viewmodel.dart';

class RecentTransactionsCard extends ConsumerWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dashboardState = ref.watch(vtuDashboardViewModelProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusLarge),
          topRight: Radius.circular(AppDimensions.radiusLarge),
        ),
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _DragHandle(isExpanded: dashboardState.isTransactionSheetExpanded),
          const _Header(),
          const SizedBox(height: AppDimensions.paddingMedium),
          _TransactionList(transactions: dashboardState.recentTransactions),
        ],
      ),
    );
  }
}

// ── Private Sub-Widgets ──────────────────────────────────────────────────────

class _DragHandle extends ConsumerWidget {
  final bool isExpanded;

  const _DragHandle({required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        ref.read(vtuDashboardViewModelProvider.notifier).toggleTransactionSheet();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingMedium,
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.textLight : AppColors.pillButtonLight,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusSmall,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isExpanded ? 'Tap to collapse' : 'Tap to expand',
              style: TextStyle(
                fontSize: 10,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? AppColors.textLight : AppColors.textDark;

    return Padding(
      padding: AppDimensions.horizontalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryTextColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusMedium,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: isDarkMode ? AppColors.textDark : AppColors.textLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<TransactionItem> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: transactions.length,
          padding: const EdgeInsets.only(bottom: 125),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _TransactionRow(transaction: transaction);
          },
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final TransactionItem transaction;

  const _TransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingSmall,
      ),
      child: Row(
        children: [
          _TransactionIcon(icon: transaction.icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: primaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _getAmountColor(transaction.isDebit, isDarkMode),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                transaction.time,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getAmountColor(bool isDebit, bool isDarkMode) {
    if (isDebit) {
      return isDarkMode ? AppColors.errorDark : AppColors.errorLight;
    } else {
      return isDarkMode ? AppColors.successDark : AppColors.successLight;
    }
  }
}

class _TransactionIcon extends StatelessWidget {
  final IconData icon;

  const _TransactionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.primaryBlue.withValues(alpha: 0.05)
                : AppColors.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.primaryBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 22,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
