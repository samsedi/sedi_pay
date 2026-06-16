import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';

/// A card widget displaying the details of a data plan.
/// 
/// Uses glassmorphism effects to render an appealing visual presentation.
class DataPlanCard extends StatelessWidget {
  final String dataSize;
  final String validity;
  final String price;
  final bool isSelected;
  final VoidCallback? onTap;

  const DataPlanCard({
    super.key,
    required this.dataSize,
    required this.validity,
    required this.price,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode
        ? AppColors.textLight
        : AppColors.textDark;
    
    final cardBgColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;

    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dataSize,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          validity,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primaryBlue
                    : primaryTextColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.textLight : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusMedium,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Buy',
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    Widget innerContainer = Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(30),
        border: isDarkMode 
            ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5) 
            : null,
      ),
      child: cardContent,
    );

    Widget glassCard = isDarkMode
        ? ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: innerContainer,
            ),
          )
        : innerContainer;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animationFast,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: glassCard,
      ),
    );
  }
}
