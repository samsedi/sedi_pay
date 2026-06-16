import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_colors.dart';
import '../viewmodels/vtu_dashboard_viewmodel.dart';

/// Renders the 4-up grid of quick-action service tiles on the dashboard.
///
/// Each tile reads its navigation destination from [ServiceItem.destination].
/// No string-matching or hardcoded route labels needed in this widget.
class QuickServicesGrid extends ConsumerWidget {
  const QuickServicesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final services = ref.watch(vtuDashboardViewModelProvider).quickServices;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        // Lowered to give the label text more vertical breathing room
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final service = services[index];
        return GestureDetector(
          onTap: service.destination != null
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: service.destination!),
                  )
              : null, // null destination = feature not yet implemented
          child: Column(
            children: [
              // ── Glassmorphism icon container ──
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 54,
                    width: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.glassBorderDark
                            : Colors.white.withValues(alpha: 0.8),
                        width: 1,
                      ),
                      boxShadow: [
                        if (!isDarkMode)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Icon(service.icon, color: service.color, size: 26),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // ── Service label ──
              Expanded(
                child: Text(
                  service.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.textSubtleLight.withValues(alpha: 0.8)
                        : AppColors.textDark.withValues(alpha: 0.85),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
