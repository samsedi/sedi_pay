import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'passcode_state.dart';

class PasscodeViewModel extends StateNotifier<PasscodeState> {
  static const int maxPinLength = 4;
  static const String correctPin = '1234';

  PasscodeViewModel() : super(const PasscodeState());

  void addDigit(String digit) {
    if (state.isLoading || state.pin.length >= maxPinLength) return;

    final newPin = state.pin + digit;
    state = state.copyWith(pin: newPin, clearError: true, isError: false);

    if (newPin.length == maxPinLength) {
      _verifyPin(newPin);
    }
  }

  void removeDigit() {
    if (state.isLoading || state.pin.isEmpty) return;

    state = state.copyWith(
      pin: state.pin.substring(0, state.pin.length - 1),
      clearError: true,
      isError: false,
    );
  }

  Future<void> _verifyPin(String pin) async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (pin == correctPin) {
      // Success will be handled by the UI observing the state
      state = state.copyWith(isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: 'Incorrect PIN',
        pin: '', // Auto-clear on error
      );
    }
  }
}

final passcodeProvider =
    StateNotifierProvider<PasscodeViewModel, PasscodeState>((ref) {
  return PasscodeViewModel();
});
