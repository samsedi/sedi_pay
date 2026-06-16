import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/nigerian_network_detector.dart';
import 'airtime_state.dart';

export 'airtime_state.dart';

/// ViewModel managing all business logic for the airtime purchase flow.
class AirtimeViewModel extends StateNotifier<AirtimeState> {
  static const double mockWalletBalance = 15000.00;
  static const List<double> presetAmounts = [100.0, 200.0, 500.0, 1000.0];

  AirtimeViewModel() : super(const AirtimeState());

  // ── Public Methods ────────────────────────────────────────────────────────

  void updatePhoneNumber(String number) {
    _savePhoneAndNetwork(number);

    if (number.length == 11) {
      _triggerNameResolution(number);
    } else if (number.length < 11 && state.resolvedName.isNotEmpty) {
      _clearResolvedName();
    }
  }

  void updateNetworkProvider(String provider) {
    state = state.copyWith(networkProvider: provider, clearError: true);
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  /// Query to check if the current form is valid.
  bool isValidTransaction(double walletBalance) {
    return _firstValidationError(walletBalance) == null;
  }

  /// Command to execute validation and set the error message if invalid.
  /// Returns true if valid, false if an error was set.
  bool validateAndSetError(double walletBalance) {
    final error = _firstValidationError(walletBalance);
    if (error != null) {
      _setValidationError(error);
      return false;
    }
    return true;
  }

  // ── Private Helpers ───────────────────────────────────────────────────────

  void _savePhoneAndNetwork(String number) {
    final detectedProvider = NigerianNetworkDetector.detect(number);
    state = state.copyWith(
      phoneNumber: number,
      networkProvider: detectedProvider,
      clearError: true,
    );
  }

  void _clearResolvedName() {
    state = state.copyWith(resolvedName: '');
  }

  Future<void> _triggerNameResolution(String number) async {
    state = state.copyWith(isLoadingName: true);

    try {
      // TODO(dev): Replace with real NCC subscriber lookup UseCase
      await Future.delayed(const Duration(milliseconds: 1200));
      
      final resolvedName = number.endsWith('00') ? 'Precious Adebayo' : 'Sedi Samuel';
      state = state.copyWith(resolvedName: resolvedName, isLoadingName: false);
    } catch (e) {
      // In a real app, you might log the error and let the user proceed anyway
      // since name resolution is often just a convenience, not a blocker.
      state = state.copyWith(isLoadingName: false);
    }
  }

  String? _firstValidationError(double walletBalance) {
    if (state.phoneNumber.length != 11) {
      return 'Please enter a valid 11-digit phone number';
    }
    if (state.networkProvider.isEmpty) {
      return 'Could not detect network provider';
    }
    if (state.amount < 50) {
      return 'Minimum airtime amount is ₦50';
    }
    if (state.amount > walletBalance) {
      return 'Insufficient wallet balance';
    }
    return null;
  }

  void _setValidationError(String message) {
    state = state.copyWith(errorMessage: message);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final airtimeProvider = StateNotifierProvider<AirtimeViewModel, AirtimeState>(
  (ref) => AirtimeViewModel(),
);
