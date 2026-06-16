import 'package:flutter/material.dart';

import 'auth_dark_background.dart';
import 'auth_light_background.dart';

class AdaptiveAuthBackground extends StatelessWidget {
  final Widget child;

  const AdaptiveAuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    if (isLightMode) {
      return AuthLightBackground(child: child);
    } else {
      return AuthDarkBackground(child: child);
    }
  }
}
