import 'package:flutter_test/flutter_test.dart';
import 'package:sedi_pay/features/vtu/presentation/viewmodels/airtime_view_model.dart';

void main() {
  group('AirtimeViewModel', () {
    late AirtimeViewModel viewModel;

    setUp(() {
      viewModel = AirtimeViewModel();
    });

    test('initial state is default', () {
      expect(viewModel.state.phoneNumber, '');
      expect(viewModel.state.networkProvider, '');
      expect(viewModel.state.amount, 0.0);
      expect(viewModel.state.errorMessage, null);
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

    test('updateAmount sets the amount correctly', () {
      viewModel.updateAmount(500.0);
      expect(viewModel.state.amount, 500.0);
    });

    test('isValidTransaction returns true for valid input', () {
      viewModel.updatePhoneNumber('08031234567');
      viewModel.updateNetworkProvider('MTN');
      viewModel.updateAmount(500.0);

      expect(viewModel.isValidTransaction(1000.0), true);
    });

    test('validateAndSetError sets error for invalid phone number', () {
      viewModel.updatePhoneNumber('0803');
      viewModel.updateNetworkProvider('MTN');
      viewModel.updateAmount(500.0);

      final isValid = viewModel.validateAndSetError(1000.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Please enter a valid 11-digit phone number');
    });

    test('validateAndSetError sets error for empty network provider', () {
      viewModel.updatePhoneNumber('08041234567'); // Unknown prefix -> empty provider
      viewModel.updateAmount(500.0);

      final isValid = viewModel.validateAndSetError(1000.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Could not detect network provider');
    });

    test('validateAndSetError sets error for amount less than minimum', () {
      viewModel.updatePhoneNumber('08031234567');
      viewModel.updateNetworkProvider('MTN');
      viewModel.updateAmount(40.0);

      final isValid = viewModel.validateAndSetError(1000.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Minimum airtime amount is ₦50');
    });

    test('validateAndSetError sets error for insufficient balance', () {
      viewModel.updatePhoneNumber('08031234567');
      viewModel.updateNetworkProvider('MTN');
      viewModel.updateAmount(2000.0);

      final isValid = viewModel.validateAndSetError(1000.0);
      expect(isValid, false);
      expect(viewModel.state.errorMessage, 'Insufficient wallet balance');
    });
  });
}
