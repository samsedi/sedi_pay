import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../viewmodels/vtu_dashboard_viewmodel.dart';
import '../widgets/balance_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/quick_services_grid.dart';
import '../widgets/recent_transactions_card.dart';

class VtuDashboardView extends ConsumerWidget {
  const VtuDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? AppColors.textLight : AppColors.textDark;

    // Read the current state from our ViewModel
    final dashboardState = ref.watch(vtuDashboardViewModelProvider);
    final isExpanded = dashboardState.isTransactionSheetExpanded;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const DashboardAppBar(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 1. Static Background Content
            Padding(
              padding: AppDimensions.horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BalanceCard(),
                  const SizedBox(height: AppDimensions.paddingExtraLarge),
                  Text(
                    'Quick Services',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  const QuickServicesGrid(),
                ],
              ),
            ),

            // 2. The Strictly Controlled Animated Card
            AnimatedPositioned(
              duration: AppDimensions.animationMedium,
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: 0,
              height: isExpanded ? screenHeight * 0.85 : screenHeight * 0.45,
              child: const RecentTransactionsCard(),
            ),
          ],
        ),
      ),
    );
  }
}
