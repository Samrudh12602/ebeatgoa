import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _registerWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // If register succeeds, navigate to home page.
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'contactNumber': _contactNumberController.text.trim(),
      });
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Show an error message if the password is too weak.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('The password provided is too weak.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        // Show an error message if the email is already in use.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('The account already exists for that email.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                ),
              ],
            );
          },
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
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
                  'Create an account',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                _buildTextField('Email', Icons.email, _emailController),
                SizedBox(height: 20.0),
                _buildTextField(
                    'Contact Number', Icons.phone, _contactNumberController),
                SizedBox(height: 20.0),
                _buildTextField(
                    'Confirm Password', Icons.lock, _confirmPasswordController,
                    isObscure: true),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _registerWithEmailAndPassword,
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green[800]!),
                  ),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text(
                    'Already have an account? Login here.',
                    style: TextStyle(color: Colors.green[800], fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, IconData prefixIcon, TextEditingController controller,
      {bool isObscure = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: isObscure,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
