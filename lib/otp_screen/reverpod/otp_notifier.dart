import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SendOtpState {
  final bool isLoading;
  final String? error;
  final bool isOtpSent;
  final bool isOtpVerified;

  SendOtpState({
    required this.isLoading,
    this.error,
    this.isOtpSent = false,
    this.isOtpVerified = false,
  });

  SendOtpState copyWith({
    bool? isLoading,
    String? error,
    bool? isOtpSent,
    bool? isOtpVerified,
  }) {
    return SendOtpState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
    );
  }
}

class SendOtpNotifier extends StateNotifier<SendOtpState> {
  SendOtpNotifier() : super(SendOtpState(isLoading: false));

  // Method to send OTP
  Future<void> sendOtp() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "mobileNumber": "9011470243",
          "deviceId": "62b341aeb0ab5ebe28a758a3"
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        state = state.copyWith(isOtpSent: true);
      } else {
        state = state.copyWith(error: 'OTP sending failed.');
      }
    } catch (e) {
      state = state.copyWith(error: 'An error occurred.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> verifyOtp() async {
    state = state.copyWith(isLoading: true);


    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification'),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(
          {
            "otp":"9879",
            "deviceId":"62b43472c84bb6dac82e0504",
            "userId":"62b43547c84bb6dac82e0525"
          }
        ),
      );
      print("+++++++${response.statusCode}");
      if (response.statusCode == 200) {
        state = state.copyWith(isOtpVerified: true);
      } else {
        state = state.copyWith(error: 'OTP verification failed.');
      }
    } catch (e) {
      state = state.copyWith(error: 'An error occurred during OTP verification.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final SendOtpProvider = StateNotifierProvider<SendOtpNotifier, SendOtpState>(
      (ref) => SendOtpNotifier(),
);
