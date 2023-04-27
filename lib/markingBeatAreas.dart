import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};

  static const LatLng _center = const LatLng(15.4041, 74.0124);

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId('Ponda'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(15.4041, 74.0124),
        infoWindow: InfoWindow(
          title: 'Ponda',
        ),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('Shree Manguesh Devasthan'),
        position: LatLng(15.4077, 73.9975),
        infoWindow: InfoWindow(
          title: 'Shree Manguesh Devasthan',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('Safa Masjid'),
        position: LatLng(15.4024, 73.9926),
        infoWindow: InfoWindow(
          title: 'Safa Masjid',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('Sri Nageshi Temple'),
        position: LatLng(15.3698, 74.0086),
        infoWindow: InfoWindow(
          title: 'Sri Nageshi Temple',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}
