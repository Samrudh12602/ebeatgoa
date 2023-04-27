import 'package:flutter/material.dart';
import 'maps.dart';
import 'dataview.dart';
import 'profile.dart';
import 'about_us.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    MapScreen(),
    Profile(),
    ViewData(),
    AboutUs(),
  ];

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
              accountName: Text('John Doe'),
              accountEmail: Text('Inspector, Goa Police'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
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
