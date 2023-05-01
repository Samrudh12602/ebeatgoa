import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserMap extends StatefulWidget {
  @override
  _UserMapState createState() => _UserMapState();
}

class _UserMapState extends State<UserMap> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;

  Future<Position> _getLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> _updateUserLocation() async {
    Position position = await _getLocation();
    String? uid = _user?.uid;

    // Retrieve the latest location document for the current user
    QuerySnapshot latestLocationSnapshot = await _firestore
        .collection("users")
        .doc(uid)
        .collection("locationdata")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    // If the latest document for the current user exists, update its location fields
    if (latestLocationSnapshot.docs.isNotEmpty) {
      DocumentReference latestLocationRef =
          latestLocationSnapshot.docs[0].reference;
      await latestLocationRef.update({
        "lat": position.latitude,
        "lng": position.longitude,
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
    // If the latest document for the current user doesn't exist, add a new document with the current location
    else {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("locationdata")
          .add({
        "lat": position.latitude,
        "lng": position.longitude,
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _listenToUserLocation() async {
    String? uid = _user?.uid;

    StreamSubscription<QuerySnapshot> subscription = _firestore
        .collection("users")
        .doc(uid)
        .collection("locationdata")
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((docChange) {
        if (docChange.type == DocumentChangeType.added ||
            docChange.type == DocumentChangeType.modified) {
          Map<String, dynamic>? data = docChange.doc.data();
          LatLng location = LatLng(data!["lat"], data!["lng"]);
          MarkerId markerId = MarkerId(docChange.doc.id);

          _firestore.collection("users").doc(uid).get().then((userDoc) {
            String name = userDoc.data()!["name"];
            Marker marker = Marker(
              markerId: markerId,
              position: location,
              infoWindow: InfoWindow(title: name),
            );

            // Check if marker with the same MarkerId already exists
            if (markers.containsKey(markerId)) {
              setState(() {
                markers[markerId] =
                    marker; // Update existing marker with new position
              });
            } else {
              setState(() {
                markers[markerId] = marker; // Add new marker
              });
            }
          });
        } else if (docChange.type == DocumentChangeType.removed) {
          MarkerId markerId = MarkerId(docChange.doc.id);

          setState(() {
            markers.remove(markerId); // Remove marker from map
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _listenToUserLocation();

    Timer.periodic(Duration(seconds: 5), (timer) {
      _updateUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(15.42478, 73.97977),
          zoom: 10,
        ),
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
