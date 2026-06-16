import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../viewmodels/profile_state.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/cloud_fade_overlay.dart';

// ── Public View ───────────────────────────────────────────────────────────────

/// Profile screen — tab 3 of the main bottom navigation.
///
/// Pure UI widget. All logic and data live in [ProfileViewModel].
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: const _ProfileAppBar(),
      body: const Stack(
        children: [
          // ── Scrollable content ──
          _ProfileBody(),

          // ── Cloud / fade gradient overlay ──
          CloudFadeOverlay(
            fadeStop: 0.78,
            maxOpacity: 0.80,
          ),
        ],
      ),
    );
  }
}

// ── Private Sub-Widgets ──────────────────────────────────────────────────────

/// Transparent app bar for the Profile screen.
class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode
        ? AppColors.textLight
        : AppColors.textDark;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Profile',
        style: TextStyle(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}

/// Main scrollable body of the Profile screen.
class _ProfileBody extends ConsumerWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

    final groups = notifier.buildMenuGroups(
      onEditProfile: () {},
      onSecurity: () {},
      onSupport: () {},
      onAbout: () {},
      onLogout: () {},
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppDimensions.paddingLarge,
        right: AppDimensions.paddingLarge,
        top: 8,
        bottom: 140, // clear the floating nav bar
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(state: state),
          const SizedBox(height: 20),
          _AccountTierBadge(tier: state.accountTier),
          const SizedBox(height: 28),

          for (final group in groups) ...[
            _MenuGroupCard(
              group: group,
              state: state,
              notifier: notifier,
              isDarkMode: isDarkMode,
              ref: ref,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

/// Circular avatar + name / email header.
class _ProfileHeader extends StatelessWidget {
  final ProfileState state;

  const _ProfileHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _AvatarBubble(initials: state.initials),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.fullName,
                style: TextStyle(
                  color: isDarkMode ? AppColors.textLight : AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                state.email,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textSubtleLight
                      : AppColors.textSubtleDark,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                state.phoneNumber,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textSubtleLight
                      : AppColors.textSubtleDark,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        _EditIconButton(),
      ],
    );
  }
}

/// Glassmorphic circle avatar showing the user's initials.
class _AvatarBubble extends StatelessWidget {
  final String initials;

  const _AvatarBubble({required this.initials});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), AppColors.primaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small circular pencil-icon button beside the profile header.
class _EditIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode
              ? AppColors.glassDark
              : AppColors.iconBackgroundLight,
          border: Border.all(
            color: isDarkMode
                ? AppColors.inputBorderDark
                : AppColors.inputBorderLight,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          PhosphorIconsRegular.pencilSimple,
          size: 16,
          color: isDarkMode ? AppColors.textLight : AppColors.textDark,
        ),
      ),
    );
  }
}

/// Pill badge showing the user's KYC / account tier.
class _AccountTierBadge extends StatelessWidget {
  final String tier;

  const _AccountTierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            PhosphorIconsRegular.medal,
            size: 16,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 6),
          Text(
            '$tier Account',
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A card containing a single labelled group of menu rows.
class _MenuGroupCard extends StatelessWidget {
  final ProfileMenuGroup group;
  final ProfileState state;
  final ProfileViewModel notifier;
  final bool isDarkMode;
  final WidgetRef ref;

  const _MenuGroupCard({
    required this.group,
    required this.state,
    required this.notifier,
    required this.isDarkMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(AppDimensions.radiusMedium);

    final rowsColumn = Column(
      children: [
        for (int i = 0; i < group.items.length; i++) ...[
          _MenuRow(
            item: group.items[i],
            state: state,
            notifier: notifier,
            isDarkMode: isDarkMode,
            ref: ref,
          ),
          if (i < group.items.length - 1)
            _RowDivider(isDarkMode: isDarkMode),
        ],
      ],
    );

    final innerCard = Container(
      decoration: BoxDecoration(
        // Dark: frosted white (matches DataPlanCard glassmorphism pattern).
        // Light: solid white card.
        color: isDarkMode ? AppColors.glassDark : Colors.white,
        borderRadius: cardRadius,
        border: isDarkMode
            ? Border.all(
                color: AppColors.glassBorderDark,
                width: 0.5,
              )
            : Border.all(
                color: AppColors.inputBorderLight,
                width: 1,
              ),
        boxShadow: isDarkMode
            ? [
                // Primary drop shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
                // Ambient glow layer
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: rowsColumn,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeading(text: group.heading),
        const SizedBox(height: 8),
        if (isDarkMode)
          ClipRRect(
            borderRadius: cardRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: innerCard,
            ),
          )
        else
          innerCard,
      ],
    );
  }

}

/// Small uppercase section heading above a card group.
class _GroupHeading extends StatelessWidget {
  final String text;

  const _GroupHeading({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: isDarkMode
            ? AppColors.textSubtleLight
            : AppColors.textSubtleDark,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// A single tappable row inside a menu group card.
class _MenuRow extends StatelessWidget {
  final ProfileMenuItem item;
  final ProfileState state;
  final ProfileViewModel notifier;
  final bool isDarkMode;
  final WidgetRef ref;

  const _MenuRow({
    required this.item,
    required this.state,
    required this.notifier,
    required this.isDarkMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final primaryText = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final iconBg = isDarkMode
        ? AppColors.iconBackgroundDark
        : AppColors.iconBackgroundLight;
    final dangerColor = isDarkMode ? AppColors.errorDark : AppColors.errorLight;

    final rowColor = item.isDanger
        ? dangerColor
        : (isDarkMode ? AppColors.textLight : AppColors.primaryBlue);

    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: 14,
        ),
        child: Row(
          children: [
            // ── Icon bubble ──
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.isDanger
                    ? dangerColor.withValues(alpha: 0.1)
                    : iconBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              alignment: Alignment.center,
              child: Icon(item.icon, size: 18, color: rowColor),
            ),
            const SizedBox(width: 14),

            // ── Title + subtitle ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: item.isDanger ? dangerColor : primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textSubtleLight
                            : AppColors.textSubtleDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Trailing: toggle or arrow ──
            _MenuRowTrailing(
              item: item,
              state: state,
              notifier: notifier,
              isDarkMode: isDarkMode,
              ref: ref,
            ),
          ],
        ),
      ),
    );
  }
}

/// The trailing widget for a menu row — either a toggle switch or a caret icon.
class _MenuRowTrailing extends StatelessWidget {
  final ProfileMenuItem item;
  final ProfileState state;
  final ProfileViewModel notifier;
  final bool isDarkMode;
  final WidgetRef ref;

  const _MenuRowTrailing({
    required this.item,
    required this.state,
    required this.notifier,
    required this.isDarkMode,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    if (!item.showArrow) {
      return _buildToggle();
    }
    return Icon(
      PhosphorIconsRegular.caretRight,
      size: 16,
      color: isDarkMode ? AppColors.textSubtleLight : AppColors.textSubtleDark,
    );
  }

  Widget _buildToggle() {
    bool value;
    void Function(bool) onChanged;

    if (item.icon == PhosphorIconsRegular.moon) {
      value = isDarkMode;
      onChanged = (v) => notifier.toggleDarkMode(v, ref);
    } else if (item.icon == PhosphorIconsRegular.bell) {
      value = state.notificationsEnabled;
      onChanged = notifier.toggleNotifications;
    } else if (item.icon == PhosphorIconsRegular.fingerprint) {
      value = state.biometricEnabled;
      onChanged = notifier.toggleBiometric;
    } else {
      // Danger row (logout) — no trailing widget
      return const SizedBox.shrink();
    }

    return Switch.adaptive(
      value: value,
      activeTrackColor: AppColors.primaryBlue,
      onChanged: onChanged,
    );
  }
}

/// A subtle horizontal divider between menu rows.
class _RowDivider extends StatelessWidget {
  final bool isDarkMode;

  const _RowDivider({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: isDarkMode
            ? AppColors.inputBorderDark
            : AppColors.inputBorderLight,
      ),
    );
  }
}
