import 'dart:convert';
import 'dart:math';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:myapp/models/parking_info_model.dart';

const baseUrl = 'parkinglot-backend.onrender.com';

void main() async {
  final parkingInfoUrl = Uri.https(baseUrl, 'parking');
  final parkingSpaceIDUrl = Uri.https(baseUrl, 'parking/space/1');

  var res = await http.get(parkingInfoUrl);
  if (res.statusCode != 200) {
    print("cannot fetch from the api");
    return;
  }

  var resSpace = await http.get(parkingSpaceIDUrl);
  if (resSpace.statusCode != 200) {
    print("cannot fetch from the api");
    return;
  }

  final resJson = jsonDecode(res.body);
  List<ParkinglotInfo> parkingInfo = List<ParkinglotInfo>.from(
      resJson.map((model) => ParkinglotInfo.fromJson(model)));

  final resJsonSpace = jsonDecode(resSpace.body);
  List<ParkinglotSpace> parkingSpaceInfo = List<ParkinglotSpace>.from(
      resJsonSpace.map((model) => ParkinglotSpace.fromJson(model)));
}
