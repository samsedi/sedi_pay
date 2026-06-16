import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class NetworkSelection extends StatelessWidget {
  final String selectedNetwork;
  final ValueChanged<String> onNetworkSelected;

  const NetworkSelection({
    super.key,
    required this.selectedNetwork,
    required this.onNetworkSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNetworkItem('MTN', 'assets/images/mtn.png'),
        _buildNetworkItem('Airtel', 'assets/images/airtel.png'),
        _buildNetworkItem('Glo', 'assets/images/glo.png'),
        _buildNetworkItem('9mobile', 'assets/images/9mobile.png'),
      ],
    );
  }

  Widget _buildNetworkItem(String name, String imagePath) {
    final bool hasSelection = selectedNetwork.isNotEmpty;
    final bool isSelected = selectedNetwork == name;
    final bool isDimmed = hasSelection && !isSelected;

    return GestureDetector(
      onTap: () => onNetworkSelected(name),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDimmed ? Colors.grey.shade100 : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : (isDimmed ? Colors.transparent : Colors.grey.shade300),
                width: isSelected ? 2.5 : 1.0,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            alignment: Alignment.center,
            child: ClipOval(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: isDimmed ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: value * 2,
                      sigmaY: value * 2,
                    ),
                    child: Opacity(opacity: 1.0 - (value * 0.5), child: child),
                  );
                },
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.primaryBlue
                  : (isDimmed ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            child: Text(name),
          ),
        ],
      ),
    );
  }
}
