import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneInputViewModelProvider =
    StateNotifierProvider<PhoneInputViewModel, String>((ref) {
  return PhoneInputViewModel();
});

class PhoneInputViewModel extends StateNotifier<String> {
  PhoneInputViewModel() : super('');

  void updatePhoneNumber(String number) {
    state = number;
  }

  bool get isValid => state.length == 11;
}
