// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _controller;
//   late Marker _currentLocationMarker = Marker(
//     markerId: MarkerId('CurrentLocation'),
//     infoWindow: InfoWindow(
//       title: 'You',
//     ),
//     position: LatLng(0, 0),
//     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//     zIndex: 2,
//   );
//   late LatLng _currentLocation = LatLng(0, 0);
//   bool _isWithinCircle = false;
//   Set<Marker> _markers = Set<Marker>();
//   Set<Circle> _circles = Set<Circle>();
//
//   @override
//   void initState() {
//     super.initState();
//     _getBeatLocations();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition:
//                 CameraPosition(target: _currentLocation, zoom: 15),
//             markers: Set<Marker>.of(_markers..add(_currentLocationMarker)),
//             circles: Set<Circle>.of(_circles),
//             onMapCreated: (GoogleMapController controller) {
//               _controller = controller;
//               _getLocation();
//             },
//           ),
//           Positioned(
//             top: 20,
//             right: 20,
//             child: FloatingActionButton(
//               onPressed: () {
//                 _checkIfWithinCircle();
//               },
//               child: Icon(Icons.upload),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   StreamSubscription<Position>? _positionStreamSubscription;
//   void _startListening() {
//     _positionStreamSubscription =
//         Geolocator.getPositionStream().listen((position) {
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//         _currentLocationMarker =
//             _currentLocationMarker.copyWith(positionParam: _currentLocation);
//         _controller.animateCamera(
//           CameraUpdate.newLatLng(_currentLocation),
//         );
//       });
//     });
//   }
//
//   void _stopListening() {
//     if (_positionStreamSubscription != null) {
//       _positionStreamSubscription?.cancel();
//     }
//   }
//
//   void _getLocation() {
//     _startListening();
//   }
//
//   void _checkIfWithinCircle() {
//     bool isWithinCircle = false;
//     for (var marker in _markers) {
//       if (Geolocator.distanceBetween(
//               _currentLocation.latitude,
//               _currentLocation.longitude,
//               marker.position.latitude,
//               marker.position.longitude) <=
//           50) {
//         isWithinCircle = true;
//         break;
//       }
//     }
//     setState(() {
//       _isWithinCircle = isWithinCircle;
//     });
//     if (_isWithinCircle) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Within circle'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Your current location is within one of the circles.'),
//                 SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // TODO: Implement upload functionality
//                     Navigator.of(context).pop();
//                   },
//                   icon: Icon(Icons.upload),
//                   label: Text('Upload'),
//                 ),
//                 SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel'),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Outside circle'),
//             content: Text('Your current location is outside all the circles.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Go back'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   Future<void> _getBeatLocations() async {
//     // Retrieve data from Firestore
//     CollectionReference beatLocations =
//         FirebaseFirestore.instance.collection('BeatLocations');
//     QuerySnapshot querySnapshot = await beatLocations.get();
//
//     // Create new sets of markers and circles that includes all existing ones
//     Set<Marker> allMarkers = Set<Marker>();
//     Set<Circle> allCircles = Set<Circle>();
//
//     // Add existing markers and circles to sets
//     querySnapshot.docs.forEach((doc) {
//       LatLng markerLatLng = LatLng(
//           doc['markerPosition'].latitude, doc['markerPosition'].longitude);
//
//       Marker marker = Marker(
//         markerId: MarkerId(doc.id),
//         position: markerLatLng,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         infoWindow: InfoWindow(title: doc['markerName']),
//       );
//       allMarkers.add(marker);
//
//       final random = Random();
//       final color = Color.fromARGB(
//         255,
//         random.nextInt(256),
//         random.nextInt(256),
//         random.nextInt(256),
//       );
//       Circle circle = Circle(
//         circleId: CircleId(doc.id),
//         center:
//             LatLng(doc['circleCenter'].latitude, doc['circleCenter'].longitude),
//         radius: doc['circleRadius'],
//         strokeWidth: 2,
//         strokeColor: Colors.red,
//         fillColor: color.withOpacity(0.1), // Use the random color here
//       );
//       allCircles.add(circle);
//     });
//
//     // Update the sets of markers and circles
//     setState(() {
//       _markers = allMarkers;
//       _circles = allCircles;
//     });
//   }
// }
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  late Marker _marker1;
  late Marker _marker2;
  late Marker _marker3;
  late Marker _currentLocationMarker = Marker(
    markerId: MarkerId('CurrentLocation'),
    infoWindow: InfoWindow(
      title: 'You',
    ),
    position: LatLng(0, 0),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    zIndex: 2,
  );
  late Circle _circle1;
  late Circle _circle2;
  late Circle _circle3;
  LatLng _center1 = LatLng(15.42478, 73.97977);
  LatLng _center2 = LatLng(15.42275, 73.97932);
  LatLng _center3 = LatLng(15.42273, 73.98183);
  late LatLng _currentLocation = LatLng(0, 0);
  bool _isWithinCircle = false;

  @override
  void initState() {
    super.initState();
    _marker1 = Marker(
        markerId: MarkerId('IT Department'),
        position: _center1,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Information Technology Department'));
    _marker2 = Marker(
        markerId: MarkerId('GEC Canteen'),
        position: _center2,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'GEC CANTEEN '));
    _marker3 = Marker(
      markerId: MarkerId('Marker3'),
      position: _center3,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    _circle1 = Circle(
      circleId: CircleId('Circle1'),
      center: _center1,
      radius: 100.0,
      fillColor: Colors.blue.withOpacity(0.1),
      strokeWidth: 0,
    );
    _circle2 = Circle(
      circleId: CircleId('Circle2'),
      center: _center2,
      radius: 100.0,
      fillColor: Colors.red.withOpacity(0.1),
      strokeWidth: 0,
    );
    _circle3 = Circle(
      circleId: CircleId('Circle3'),
      center: _center3,
      radius: 100.0,
      fillColor: Colors.green.withOpacity(0.1),
      strokeWidth: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center1, zoom: 15),
            markers: Set<Marker>.of(
                [_marker1, _marker2, _marker3, _currentLocationMarker]),
            circles: Set<Circle>.of([_circle1, _circle2, _circle3]),
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

  void _checkIfWithinCircle() {
    bool isWithinCircle1 = Geolocator.distanceBetween(
            _currentLocation.latitude,
            _currentLocation.longitude,
            _center1.latitude,
            _center1.longitude) <=
        100;
    bool isWithinCircle2 = Geolocator.distanceBetween(
            _currentLocation.latitude,
            _currentLocation.longitude,
            _center2.latitude,
            _center2.longitude) <=
        100;
    bool isWithinCircle3 = Geolocator.distanceBetween(
            _currentLocation.latitude,
            _currentLocation.longitude,
            _center3.latitude,
            _center3.longitude) <=
        100;
    setState(() {
      _isWithinCircle = isWithinCircle1 || isWithinCircle2 || isWithinCircle3;
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
                    // TODO: Implement upload functionality
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cloud_upload),
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
}
