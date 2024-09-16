import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class RegistrationState {
  final bool isLoading;
  final String? error;

  RegistrationState({
    required this.isLoading,
    this.error,
  });

  RegistrationState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState(isLoading: false));

  Future<void> register(String email, String password, String referralCode) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral'),
        headers : {'Content-Type': 'application/json'},
        body:jsonEncode({
          'email': email,
          'password': password,
          'referral_code': referralCode,
        }) ,
      );

      if (response.statusCode == 200) {
        // Handle successful registration
      } else {
        // Handle registration error
        state = state.copyWith(error: 'Registration failed.');
      }
    } catch (e) {
      state = state.copyWith(error: 'An error occurred.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final registrationProvider = StateNotifierProvider<RegistrationNotifier, RegistrationState>(
      (ref) => RegistrationNotifier(),
);
