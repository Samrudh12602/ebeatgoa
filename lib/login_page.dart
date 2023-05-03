import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool _isLoading = false;

  Future<void> _signInWithEmailOrPhone() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_emailController.text.isNotEmpty) {
// Sign in with email and password.
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (userCredential.user != null) {
// If sign in succeeds, navigate to home page.
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorDialog('Error', 'User is null');
        }
      } else if (_phoneController.text.isNotEmpty) {
// Sign in with phone number and OTP.
        final PhoneVerificationCompleted verificationCompleted =
            (PhoneAuthCredential credential) async {
// Sign in the user with the auto-retrieved credential.
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
// If sign in succeeds, navigate to home page.
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
          // Save the verification ID and resend token so we can use them later
          _verificationId = verificationId;
          // Navigate to the OTP screen to enter the code
          _navigateToOTPScreen();
        };

        final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
            (String verificationId) {
          // Save the verification ID so we can use it later
          _verificationId = verificationId;
        };

        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneController.text.trim(),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        );
      } else {
        _showErrorDialog('Error', 'Please enter email or phone number');
      }
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16),
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
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
              onPressed: _signInWithEmailOrPhone,
            ),
            SizedBox(height: 16),
            TextButton(
              child: Text('Create an Account'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
