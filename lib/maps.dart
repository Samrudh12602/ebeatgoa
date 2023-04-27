import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}
class _MapsState extends State<Maps> {
  GoogleMapController? _controller;
  Location _location = Location();
  // late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;


  @override
  // void initState() {
  //   super.initState();
  //   _location.onLocationChanged.listen((LocationData currentLocation) {
  //     _controller?.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
  //         zoom: 16.0,
  //       ),
  //     ));
  //   });
  // late BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), 'assets/images/marker.png')
        .then((icon) => setState(() => _markerIcon = icon));
  }


  // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), 'assets/images/marker.png')
  //       .then((icon) => _markerIcon = icon);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 16.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of([
          Marker(
            markerId: MarkerId("my_location_marker"),
            position: LatLng(0.0, 0.0),
            icon: _markerIcon != null ? _markerIcon : BitmapDescriptor.defaultMarker,
          ),
        ]),
      ),
    );
  }
}
