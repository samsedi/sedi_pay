import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_toggle_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../viewmodels/otp_verification_viewmodel.dart';
import '../widgets/adaptive_auth_background.dart';
import '../widgets/auth_heading_text.dart';
import '../widgets/auth_subheading_text.dart';
import '../widgets/passcode_dots.dart';
import '../widgets/passcode_keypad.dart';
import 'passcode_view.dart';

class OtpVerificationView extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationView({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpVerificationView> createState() =>
      _OtpVerificationViewState();
}

class _OtpVerificationViewState extends ConsumerState<OtpVerificationView> {
  Timer? _timer;
  int _secondsRemaining = 59;

  @override
  void initState() {
    super.initState();
    _scheduleViewModelReset();
    _startTimer();
  }

  void _scheduleViewModelReset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(otpVerificationViewModelProvider.notifier).reset();
    });
  }

  void _startTimer() {
    _resetTimerCountdown();
    _cancelActiveTimer();
    _beginPeriodicTimerTick();
  }

  void _resetTimerCountdown() {
    setState(() {
      _secondsRemaining = 59;
    });
  }

  void _cancelActiveTimer() {
    _timer?.cancel();
  }

  void _beginPeriodicTimerTick() {
    _timer = Timer.periodic(const Duration(seconds: 1), _handleTimerTick);
  }

  void _handleTimerTick(Timer timer) {
    if (!mounted) {
      _cancelActiveTimer();
      return;
    }
    
    if (_isTimerActive()) {
      _decrementTimer();
    } else {
      _cancelActiveTimer();
    }
  }

  bool _isTimerActive() {
    return _secondsRemaining > 0;
  }

  void _decrementTimer() {
    setState(() {
      _secondsRemaining--;
    });
  }

  @override
  void dispose() {
    _cancelActiveTimer();
    super.dispose();
  }

  void _handleSuccess() {
    Future.delayed(const Duration(milliseconds: 300), _navigateToPasscode);
  }

  void _navigateToPasscode() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PasscodeView()),
        (route) => false,
      );
    }
  }

  void _listenForVerificationSuccess() {
    ref.listen<OtpVerificationState>(otpVerificationViewModelProvider,
        (previous, current) {
      if (_justBecameSuccessful(previous, current)) {
        _handleSuccess();
      }
    });
  }

  bool _justBecameSuccessful(OtpVerificationState? previous, OtpVerificationState current) {
    return !(previous?.isSuccess ?? false) && current.isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    _listenForVerificationSuccess();

    final state = ref.watch(otpVerificationViewModelProvider);
    final notifier = ref.read(otpVerificationViewModelProvider.notifier);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const _OtpAppBar(),
      body: AdaptiveAuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              _OtpHeader(phoneNumber: widget.phoneNumber),
              const Spacer(flex: 1),
              _OtpDotsArea(state: state),
              _OtpErrorText(isError: state.isError),
              _OtpTimerOrResendButton(
                secondsRemaining: _secondsRemaining,
                isDarkMode: isDarkMode,
                onResendPressed: _startTimer,
              ),
              const Spacer(flex: 2),
              _OtpKeypadArea(notifier: notifier),
              const SizedBox(height: AppDimensions.paddingExtraLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _OtpAppBar();

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

class _OtpHeader extends StatelessWidget {
  final String phoneNumber;

  const _OtpHeader({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AuthHeadingText(text: 'Verify your code')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: AppDimensions.paddingMedium),
        AuthSubheadingText(text: 'We sent a 4-digit code to $phoneNumber')
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms, curve: Curves.easeOutQuad)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }
}

class _OtpDotsArea extends StatelessWidget {
  final OtpVerificationState state;

  const _OtpDotsArea({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return PasscodeDots(
      pinLength: state.otp.length,
      maxPinLength: OtpVerificationViewModel.requiredLength,
      isError: state.isError,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOutQuad)
        .slideY(begin: 0.3, end: 0);
  }
}

class _OtpErrorText extends StatelessWidget {
  final bool isError;

  const _OtpErrorText({super.key, required this.isError});

  @override
  Widget build(BuildContext context) {
    if (!isError) return const SizedBox(height: 38);

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: const Text(
        'Incorrect code. Please try again.',
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ).animate().fadeIn(),
    );
  }
}

class _OtpTimerOrResendButton extends StatelessWidget {
  final int secondsRemaining;
  final bool isDarkMode;
  final VoidCallback onResendPressed;

  const _OtpTimerOrResendButton({
    super.key,
    required this.secondsRemaining,
    required this.isDarkMode,
    required this.onResendPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (secondsRemaining > 0) {
      return _buildTimerText();
    } else {
      return _buildResendButton();
    }
  }

  Widget _buildTimerText() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        'Resend OTP in 0:${secondsRemaining.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: isDarkMode ? AppColors.textSubtleLight : AppColors.textSubtleDark,
          fontSize: 14,
        ),
      ).animate().fadeIn(),
    );
  }

  Widget _buildResendButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: TextButton(
        onPressed: onResendPressed,
        child: const Text(
          'Resend OTP',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ).animate().fadeIn(),
    );
  }
}

class _OtpKeypadArea extends StatelessWidget {
  final OtpVerificationViewModel notifier;

  const _OtpKeypadArea({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return PasscodeKeypad(
      onDigitPressed: notifier.addDigit,
      onBackspacePressed: notifier.removeLastDigit,
      onBiometricsPressed: null,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms, curve: Curves.easeOutQuad)
        .slideY(begin: 0.2, end: 0);
  }
}
