import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';

/// Full-width balance card displayed at the top of the VTU dashboard.
///
/// Shows NGN and USDT balances with a toggle to hide/reveal them.
/// The card's aesthetic uses a deep navy background with layered radial glows.
class AirtimeBalanceCard extends StatelessWidget {
  /// The wallet balance amount to display in NGN.
  final double balance;

  const AirtimeBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: const BoxDecoration(color: AppColors.cardDarkBackground),
        child: Stack(
          children: [
            // ── Background glow layers ──
            Positioned(top: -30, left: -40, child: _buildGlow(229, AppColors.glowNavy)),
            Positioned(top: -10, right: -20, child: _buildGlow(150, AppColors.glowBrightBlue)),
            Positioned(bottom: -30, right: -10, child: _buildGlow(170, AppColors.glowDeepBlue)),
            Positioned(bottom: 10, left: -20, child: _buildGlow(130, AppColors.glowPrimaryBlue)),
            Positioned(top: 40, left: 120, child: _buildGlow(100, AppColors.glowSkyBlue)),
            Positioned(top: 20, right: 60, child: _buildGlow(180, AppColors.glowRichBlue)),
            Positioned(bottom: -20, left: 80, child: _buildGlow(200, AppColors.glowDeepBlue)),

            // ── Card content ──
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.textLight,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: AppColors.textSubtleLight,
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₦${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a radial glow circle used as a background decoration layer.
  Widget _buildGlow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.2, 0.7],
        ),
      ),
    );
  }
}
