import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';


import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/presentation/widgets/adaptive_auth_background.dart';
import '../widgets/cloud_fade_overlay.dart';
import 'profile_view.dart';
import 'vtu_dashboard_view.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainLayoutView extends ConsumerWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

    final screens = [
      const VtuDashboardView(),
      const Center(child: Text('Transaction History View')),
      const Center(child: Text('Cards View')),
      const ProfileView(),
    ];

    final stack = Stack(
      children: [
        // 1. The Main Dashboard Content (Background)
        IndexedStack(index: currentIndex, children: screens),

        // 2. The Fade Effect Overlay (Middle Layer)
        const CloudFadeOverlay(
          fadeStop: 0.78,
          maxOpacity: 0.80,
        ),

        // 3. The Floating Pill Navigation Bar (Foreground Overlay)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            child: _NavigationBar(currentIndex: currentIndex),
          ),
        ),
      ],
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: isDarkMode ? AppColors.darkScaffold : Colors.transparent,
      body: isDarkMode ? stack : AdaptiveAuthBackground(child: stack),
    );
  }
}

// ── Private Sub-Widgets ──────────────────────────────────────────────────────

/// The floating pill-shaped bottom navigation bar.
class _NavigationBar extends ConsumerWidget {
  final int currentIndex;

  const _NavigationBar({required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkScaffold : AppColors.lightScaffold,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDarkMode
              ? AppColors.inputBorderDark
              : AppColors.inputBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            activeIcon: PhosphorIconsFill.house,
            inactiveIcon: PhosphorIconsRegular.house,
            index: 0,
            currentIndex: currentIndex,
          ),
          _NavItem(
            activeIcon: PhosphorIconsFill.receipt,
            inactiveIcon: PhosphorIconsRegular.receipt,
            index: 1,
            currentIndex: currentIndex,
          ),
          _NavItem(
            activeIcon: PhosphorIconsFill.creditCard,
            inactiveIcon: PhosphorIconsRegular.creditCard,
            index: 2,
            currentIndex: currentIndex,
          ),
          _NavItem(
            activeIcon: PhosphorIconsFill.user,
            inactiveIcon: PhosphorIconsRegular.user,
            index: 3,
            currentIndex: currentIndex,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final int index;
  final int currentIndex;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          color: isSelected
              ? AppColors.navActiveColor
              : AppColors.navInactiveColor,
          size: 24,
        ),
      ),
    );
  }
}
