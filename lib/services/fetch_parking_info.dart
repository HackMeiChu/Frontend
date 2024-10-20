import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transportation/models/parking_info_model.dart';

const baseUrl = 'parkinglot-backend.onrender.com';

class FetchDataService extends ChangeNotifier {

  final List<ParkinglotInfo> parkinglogInfo = [];
  final List<ParkinglotPredSpace> parkinglotPredSpace_list = [];
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

    final resJson = jsonDecode(utf8.decode(res.bodyBytes));
    List<ParkinglotInfo> parkingInfo = List<ParkinglotInfo>.from(
        resJson.map((model) => ParkinglotInfo.fromJson(model)));
    // return parkingInfo;
    print("==========================================================");
    print(parkingInfo[0].name);
    parkinglogInfo.addAll(parkingInfo);
    notifyListeners();
  }

  Future<void> getNearbyPredictParkingSpe(
      double lat, double lng, int minutes) async {
    final parkingInfoUrl =
        Uri.https(baseUrl, 'parking/predict', {"lat": '$lat', "lng": '$lng', "minutes": '$minutes'});
    // print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    // print(parkingInfoUrl);
    var res = await http.get(parkingInfoUrl);
    if (res.statusCode != 200) {
      print("cannot fetch from the api");
      // return []; 
    }

    // final resJson = jsonDecode(res.body);
    // Ensure UTF-8 decoding
    final resJson = json.decode(utf8.decode(res.bodyBytes));
    List<ParkinglotPredSpace> parkinglotPredSpaces = List<ParkinglotPredSpace>.from(
        resJson.map((model) => ParkinglotPredSpace.fromJson(model)));
    // return parkinglotPredSpaces;
    // Clear the existing list and add the new data
    parkinglotPredSpace_list.addAll(parkinglotPredSpaces);
    // print("+++++++++++++++++++++");
    // print(parkinglotPredSpaces);
    notifyListeners();
  }

}
