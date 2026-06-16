import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider manages the application's current theme state
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
