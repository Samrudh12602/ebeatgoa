import 'package:EbeatGoa/home.dart';
import 'package:EbeatGoa/livelocation.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'login_page.dart';
import 'markingBeatAreas.dart';
import 'dataview.dart';
import 'about_us.dart';
import 'profile.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Beat Goa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.yellow,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/locationtracker': (context) => LocationTracker(),
        '/register': (context) => RegisterPage(),
        '/maps': (context) => MapScreen(),
        '/profile': (context) => Profile(),
        '/data': (context) => ViewData(),
        '/about': (context) => AboutUs(),
      },
    );
  }
}
