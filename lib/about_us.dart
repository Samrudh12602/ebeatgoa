import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the About Us Page',
        style: TextStyle(
          color: Colors.green,
          fontSize: 24.0,
        ),
      ),
    );
  }
}