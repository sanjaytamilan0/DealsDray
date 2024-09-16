import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:taskproject/home_screen/home_screen.dart';
import 'package:taskproject/otp_screen/reverpod/otp_notifier.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _checkOtp();
    startTimer();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    autoFillOTP('9879'); // For testing; remove this in production
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void resendOTP() {
    setState(() {
      _secondsRemaining = 120;
    });
    startTimer();
  }

  String getEnteredOTP() {
    return _otpControllers.map((controller) => controller.text).join();
  }
  Future<void> _checkOtp() async {
  await Future.delayed(Duration.zero);
  ref.watch(SendOtpProvider.notifier).verifyOtp();
 }

  Future<void> verifyOTP() async {
    final otp = getEnteredOTP();
    if (otp.length == 4) {
      final sendOtpProvider = ref.watch(SendOtpProvider);

     await Future.delayed(const Duration(seconds:2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete OTP.')),
      );
    }
  }

  void autoFillOTP(String otp) {
    for (int i = 0; i < otp.length; i++) {
      _otpControllers[i].text = otp[i];
      if (i < _focusNodes.length - 1) {
        _focusNodes[i + 1].requestFocus();
      }
    }
    // Delay to ensure OTP is set before verification
    Future.delayed(const Duration(milliseconds: 500), () {
      verifyOTP();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.phone_android, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'We have sent a unique OTP number\nto your mobile +${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                    (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      }
                      if (index == 3 && value.isNotEmpty) {
                        verifyOTP();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: _secondsRemaining == 0 ? resendOTP : null,
                  child: Text(
                    'SEND AGAIN',
                    style: TextStyle(
                        color: _secondsRemaining == 0 ? Colors.red : Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
