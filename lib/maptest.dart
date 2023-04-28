import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

class MapTest extends StatefulWidget {
  final String uid;
  final DatabaseReference locationRef;

  const MapTest(
      {required Key key, required this.uid, required this.locationRef})
      : super(key: key);

  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  GoogleMapController? mapController;
  LocationData? currentLocation;
  LocationData? friendLocation;
  Location location = Location();
  Marker? marker;
  Marker? friendMarker;
  DatabaseReference? locationRef;

  @override
  void initState() {
    super.initState();
    location.onLocationChanged.listen((LocationData locationData) {
      if (mounted) {
        setState(() {
          currentLocation = locationData;
          marker = Marker(
            markerId: MarkerId("current_location"),
            position: LatLng(currentLocation?.latitude ?? 0,
                currentLocation?.longitude ?? 0),
            infoWindow: InfoWindow(title: "You are here"),
          );
        });
        widget.locationRef.child(widget.uid).set({
          "latitude": currentLocation?.latitude ?? 0,
          "longitude": currentLocation?.longitude ?? 0,
        });
      }
    });
    widget.locationRef.onValue.listen((event) {
      if (mounted) {
        var data = event.snapshot.value
            as Map<String, dynamic>?; // cast to Map<String, dynamic>
        if (data != null && data[widget.uid] != null) {
          setState(() {
            friendLocation = LocationData.fromMap({
              "latitude": data[widget.uid]["latitude"] as double? ?? 0,
              "longitude": data[widget.uid]["longitude"] as double? ?? 0,
            });
            friendMarker = Marker(
              markerId: MarkerId("friend_location"),
              position: LatLng(friendLocation?.latitude ?? 0,
                  friendLocation?.longitude ?? 0),
              infoWindow: InfoWindow(title: "Your friend is here"),
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 16,
        ),
        markers: Set<Marker>.of([marker, friendMarker].whereType<Marker>()),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
