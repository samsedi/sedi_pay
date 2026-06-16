class PasscodeState {
  final String pin;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;

  const PasscodeState({
    this.pin = '',
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
  });

  PasscodeState copyWith({
    String? pin,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PasscodeState(
      pin: pin ?? this.pin,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
