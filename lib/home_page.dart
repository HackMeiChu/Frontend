import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:transportation/widget/row_button.dart';
import 'package:transportation/widget/search_bar.dart';
import 'package:transportation/widget/scroll_up_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  LatLng? _center;
  Position? _currentPosition;
  late String _mapStyleString;

  @override
  void initState() {
    super.initState();
    _loadStyle();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _loadStyle() async {
    await rootBundle.loadString('assets/map_style.json').then((string) {
        _mapStyleString = string;
        //Black road and path:  I have this bug only on emulator, real device works fine.
    });
  }
  _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("service is not available");
      return;
    }
    // Request permission to get the user's location
    permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        log("permission deniedForever");
        return;
      }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
        log("permission denied");
        return;
      }
    }
    // Get the current location of the user
    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      log("in set state");
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        _center == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
            height: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _center!,
                zoom: 15.0,
              ),
              style: _mapStyleString,
              markers: {
                // Marker(
                //   markerId: const MarkerId('user_location'),
                //   position: _center!,
                //   infoWindow: const InfoWindow(title: 'Your Location'),
                // ),
              },
            ),
          ),
          Positioned(
            top: 20,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(), 
                SizedBox(height: 10,),
                RowButton()
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ScrollUpList(), // Use the ScrollUpList widget here
          ),
        ]
      )
    );
  }
}