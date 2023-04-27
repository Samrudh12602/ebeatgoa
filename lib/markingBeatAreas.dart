import 'dart:async';
import 'dart:math';
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

  final Set<Marker> _markers = {};

  static const LatLng _center = const LatLng(15.4041, 74.0124);

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
          _markers.removeWhere(
              (marker) => marker.markerId.value == "user_location");
          _markers.add(
            Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              markerId: MarkerId("user_location"),
              infoWindow: InfoWindow(
                title: 'Your Location',
              ),
              position: LatLng(locationData.latitude!, locationData.longitude!),
            ),
          );

          // Check if the user is within the radius of any red marker
          for (Marker marker in _markers) {
            if (marker.icon ==
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed)) {
              double distance = calculateDistance(
                  locationData.latitude!,
                  locationData.longitude!,
                  marker.position.latitude,
                  marker.position.longitude);
              print('Distance from red marker: $distance');
            }
          }

          // Check if the user is within the radius of any red marker
          bool isWithinRadius = _markers.any((marker) =>
              marker.icon ==
                  BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed) &&
              calculateDistance(locationData.latitude!, locationData.longitude!,
                      marker.position.latitude, marker.position.longitude) <=
                  100);

          if (isWithinRadius) {
            Marker redMarker = _markers.firstWhere((marker) =>
                marker.icon ==
                    BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed) &&
                calculateDistance(
                        locationData.latitude!,
                        locationData.longitude!,
                        marker.position.latitude,
                        marker.position.longitude) <=
                    100);
            print(isWithinRadius);
            _showPhotoUploadPopup(context, redMarker);
          }
        });
      }
    });
    // Add the markers for important locations in Ponda, Goa
    _markers.add(
      Marker(
        markerId: MarkerId('Goa College of Engineering'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(15.42266, 73.98005),
        infoWindow: InfoWindow(
          title: 'GEC',
        ),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('Mechanical Engineering Department'),
        position: LatLng(15.42399, 73.98119),
        infoWindow: InfoWindow(
          title: 'Mechanical Engineering Department',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('Civil Department '),
        position: LatLng(15.42365, 73.97940),
        infoWindow: InfoWindow(
          title: 'Civil Engineering Department',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('IT Department'),
        position: LatLng(15.42478, 73.97977),
        infoWindow: InfoWindow(
          title: 'Information Technology Department',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
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
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth's radius in kilometers
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = R * c; // distance in kilometers
    return d * 1000; // distance in meters
  }

  void _showPhotoUploadPopup(BuildContext context, Marker marker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload photo?'),
          content: Text(
              'Do you want to upload a photo for ${marker.infoWindow.title}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Upload'),
              onPressed: () {
                // TODO: Implement photo upload functionality
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
