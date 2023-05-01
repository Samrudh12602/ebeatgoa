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
    Home(
      numBeatOfficers: 10,
      numBeatLocations: 5,
      numPoliceInspectors: 3,
      numSuperintendents: 1,
    ),
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
  final int numBeatOfficers;
  final int numBeatLocations;
  final int numPoliceInspectors;
  final int numSuperintendents;

  Home({
    required this.numBeatOfficers,
    required this.numBeatLocations,
    required this.numPoliceInspectors,
    required this.numSuperintendents,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Text(
              'Welcome to the Goa Police App Home Page',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                _buildCard(
                  'Beat Officers',
                  numBeatOfficers.toString(),
                  Colors.blue,
                  Icons.people,
                ),
                _buildCard(
                  'Beat Locations',
                  numBeatLocations.toString(),
                  Colors.orange,
                  Icons.location_on,
                ),
                _buildCard(
                  'Police Inspectors',
                  numPoliceInspectors.toString(),
                  Colors.pink,
                  Icons.security,
                ),
                _buildCard(
                  'Superintendents',
                  numSuperintendents.toString(),
                  Colors.green,
                  Icons.assignment_ind,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40.0,
          ),
          SizedBox(height: 20.0),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          SizedBox(height: 10.0),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}
