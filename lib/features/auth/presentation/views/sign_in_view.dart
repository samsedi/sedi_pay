import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme_toggle_button.dart';
import '../../../../core/utils/app_dimensions.dart';
import 'passcode_view.dart';
import '../widgets/adaptive_auth_background.dart';
import '../widgets/auth_heading_text.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/auth_subheading_text.dart';
import '../widgets/google_auth_button.dart';
import 'sign_up_view.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: AppDimensions.paddingMedium),
        ],
      ),
      body: AdaptiveAuthBackground(
        child: Padding(
          padding: AppDimensions.horizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
        const AuthHeadingText(text: 'Instant Services.\nZero Friction.')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: AppDimensions.paddingMedium),
        const AuthSubheadingText(
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
          label: 'Sign in with Google',
          onPressed: () => _handleSignIn(context),
          isPrimary: true,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: AppDimensions.paddingLarge),
        AuthNavigationLink(
          text: "Don't have an account?",
          actionText: 'Sign up',
          onPressed: () => _navigateToSignUp(context),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 600.ms, curve: Curves.easeOutQuad),
      ],
    );
  }

  void _handleSignIn(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PasscodeView()),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpView()),
    );
  }
}
