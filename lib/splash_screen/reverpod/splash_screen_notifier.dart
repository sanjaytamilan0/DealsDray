import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../login_screen/login_screen.dart';

// Define the states
class DeviceState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  DeviceState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  factory DeviceState.initial() {
    return DeviceState(isLoading: false, isSuccess: false);
  }

  DeviceState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}

// Define the StateNotifier class
class DeviceNotifier extends StateNotifier<DeviceState> {
  DeviceNotifier() : super(DeviceState.initial());

  Future<void> registerDevice(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "deviceType": "android",
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to add device',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown error')),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred',
      );
    }
  }
}

final deviceNotifierProvider = StateNotifierProvider<DeviceNotifier, DeviceState>((ref) {
  return DeviceNotifier();
});
