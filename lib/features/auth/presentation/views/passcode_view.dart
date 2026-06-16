import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_toggle_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../vtu/presentation/views/main_layout_view.dart';
import '../viewmodels/passcode_viewmodel.dart';
import '../widgets/adaptive_auth_background.dart';
import '../widgets/passcode_dots.dart';
import '../widgets/passcode_keypad.dart';

class PasscodeView extends ConsumerWidget {
  const PasscodeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passcodeProvider);
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    // Listen for successful PIN entry
    ref.listen(passcodeProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading && !next.isError) {
        // Success! Navigate to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayoutView()),
        );
      }
    });

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
            children: [
              const Spacer(flex: 3),
              Text(
                'Enter Passcode',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isLightMode ? AppColors.textDark : AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.isError
                    ? state.errorMessage ?? 'Incorrect PIN'
                    : 'Enter your 4-digit security PIN',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: state.isError
                      ? Colors.red
                      : (isLightMode
                            ? AppColors.textSubtleDark
                            : AppColors.textSubtleLightAlt),
                ),
              ),
              const SizedBox(height: 48),
              PasscodeDots(
                pinLength: state.pin.length,
                maxPinLength: PasscodeViewModel.maxPinLength,
                isError: state.isError,
              ),
              const SizedBox(height: 32),
              if (state.isLoading)
                const CircularProgressIndicator()
              else
                const SizedBox(height: 36),
              const Spacer(flex: 2),
              PasscodeKeypad(
                onDigitPressed: (digit) {
                  ref.read(passcodeProvider.notifier).addDigit(digit);
                },
                onBackspacePressed: () {
                  ref.read(passcodeProvider.notifier).removeDigit();
                },
                onBiometricsPressed: () {},
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
