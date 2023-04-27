import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

  Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  Marker? _marker;

  @override
  void initState() {
    super.initState();

    // Get the user's current location
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (_controller != null) {
        // Update the map's camera position
        _controller.animateCamera(CameraUpdate.newLatLng(
            LatLng(locationData.latitude!, locationData.longitude!)));

        // Update the user's location marker
        setState(() {
          _marker = Marker(
            markerId: MarkerId("user_location"),
            position: LatLng(locationData.latitude!, locationData.longitude!),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Stop listening to location updates
    _locationSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco
          zoom: 15,
        ),
        onMapCreated: (controller) {
          _controller = controller;
        },
        markers: _marker != null ? Set<Marker>.from([_marker]) : Set<Marker>(),
      ),
    );
  }
}
