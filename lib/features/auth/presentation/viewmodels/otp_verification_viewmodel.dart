import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationState {
  final String otp;
  final bool isError;
  final bool isSuccess;

  OtpVerificationState({
    this.otp = '',
    this.isError = false,
    this.isSuccess = false,
  });

  OtpVerificationState copyWith({
    String? otp,
    bool? isError,
    bool? isSuccess,
  }) {
    return OtpVerificationState(
      otp: otp ?? this.otp,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final otpVerificationViewModelProvider =
    StateNotifierProvider<OtpVerificationViewModel, OtpVerificationState>((ref) {
  return OtpVerificationViewModel();
});

class OtpVerificationViewModel extends StateNotifier<OtpVerificationState> {
  static const int requiredLength = 4;

  OtpVerificationViewModel() : super(OtpVerificationState());

  void addDigit(String digit) {
    if (_isOtpFull()) return;
    
    _appendDigitToState(digit);
    _clearAnyExistingErrors();
    _initiateVerificationIfComplete();
  }

  void removeLastDigit() {
    if (_isOtpEmpty()) return;
    
    _removeLastDigitFromState();
    _clearAnyExistingErrors();
  }

  void reset() {
    state = OtpVerificationState();
  }

  // --- Private Helper Methods ---

  bool _isOtpFull() {
    return state.otp.length >= requiredLength;
  }

  bool _isOtpEmpty() {
    return state.otp.isEmpty;
  }

  void _appendDigitToState(String digit) {
    state = state.copyWith(otp: state.otp + digit);
  }

  void _removeLastDigitFromState() {
    state = state.copyWith(otp: state.otp.substring(0, state.otp.length - 1));
  }

  void _clearAnyExistingErrors() {
    if (state.isError) {
      state = state.copyWith(isError: false);
    }
  }

  void _initiateVerificationIfComplete() {
    if (_isOtpFull()) {
      _verifyOtp(state.otp);
    }
  }

  void _verifyOtp(String otp) async {
    await _simulateNetworkDelay();
    _validateOtp(otp);
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  void _validateOtp(String otp) {
    if (_isCorrectOtp(otp)) {
      _markVerificationAsSuccess();
    } else {
      _markVerificationAsError();
    }
  }

  bool _isCorrectOtp(String otp) {
    return otp == '1234';
  }

  void _markVerificationAsSuccess() {
    state = state.copyWith(isSuccess: true);
  }

  void _markVerificationAsError() {
    state = state.copyWith(isError: true, otp: '');
  }
}
