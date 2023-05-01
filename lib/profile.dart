import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String name;
  final String designation;
  final String policeStation;
  final String photoUrl;

  Profile({
    required this.name,
    required this.designation,
    required this.policeStation,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(photoUrl),
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              designation,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              policeStation,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
