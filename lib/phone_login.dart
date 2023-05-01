import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'verify_otp.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool _isLoading = false;

  Future<void> _signInWithPhone() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorDialog('Error', 'User is null');
        }
      };

      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException e) {
        _showErrorDialog('Error', e.message!);
      };

      final PhoneCodeSent codeSent =
          (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        _navigateToOTPScreen();
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + _phoneController.text.trim(),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      _showErrorDialog('Error', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToOTPScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VerifyOTPScreen(
          verificationId: _verificationId!,
          phoneController: _phoneController,
        ),
      ),
    );
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
        title: Text('Phone Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/goa_police_logo.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child:
                  _isLoading ? CircularProgressIndicator() : Text('Send OTP'),
              onPressed: _signInWithPhone,
            ),
          ],
        ),
      ),
    );
  }
}
