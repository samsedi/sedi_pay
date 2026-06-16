import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../viewmodels/vtu_dashboard_viewmodel.dart';

/// The main balance card on the VTU dashboard.
///
/// Displays NGN and USDT balances with hide/show toggle and
/// deposit/withdraw action buttons.
class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(vtuDashboardViewModelProvider);
    final isHidden = dashboardState.isBalanceHidden;

    final ngnText = isHidden ? '****' : '₦ ${dashboardState.ngnBalance.toStringAsFixed(2)}';
    final usdtText = isHidden ? '****' : '≈ \$${dashboardState.usdtBalance.toStringAsFixed(2)} USDT';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        color: AppColors.cardDarkBackground,
      ),
      child: Stack(
        children: [
          // ── Background glow layers ──
          const Positioned(top: -30, left: -40, child: _GlowCircle(size: 220, color: AppColors.glowDeepBlue)),
          const Positioned(top: -10, right: -20, child: _GlowCircle(size: 150, color: AppColors.glowBrightBlue)),
          const Positioned(bottom: -30, right: -10, child: _GlowCircle(size: 170, color: AppColors.glowIntenseBlue)),
          const Positioned(bottom: 10, left: -20, child: _GlowCircle(size: 130, color: AppColors.glowPrimaryBlue)),
          const Positioned(top: 40, left: 120, child: _GlowCircle(size: 100, color: AppColors.glowSkyBlue)),

          // ── Card content ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: label + visibility toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total balance',
                    style: TextStyle(
                      color: AppColors.textSubtleLight,
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                  _PortfolioToggleButton(
                    isHidden: isHidden,
                    onTap: () => ref
                        .read(vtuDashboardViewModelProvider.notifier)
                        .toggleBalanceVisibility(),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingSmall),

              // NGN balance
              Text(
                ngnText,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              // USDT equivalent
              Text(
                usdtText,
                style: const TextStyle(
                  color: AppColors.textSubtleLight,
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 22),

              // Action buttons
              Row(
                children: [
                  Expanded(child: _ActionButton.deposit()),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Expanded(child: _ActionButton.withdraw()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}

/// A circular radial glow used as a decorative background element.
class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 0.7],
        ),
      ),
    );
  }
}

// ── Private Sub-Widgets ──────────────────────────────────────────────────────

/// Pill-shaped button to toggle balance visibility ("Portfolio" toggle).
class _PortfolioToggleButton extends StatelessWidget {
  final bool isHidden;
  final VoidCallback onTap;

  const _PortfolioToggleButton({required this.isHidden, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSmall,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: AppColors.textLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textDark,
              size: 14,
            ),
            const SizedBox(width: 5),
            const Text(
              'Portfolio',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A rounded action button for Deposit or Withdraw.
class _ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;

  const _ActionButton({required this.label, required this.isPrimary});

  factory _ActionButton.deposit() => const _ActionButton(label: 'Deposit', isPrimary: true);
  factory _ActionButton.withdraw() => const _ActionButton(label: 'Withdraw', isPrimary: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.textLight
            : AppColors.textLight.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(21),
        border: isPrimary
            ? null
            : Border.all(color: AppColors.textLight.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? AppColors.textDark : AppColors.textLight,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
