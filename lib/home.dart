import 'package:EbeatGoa/addMarker.dart';
import 'package:EbeatGoa/livelocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'markingBeatAreas.dart';
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
      numBeatOfficers: 500,
      numBeatLocations: 400,
      numPoliceInspectors: 50,
      numSuperintendents: 3,
      numBeatAreas: 40,
      numSubDivisionalOfficers: 10,
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
        title: Text('Goa Police Homepage'),
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
  final int numBeatAreas;
  final int numSubDivisionalOfficers;

  Home({
    required this.numBeatOfficers,
    required this.numBeatLocations,
    required this.numPoliceInspectors,
    required this.numSuperintendents,
    required this.numBeatAreas,
    required this.numSubDivisionalOfficers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Goa Police App Home'),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: [
                  _buildCard(
                    'Beat Officers',
                    numBeatOfficers.toString(),
                    Colors.blue,
                  ),
                  _buildCard(
                    '     Beat\n'
                    ' Locations',
                    numBeatLocations.toString(),
                    Colors.red,
                  ),
                  _buildCard(
                    '    Police\n '
                    'Inspector',
                    numPoliceInspectors.toString(),
                    Colors.green,

                  ),
                  _buildCard(
                    'Superintendent',
                    numSuperintendents.toString(),
                    Colors.orange,
                  ),
                  _buildCard(
                    'Beat Areas',
                    numBeatAreas.toString(),
                    Colors.purple,
                  ),
                  _buildCard(
                    'Sub-Divisional\n '
                    '     Officers',
                    numSubDivisionalOfficers.toString(),
                    Colors.teal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, Color color) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
