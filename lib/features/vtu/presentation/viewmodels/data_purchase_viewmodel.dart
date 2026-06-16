import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/nigerian_network_detector.dart';

// ── Category Enum ─────────────────────────────────────────────────────────────

enum DataPlanCategory {
  sme,
  gift,
  socialPlans;

  String get label {
    switch (this) {
      case DataPlanCategory.sme:
        return 'SME';
      case DataPlanCategory.gift:
        return 'Gift';
      case DataPlanCategory.socialPlans:
        return 'Social Plans';
    }
  }
}

// ── Data Plan Model ───────────────────────────────────────────────────────────

class DataPlan extends Equatable {
  final String size;
  final String validity;
  final String displayPrice;
  final double priceValue;
  final DataPlanCategory category;

  const DataPlan({
    required this.size,
    required this.validity,
    required this.displayPrice,
    required this.priceValue,
    required this.category,
  });

  @override
  List<Object?> get props => [size, validity, displayPrice, priceValue, category];
}

// ── State ─────────────────────────────────────────────────────────────────────

class DataPurchaseState extends Equatable {
  final String phoneNumber;
  final String networkProvider;
  final DataPlan? selectedPlan;
  final List<DataPlan> availablePlans;
  final DataPlanCategory selectedCategory;
  final String resolvedName;
  final bool isLoadingName;
  final String? errorMessage;

  const DataPurchaseState({
    this.phoneNumber = '',
    this.networkProvider = '',
    this.selectedPlan,
    this.availablePlans = const [],
    this.selectedCategory = DataPlanCategory.sme,
    this.resolvedName = '',
    this.isLoadingName = false,
    this.errorMessage,
  });

  /// Plans filtered to the currently selected category.
  List<DataPlan> get filteredPlans =>
      availablePlans.where((p) => p.category == selectedCategory).toList();

  bool get canProceed =>
      phoneNumber.length == 11 &&
      networkProvider.isNotEmpty &&
      selectedPlan != null;

  DataPurchaseState copyWith({
    String? phoneNumber,
    String? networkProvider,
    DataPlan? selectedPlan,
    bool clearSelectedPlan = false,
    List<DataPlan>? availablePlans,
    DataPlanCategory? selectedCategory,
    String? resolvedName,
    bool? isLoadingName,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DataPurchaseState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      networkProvider: networkProvider ?? this.networkProvider,
      selectedPlan: clearSelectedPlan ? null : (selectedPlan ?? this.selectedPlan),
      availablePlans: availablePlans ?? this.availablePlans,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      resolvedName: resolvedName ?? this.resolvedName,
      isLoadingName: isLoadingName ?? this.isLoadingName,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        networkProvider,
        selectedPlan,
        availablePlans,
        selectedCategory,
        resolvedName,
        isLoadingName,
        errorMessage,
      ];
}

// ── Mock Data ─────────────────────────────────────────────────────────────────

const List<DataPlan> _mockDataPlans = [
  // ── SME ──
  DataPlan(size: '1.5GB',  validity: '30 Days', displayPrice: '₦1,000',  priceValue: 1000,  category: DataPlanCategory.sme),
  DataPlan(size: '2GB',    validity: '30 Days', displayPrice: '₦1,200',  priceValue: 1200,  category: DataPlanCategory.sme),
  DataPlan(size: '3GB',    validity: '30 Days', displayPrice: '₦1,500',  priceValue: 1500,  category: DataPlanCategory.sme),
  DataPlan(size: '5GB',    validity: '30 Days', displayPrice: '₦2,000',  priceValue: 2000,  category: DataPlanCategory.sme),
  DataPlan(size: '10GB',   validity: '30 Days', displayPrice: '₦3,000',  priceValue: 3000,  category: DataPlanCategory.sme),
  DataPlan(size: '20GB',   validity: '30 Days', displayPrice: '₦5,000',  priceValue: 5000,  category: DataPlanCategory.sme),
  DataPlan(size: '40GB',   validity: '30 Days', displayPrice: '₦10,000', priceValue: 10000, category: DataPlanCategory.sme),
  DataPlan(size: '75GB',   validity: '30 Days', displayPrice: '₦15,000', priceValue: 15000, category: DataPlanCategory.sme),

  // ── Gift ──
  DataPlan(size: '500MB',  validity: '7 Days',  displayPrice: '₦250',    priceValue: 250,   category: DataPlanCategory.gift),
  DataPlan(size: '1GB',    validity: '7 Days',  displayPrice: '₦500',    priceValue: 500,   category: DataPlanCategory.gift),
  DataPlan(size: '2GB',    validity: '14 Days', displayPrice: '₦800',    priceValue: 800,   category: DataPlanCategory.gift),
  DataPlan(size: '3GB',    validity: '30 Days', displayPrice: '₦1,100',  priceValue: 1100,  category: DataPlanCategory.gift),
  DataPlan(size: '5GB',    validity: '30 Days', displayPrice: '₦1,800',  priceValue: 1800,  category: DataPlanCategory.gift),

  // ── Social Plans ──
  DataPlan(size: '200MB',  validity: '3 Days',  displayPrice: '₦100',    priceValue: 100,   category: DataPlanCategory.socialPlans),
  DataPlan(size: '500MB',  validity: '7 Days',  displayPrice: '₦200',    priceValue: 200,   category: DataPlanCategory.socialPlans),
  DataPlan(size: '1GB',    validity: '14 Days', displayPrice: '₦350',    priceValue: 350,   category: DataPlanCategory.socialPlans),
  DataPlan(size: '2GB',    validity: '30 Days', displayPrice: '₦600',    priceValue: 600,   category: DataPlanCategory.socialPlans),
];

// ── ViewModel ─────────────────────────────────────────────────────────────────

class DataPurchaseViewModel extends StateNotifier<DataPurchaseState> {
  DataPurchaseViewModel()
      : super(const DataPurchaseState(availablePlans: _mockDataPlans));

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

  void updateCategory(DataPlanCategory category) {
    // Deselect the current plan when switching categories so the
    // selection cannot silently belong to a different category.
    state = state.copyWith(
      selectedCategory: category,
      clearSelectedPlan: true,
      clearError: true,
    );
  }

  void selectDataPlan(DataPlan plan) {
    if (state.selectedPlan == plan) {
      state = state.copyWith(clearSelectedPlan: true);
    } else {
      state = state.copyWith(selectedPlan: plan, clearError: true);
    }
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
      await Future.delayed(const Duration(milliseconds: 1200));
      final name = number.endsWith('00') ? 'Precious Adebayo' : 'Sedi Samuel';
      state = state.copyWith(resolvedName: name, isLoadingName: false);
    } catch (e) {
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
    if (state.selectedPlan == null) {
      return 'Please select a data plan';
    }
    if (state.selectedPlan!.priceValue > walletBalance) {
      return 'Insufficient wallet balance';
    }
    return null;
  }

  void _setValidationError(String message) {
    state = state.copyWith(errorMessage: message);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final dataPurchaseProvider =
    StateNotifierProvider<DataPurchaseViewModel, DataPurchaseState>(
  (ref) => DataPurchaseViewModel(),
);
