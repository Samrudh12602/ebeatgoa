import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  GoogleMapController? _controller;
  StreamSubscription<DocumentSnapshot>? _subscription;
  List<Marker> _markers = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _subscribeToLocationChanges();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    _addMarker(latLng, "My Location", BitmapDescriptor.defaultMarker);
  }

  void _addMarker(LatLng latLng, String title, BitmapDescriptor icon) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          infoWindow: InfoWindow(title: title),
          icon: icon,
        ),
      );
    });
  }

  void _subscribeToLocationChanges() {
    _subscription = _firestore
        .collection('locations')
        .doc(_auth.currentUser?.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        GeoPoint location = snapshot.get('location');
        String name = snapshot.get('name');
        LatLng latLng = LatLng(location.latitude, location.longitude);
        _addMarker(latLng, name, BitmapDescriptor.defaultMarkerWithHue(120));
      }
    });
  }

  void _updateLocation(Position position) async {
    GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
    await _firestore
        .collection('locations')
        .doc(_auth.currentUser?.uid)
        .set({'location': geoPoint, 'name': 'Friend1'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(0.0, 0.0), zoom: 14.0),
        markers: Set.from(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onCameraMove: (CameraPosition position) {},
        onCameraIdle: () {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          LatLng latLng = LatLng(position.latitude, position.longitude);
          _controller?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 14.0),
          ));
          _updateLocation(position);
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
