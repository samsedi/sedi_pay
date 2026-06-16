import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents an individual item within a profile menu group.
class ProfileMenuItem extends Equatable {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final bool isDanger;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.showArrow = true,
    this.isDanger = false,
    this.onTap,
  });

  @override
  List<Object?> get props => [icon, title, subtitle, showArrow, isDanger];
}

/// Represents a section or group of profile menu items.
class ProfileMenuGroup extends Equatable {
  final String heading;
  final List<ProfileMenuItem> items;

  const ProfileMenuGroup({required this.heading, required this.items});

  @override
  List<Object?> get props => [heading, items];
}

/// Represents the state of the user's profile, containing personal information
/// and preferences.
class ProfileState extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String accountTier;
  final String memberSince;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;

  const ProfileState({
    this.fullName = 'Sedi Samuel',
    this.email = 'sedi@example.com',
    this.phoneNumber = '0812 345 6789',
    this.accountTier = 'Tier 1',
    this.memberSince = 'June 2024',
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
  });

  /// The user's initials, used in the avatar.
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? accountTier,
    String? memberSince,
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? biometricEnabled,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountTier: accountTier ?? this.accountTier,
      memberSince: memberSince ?? this.memberSince,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        phoneNumber,
        accountTier,
        memberSince,
        isDarkMode,
        notificationsEnabled,
        biometricEnabled,
      ];
}
