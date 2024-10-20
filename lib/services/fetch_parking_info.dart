import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transportation/models/parking_info_model.dart';

const baseUrl = 'parkinglot-backend.onrender.com';

class FetchDataService extends ChangeNotifier {
  GoogleMapController? mapController;
  final List<ParkinglotInfo> parkinglotInfo = [];
  final List<ParkinglotPredSpace> parkinglotPredSpace_list = [];
  Set<Marker> marker = {};
  LatLng? center;
  Position? currentPosition;

  FetchDataService(){
    getUserLocation();
    getParkingInfo();
  }
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    // Request permission to get the user's location
    permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
        return;
      }
    }
    // Get the current location of the user
    currentPosition = await Geolocator.getCurrentPosition();
    // setState(() {
      // log("in set state");
    center = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    notifyListeners();
    // });
  }


  Future<void> getParkingInfo() async {
    final parkingInfoUrl = Uri.https(baseUrl, 'parking');

    var res = await http.get(parkingInfoUrl);
    if (res.statusCode != 200) {
      print("cannot fetch from the api");
      // return [];
    }

    final resJson = jsonDecode(utf8.decode(res.bodyBytes));
    List<ParkinglotInfo> parkingInfo = List<ParkinglotInfo>.from(
        resJson.map((model) => ParkinglotInfo.fromJson(model)));
    // return parkingInfo;
    parkinglotInfo.addAll(parkingInfo);
    // notifyListeners();
    // TODO: test if list work
  }
    

  Future<void> getNearbyPredictParkingSpe(
      double lat, double lng, int minutes, bool changePosition) async {
    final parkingInfoUrl =
        Uri.https(baseUrl, 'parking/predict', {"lat": '$lat', "lng": '$lng', "minutes": '$minutes'});
    var res = await http.get(parkingInfoUrl);
    if (res.statusCode != 200) {
      print("cannot fetch from the api");
      // return []; 
    }
   
    final resJson = json.decode(utf8.decode(res.bodyBytes));
    List<ParkinglotPredSpace> parkinglotPredSpaces = List<ParkinglotPredSpace>.from(
        resJson.map((model) => ParkinglotPredSpace.fromJson(model)));
    // return parkinglotPredSpaces;
    parkinglotPredSpace_list.addAll(parkinglotPredSpaces);
    center = LatLng(lat, lng);
    if (mapController!=null && changePosition){

      mapController!.animateCamera(CameraUpdate.newLatLngZoom(center!, 17));
    }
    toMarker();
    // notifyListeners();
  }


  void toMarker() {

    for(ParkinglotPredSpace item in parkinglotPredSpace_list) {
        for (ParkinglotInfo parkinglot in parkinglotInfo) {
          if(parkinglot.id == item.parkinglot_id) {
             marker.add(
              Marker(
              markerId: MarkerId(parkinglot.id.toString()),
              position: LatLng(parkinglot.latitude, parkinglot.longitude),
              )
            );

          }
        }
    }
    notifyListeners();
  }

   
  

}
