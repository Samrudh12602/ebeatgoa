import 'package:EbeatGoa/addMarker.dart';
import 'package:EbeatGoa/livelocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'markingBeatAreas.dart';
import 'dataview.dart';
import 'profile.dart';
import 'about_us.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _profileImageUrl = '';
  String _name = '';
  String _postOfWork = '';
  final List<Widget> _children = [
    Home(),
    MapScreen(),
    UserMap(),
    BeatLocations(),
    AboutUs(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // fetch user data when the widget is initialized
  }

  Future<void> _fetchUserData() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await doc.get();
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          _name = data['name'] ?? '';
          _postOfWork = data['postOfWork'] ?? '';
          _profileImageUrl = data['profileImageUrl'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Goa Police'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_name ?? ''), // display name
              accountEmail: Text(_postOfWork ?? ''), // display postOfWork
              currentAccountPicture: CircleAvatar(
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl)
                    : null, // display profile image
              ),
            ),
            ListTile(
              leading: Icon(Icons.public),
              title: Text('Goa Police Website'),
              onTap: () {
                // Handle website click
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Message Admin'),
              onTap: () {
                // Handle message click
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Developers'),
              onTap: () {
                // Handle contact click
              },
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'View Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to the Goa Police App Home Page',
        style: TextStyle(
          color: Colors.green,
          fontSize: 24.0,
        ),
      ),
    );
  }
}
