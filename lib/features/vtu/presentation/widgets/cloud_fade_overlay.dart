import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

/// A reusable cloud/fade gradient overlay for scrollable views.
///
/// The gradient fades from fully transparent at the top to the scaffold colour
/// at the bottom, giving a "cloud" effect that softens the nav-bar cut-off.
///
/// [fadeStop] controls how far down (0.0–1.0) the colour becomes mostly opaque.
/// A higher value keeps the overlay transparent for longer (softer fade).
/// Defaults to 0.55 (the original behaviour for data / airtime screens).
///
/// [maxOpacity] is the opacity at the final stop. Defaults to 1.0 (fully opaque).
class CloudFadeOverlay extends StatelessWidget {
  final double fadeStop;
  final double maxOpacity;

  const CloudFadeOverlay({
    super.key,
    this.fadeStop = 0.55,
    this.maxOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldColor =
        isDarkMode ? AppColors.darkScaffold : AppColors.lightScaffold;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 160,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, fadeStop, 1.0],
              colors: [
                scaffoldColor.withValues(alpha: 0.0),
                scaffoldColor.withValues(alpha: maxOpacity * 0.85),
                scaffoldColor.withValues(alpha: maxOpacity),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
