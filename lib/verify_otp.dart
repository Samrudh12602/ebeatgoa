import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String verificationId;
  final TextEditingController phoneController;

  VerifyOTPScreen(
      {required this.verificationId, required this.phoneController});

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signInWithOTP() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog('Error', 'User is null');
      }
    } catch (e) {
      _showErrorDialog('Error', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/goa_police_logo.png',
                height: 200,
                width: 200,
              ),
              SizedBox(height: 30.0),
              Text(
                'Enter OTP sent to ${widget.phoneController.text}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithOTP,
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
