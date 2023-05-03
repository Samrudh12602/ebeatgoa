import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  String? circleDocId;
  late Marker _currentLocationMarker = Marker(
    markerId: MarkerId('CurrentLocation'),
    infoWindow: InfoWindow(
      title: 'You',
    ),
    position: LatLng(0, 0),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    zIndex: 2,
  );
  late LatLng _currentLocation = LatLng(0, 0);
  bool _isWithinCircle = false;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();

  @override
  void initState() {
    super.initState();
    _getBeatLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _currentLocation, zoom: 15),
            markers: Set<Marker>.of(_markers..add(_currentLocationMarker)),
            circles: Set<Circle>.of(_circles),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _getLocation();
            },
          ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _checkIfWithinCircle();
              },
              child: Icon(Icons.upload),
            ),
          ),
        ],
      ),
    );
  }

  StreamSubscription<Position>? _positionStreamSubscription;
  void _startListening() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _currentLocationMarker =
            _currentLocationMarker.copyWith(positionParam: _currentLocation);
        _controller.animateCamera(
          CameraUpdate.newLatLng(_currentLocation),
        );
      });
    });
  }

  void _stopListening() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription?.cancel();
    }
  }

  void _getLocation() {
    _startListening();
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Upload image to Firebase Storage
      final file = File(pickedFile.path);
      final fileName = DateTime.now().toString() + '.jpg';
      final ref =
          FirebaseStorage.instance.ref().child('images').child(fileName);
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();

      // Add new collection to Firestore
      final beatLocations = FirebaseFirestore.instance
          .collection('BeatLocations')
          .doc(circleDocId);
      await beatLocations.collection('Images').add({
        'ImageUrl': imageUrl,
        'Timestamp': Timestamp.now(),
      });
    }
  }

  void _checkIfWithinCircle() async {
    bool isWithinCircle = false;

    for (var circle in _circles) {
      if (Geolocator.distanceBetween(
              _currentLocation.latitude,
              _currentLocation.longitude,
              circle.center.latitude,
              circle.center.longitude) <=
          circle.radius) {
        isWithinCircle = true;
        circleDocId = circle.circleId.value;
        break;
      }
    }
    setState(() {
      _isWithinCircle = isWithinCircle;
    });
    if (_isWithinCircle) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Within circle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Your current location is within one of the circles.'),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _uploadImage();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.upload),
                  label: Text('Upload'),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Outside circle'),
            content: Text('Your current location is outside all the circles.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Go back'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getBeatLocations() async {
    // Retrieve data from Firestore
    CollectionReference beatLocations =
        FirebaseFirestore.instance.collection('BeatLocations');
    QuerySnapshot querySnapshot = await beatLocations.get();

    // Create new sets of markers and circles that includes all existing ones
    Set<Marker> allMarkers = Set<Marker>();
    Set<Circle> allCircles = Set<Circle>();

    // Add existing markers and circles to sets
    querySnapshot.docs.forEach((doc) {
      LatLng markerLatLng = LatLng(
          doc['markerPosition'].latitude, doc['markerPosition'].longitude);

      Marker marker = Marker(
        markerId: MarkerId(doc.id),
        position: markerLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: doc['markerName']),
      );
      allMarkers.add(marker);

      final random = Random();
      final color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
      Circle circle = Circle(
        circleId: CircleId(doc.id),
        center:
            LatLng(doc['circleCenter'].latitude, doc['circleCenter'].longitude),
        radius: doc['circleRadius'],
        strokeWidth: 2,
        strokeColor: Colors.red,
        fillColor: color.withOpacity(0.1), // Use the random color here
      );
      allCircles.add(circle);
    });

    // Update the sets of markers and circles
    setState(() {
      _markers = allMarkers;
      _circles = allCircles;
    });
  }
}
