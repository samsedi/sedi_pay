import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme_toggle_button.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../viewmodels/phone_input_viewmodel.dart';
import '../widgets/adaptive_auth_background.dart';
import '../widgets/auth_heading_text.dart';
import '../widgets/auth_subheading_text.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';
import 'otp_verification_view.dart';

class PhoneInputView extends ConsumerStatefulWidget {
  const PhoneInputView({super.key});

  @override
  ConsumerState<PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends ConsumerState<PhoneInputView> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_handlePhoneTextChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_handlePhoneTextChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _handlePhoneTextChanged() {
    final text = _phoneController.text;
    _updateViewModel(text);
    _checkAndTriggerAutoNavigation(text);
  }

  void _updateViewModel(String text) {
    ref.read(phoneInputViewModelProvider.notifier).updatePhoneNumber(text);
  }

  void _checkAndTriggerAutoNavigation(String text) {
    if (_shouldAutoNavigate(text)) {
      _triggerAutoNavigation();
    } else if (_isLengthTooShort(text)) {
      _resetNavigationState();
    }
  }

  bool _shouldAutoNavigate(String text) {
    return text.length == 11 && !_isNavigating;
  }

  bool _isLengthTooShort(String text) {
    return text.length < 11;
  }

  void _triggerAutoNavigation() {
    _isNavigating = true;
    _navigateToOtp();
  }

  void _resetNavigationState() {
    _isNavigating = false;
  }

  void _navigateToOtp() {
    _dismissKeyboard();
    _pushOtpRoute().then(_onReturnFromOtp);
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _pushOtpRoute() {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtpVerificationView(
          phoneNumber: _phoneController.text,
        ),
      ),
    );
  }

  void _onReturnFromOtp(dynamic _) {
    _resetNavigationState();
  }

  void _handleContinuePressed(bool isValid) {
    if (isValid && !_isNavigating) {
      _triggerAutoNavigation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = ref.watch(phoneInputViewModelProvider.notifier).isValid;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const _PhoneInputAppBar(),
      body: AdaptiveAuthBackground(
        child: Padding(
          padding: AppDimensions.horizontalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              const _PhoneInputHeader(),
              const Spacer(flex: 1),
              _PhoneInputField(controller: _phoneController),
              const SizedBox(height: AppDimensions.paddingLarge),
              _PhoneInputSubmitButton(
                onPressed: () => _handleContinuePressed(isValid),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInputAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PhoneInputAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: const [
        ThemeToggleButton(),
        SizedBox(width: AppDimensions.paddingMedium),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PhoneInputHeader extends StatelessWidget {
  const _PhoneInputHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthHeadingText(text: 'Let\'s verify your number')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: AppDimensions.paddingMedium),
        const AuthSubheadingText(
          text: 'We will send a 4-digit code to verify it\'s you.',
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      hintText: 'Phone Number',
      keyboardType: TextInputType.phone,
      prefixIcon: PhosphorIconsRegular.phone,
      autoFocus: true,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOutQuad)
        .slideY(begin: 0.3, end: 0);
  }
}

class _PhoneInputSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PhoneInputSubmitButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryAuthButton(
      label: 'Continue',
      onPressed: onPressed,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms, curve: Curves.easeOutQuad);
  }
}
