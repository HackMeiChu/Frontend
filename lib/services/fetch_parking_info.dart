import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transportation/models/parking_info_model.dart';

const baseUrl = 'parkinglot-backend.onrender.com';

class FetchDataService extends ChangeNotifier {

  final List<ParkinglotInfo> parkinglogInfo = [];
  final List<ParkinglotPredSpace> parkinglotPredSpaces = [];
  int counter = 0;

  void count(){
    counter ++;
    notifyListeners();
  }

  Future<void> getParkingInfo() async {
    final parkingInfoUrl = Uri.https(baseUrl, 'parking');

    var res = await http.get(parkingInfoUrl);
    if (res.statusCode != 200) {
      print("cannot fetch from the api");
      // return [];
    }

    final resJson = jsonDecode(res.body);
    List<ParkinglotInfo> parkingInfo = List<ParkinglotInfo>.from(
        resJson.map((model) => ParkinglotInfo.fromJson(model)));
    // return parkingInfo;
    parkinglogInfo.addAll(parkingInfo);
    notifyListeners();
  }

  Future<void> getNearbyPredictParkingSpe(
      double lat, double lng, int minutes) async {
    final parkingInfoUrl =
        Uri.https(baseUrl, 'parking/predict', {"lat": lat, "lng": lng, "minutes": minutes});

    var res = await http.get(parkingInfoUrl);
    if (res.statusCode != 200) {
      print("cannot fetch from the api");
      // return []; 
    }

    final resJson = jsonDecode(res.body);
    List<ParkinglotPredSpace> parkinglotPredSpaces = List<ParkinglotPredSpace>.from(
        resJson.map((model) => ParkinglotPredSpace.fromJson(model)));
    // return parkinglotPredSpaces;
    parkinglotPredSpaces.addAll(parkinglotPredSpaces);
    notifyListeners();
  }

}
