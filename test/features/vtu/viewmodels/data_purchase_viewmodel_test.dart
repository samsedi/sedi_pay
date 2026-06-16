import 'package:flutter_test/flutter_test.dart';
import 'package:sedi_pay/features/vtu/presentation/viewmodels/data_purchase_viewmodel.dart';

void main() {
  group('DataPurchaseViewModel', () {
    late DataPurchaseViewModel viewModel;

    setUp(() {
      viewModel = DataPurchaseViewModel();
    });

    test('initial state is default', () {
      expect(viewModel.state.phoneNumber, '');
      expect(viewModel.state.networkProvider, '');
      expect(viewModel.state.selectedPlan, null);
      expect(viewModel.state.errorMessage, null);
      expect(viewModel.state.availablePlans.isNotEmpty, true);
    });

    test('updatePhoneNumber saves phone and auto-detects network', () {
      viewModel.updatePhoneNumber('0803123');
      expect(viewModel.state.phoneNumber, '0803123');
      expect(viewModel.state.networkProvider, 'MTN');
    });

    test('updateNetworkProvider sets network manually and clears error', () {
      viewModel.updateNetworkProvider('Glo');
      expect(viewModel.state.networkProvider, 'Glo');
      expect(viewModel.state.errorMessage, null);
    });

    test('selectDataPlan selects a plan and clears error', () {
      final plan = viewModel.state.availablePlans.first;
      viewModel.selectDataPlan(plan);
      expect(viewModel.state.selectedPlan, plan);
      expect(viewModel.state.errorMessage, null);
    });

    test('selectDataPlan toggles selection if same plan is tapped again', () {
      final plan = viewModel.state.availablePlans.first;
      viewModel.selectDataPlan(plan); // Select
      expect(viewModel.state.selectedPlan, plan);
      
      viewModel.selectDataPlan(plan); // Deselect
      expect(viewModel.state.selectedPlan, null);
    });

    test('isValidTransaction returns true for valid input', () {
      viewModel.updatePhoneNumber('08031234567');
      viewModel.updateNetworkProvider('MTN');
      viewModel.selectDataPlan(viewModel.state.availablePlans.first);

      expect(viewModel.isValidTransaction(50000.0), true);
    });

    test('validateAndSetError sets error for invalid phone number', () {
      viewModel.updatePhoneNumber('0803');
      viewModel.updateNetworkProvider('MTN');
      viewModel.selectDataPlan(viewModel.state.availablePlans.first);

      final isValid = viewModel.validateAndSetError(50000.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Please enter a valid 11-digit phone number');
    });

    test('validateAndSetError sets error for missing data plan', () {
      viewModel.updatePhoneNumber('08031234567');
      viewModel.updateNetworkProvider('MTN');
      // No plan selected

      final isValid = viewModel.validateAndSetError(50000.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Please select a data plan');
    });

    test('validateAndSetError sets error for insufficient balance', () {
      viewModel.updatePhoneNumber('08031234567');
      viewModel.updateNetworkProvider('MTN');
      
      // Select a plan that costs more than 10.0
      final expensivePlan = viewModel.state.availablePlans.last;
      viewModel.selectDataPlan(expensivePlan);

      final isValid = viewModel.validateAndSetError(10.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Insufficient wallet balance');
    });
  });
}
