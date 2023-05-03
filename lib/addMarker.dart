import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class BeatLocations extends StatefulWidget {
  @override
  _BeatLocationsState createState() => _BeatLocationsState();
}

class _BeatLocationsState extends State<BeatLocations> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  String _markerName = '';
  String _circleName = '';
  LatLng _markerLatLng = LatLng(0, 0);

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(15.42478, 73.97977),
    zoom: 15,
  );

  Future<void> _createMarkerAndCircle() async {
    // Add Marker
    Marker marker = Marker(
      markerId: MarkerId('beat_location'),
      position: _markerLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: _markerName),
    );
    _markers.add(marker);
    String id = randomAlphaNumeric(10);
    // Add Circle
    Circle circle = Circle(
      circleId: CircleId(id),
      center: _markerLatLng,
      radius: 50.0,
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.1),
    );
    _circles.add(circle);

    // Upload Marker and Circle data to Firestore
    CollectionReference beatLocations =
        FirebaseFirestore.instance.collection('BeatLocations');
    await beatLocations.doc(_circleName).set({
      'markerName': _markerName,
      'circleName': _circleName,
      'markerPosition':
          GeoPoint(_markerLatLng.latitude, _markerLatLng.longitude),
      'circleCenter': GeoPoint(_markerLatLng.latitude, _markerLatLng.longitude),
      'circleRadius': 50.0,
    });
  }

  Future<void> _displayExistingMarkersWithCircles() async {
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

  @override
  void initState() {
    super.initState();
    _displayExistingMarkersWithCircles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
        circles: _circles,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (LatLng latLng) async {
          // add confirmatory marker
          await _addConfirmatoryMarker(latLng);

          // show alert dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Beat Location'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Marker Name'),
                      onChanged: (value) {
                        setState(() {
                          _markerName = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(labelText: 'Circle Name'),
                      onChanged: (value) {
                        setState(() {
                          _circleName = value;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      // remove confirmatory marker
                      _removeConfirmatoryMarker();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () async {
                      setState(() {
                        _markerLatLng = latLng;
                      });
                      await _createMarkerAndCircle();
                      // remove confirmatory marker
                      _removeConfirmatoryMarker();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addConfirmatoryMarker(LatLng latLng) async {
    // Add Confirmatory Marker
    Marker confirmatoryMarker = Marker(
      markerId: MarkerId('confirmatory_marker'),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    setState(() {
      _markers.add(confirmatoryMarker);
    });

    // Wait for 1 second
    await Future.delayed(Duration(seconds: 1));
  }

  void _removeConfirmatoryMarker() {
    // Remove Confirmatory Marker
    _markers.removeWhere(
        (marker) => marker.markerId.value == 'confirmatory_marker');
  }
}
