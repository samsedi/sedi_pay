/// State class representing the current form data for the airtime purchase flow.
///
/// Kept separate from [AirtimeViewModel] so the state contract can be read
/// and tested independently of business logic.
class AirtimeState {
  final String phoneNumber;

  /// The detected or manually selected network provider (MTN, Airtel, Glo, 9mobile).
  final String networkProvider;

  final double amount;

  /// The NIN/NCC-resolved subscriber name for the entered phone number.
  final String resolvedName;

  /// True while the name-resolution API call is in-flight.
  final bool isLoadingName;

  /// Non-null when there is a user-facing validation or transaction error.
  final String? errorMessage;

  const AirtimeState({
    this.phoneNumber = '',
    this.networkProvider = '',
    this.amount = 0.0,
    this.resolvedName = '',
    this.isLoadingName = false,
    this.errorMessage,
  });

  AirtimeState copyWith({
    String? phoneNumber,
    String? networkProvider,
    double? amount,
    String? resolvedName,
    bool? isLoadingName,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AirtimeState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      networkProvider: networkProvider ?? this.networkProvider,
      amount: amount ?? this.amount,
      resolvedName: resolvedName ?? this.resolvedName,
      isLoadingName: isLoadingName ?? this.isLoadingName,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
