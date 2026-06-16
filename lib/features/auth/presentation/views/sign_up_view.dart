import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme_toggle_button.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../widgets/adaptive_auth_background.dart';
import '../widgets/auth_heading_text.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/auth_subheading_text.dart';
import '../widgets/google_auth_button.dart';
import 'phone_input_view.dart';

/// A view that provides the user with the initial sign-up options.
class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ThemeToggleButton(),
          SizedBox(width: AppDimensions.paddingMedium),
        ],
      ),
      body: AdaptiveAuthBackground(
        child: Padding(
          padding: AppDimensions.horizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              _IntroText(),
              Spacer(flex: 3),
              _AuthActions(),
              SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHeadingText(text: 'Join Sedi Pay Today.')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: AppDimensions.paddingMedium),
        AuthSubheadingText(
              text:
                  'The ultimate one-stop shop to power your day—instantly buy cheap data, airtime, electricity, educational pins, and fund betting wallets in seconds.',
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }
}

class _AuthActions extends StatelessWidget {
  const _AuthActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GoogleAuthButton(
              label: 'Sign up with Google',
              onPressed: () => _handleSignUp(context),
              isPrimary: true,
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: AppDimensions.paddingLarge),
        AuthNavigationLink(
          text: 'Already have an account?',
          actionText: 'Sign in',
          onPressed: () => _navigateToSignIn(context),
        ).animate().fadeIn(
          duration: 600.ms,
          delay: 600.ms,
          curve: Curves.easeOutQuad,
        ),
      ],
    );
  }

  void _handleSignUp(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PhoneInputView()));
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).pop();
  }
}
