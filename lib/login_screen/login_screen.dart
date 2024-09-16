import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskproject/otp_screen/otp_screen.dart';

import '../otp_screen/reverpod/otp_notifier.dart';
import '../register_screen/register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isPhoneSelected = true;
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final otpSend = ref.watch(SendOtpProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          }
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/icon.png',
                width: 150,
                height: 75,
              ),
              const SizedBox(height: 30),
              ToggleButtons(
                isSelected: [isPhoneSelected, !isPhoneSelected],
                onPressed: (index) {
                  setState(() {
                    isPhoneSelected = index == 0;
                  });
                },
                borderRadius: BorderRadius.circular(30),
                selectedColor: Colors.white,
                fillColor: Colors.red,
                color: Colors.red,
                selectedBorderColor: Colors.red,
                borderColor: Colors.red,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Phone'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Email'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Glad to see you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                isPhoneSelected
                    ? 'Please provide your phone number'
                    : 'Please provide your email address',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: isPhoneSelected ? 'Phone' : 'Email',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: isPhoneSelected
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                inputFormatters: isPhoneSelected
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                ),
                onPressed: () {
                  ref.read(SendOtpProvider.notifier).sendOtp();
                  if(otpSend.isOtpSent){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OTPVerificationScreen(phoneNumber: '9011470243'),
                      ),
                    );
                  }else if(otpSend.error != null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  }

                },
                child:otpSend.isLoading?
                const CircularProgressIndicator():
                Text(isPhoneSelected ? 'SEND CODE' : 'CONTINUE',style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
