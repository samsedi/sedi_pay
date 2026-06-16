import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme_provider.dart';
import 'profile_state.dart';

// ── ViewModel ─────────────────────────────────────────────────────────────────

/// Owns all business logic for the Profile screen.
///
/// All user preference mutations go through this class.
/// In production each setting would be persisted via a dedicated UseCase.
class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  void toggleDarkMode(bool value, WidgetRef ref) {
    ref.read(themeModeProvider.notifier).state =
        value ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(isDarkMode: value);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleBiometric(bool value) {
    state = state.copyWith(biometricEnabled: value);
  }

  /// Returns all menu groups shown in the profile settings list.
  List<ProfileMenuGroup> buildMenuGroups({
    required VoidCallback onEditProfile,
    required VoidCallback onSecurity,
    required VoidCallback onSupport,
    required VoidCallback onAbout,
    required VoidCallback onLogout,
  }) {
    return [
      ProfileMenuGroup(
        heading: 'Account',
        items: [
          ProfileMenuItem(
            icon: PhosphorIconsRegular.userCircle,
            title: 'Edit Profile',
            subtitle: 'Update your personal details',
            onTap: onEditProfile,
          ),
          ProfileMenuItem(
            icon: PhosphorIconsRegular.shieldCheck,
            title: 'Security',
            subtitle: 'PIN, password & 2FA',
            onTap: onSecurity,
          ),
          ProfileMenuItem(
            icon: PhosphorIconsRegular.wallet,
            title: 'Bank Accounts',
            subtitle: 'Linked bank accounts',
            onTap: () {},
          ),
        ],
      ),
      ProfileMenuGroup(
        heading: 'Preferences',
        items: [
          ProfileMenuItem(
            icon: PhosphorIconsRegular.bell,
            title: 'Notifications',
            subtitle: 'Push & email alerts',
            showArrow: false,
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: PhosphorIconsRegular.fingerprint,
            title: 'Biometric Login',
            subtitle: 'Face ID / Fingerprint',
            showArrow: false,
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: PhosphorIconsRegular.moon,
            title: 'Dark Mode',
            showArrow: false,
            onTap: () {},
          ),
        ],
      ),
      ProfileMenuGroup(
        heading: 'Support',
        items: [
          ProfileMenuItem(
            icon: PhosphorIconsRegular.headset,
            title: 'Help & Support',
            onTap: onSupport,
          ),
          ProfileMenuItem(
            icon: PhosphorIconsRegular.info,
            title: 'About SediPay',
            subtitle: 'Version 1.0.0',
            onTap: onAbout,
          ),
        ],
      ),
      ProfileMenuGroup(
        heading: 'Danger Zone',
        items: [
          ProfileMenuItem(
            icon: PhosphorIconsRegular.signOut,
            title: 'Log Out',
            isDanger: true,
            showArrow: false,
            onTap: onLogout,
          ),
        ],
      ),
    ];
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final profileProvider = NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);
