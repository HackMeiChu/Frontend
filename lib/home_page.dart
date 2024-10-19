// import 'package:flutter/material.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, this.title}) : super(key: key);

//   final String? title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? ""),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 20),
//             placesAutoCompleteTextField(),
//           ],
//         ),
//       ),
//     );
//   }

//   placesAutoCompleteTextField() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: GooglePlaceAutoCompleteTextField(
//         textEditingController: controller,
//         googleAPIKey:"AIzaSyDFvR0Wqu6IS23_J8DUg5C9KM8mOXaEnHA",
//         inputDecoration: InputDecoration(
//           hintText: "Search your location",
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//         ),
//         debounceTime: 400,
//         countries: [],
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (Prediction prediction) {
//           print("placeDetails" + prediction.lat.toString());
//         },

//         itemClick: (Prediction prediction) {
//           controller.text = prediction.description ?? "";
//           controller.selection = TextSelection.fromPosition(
//               TextPosition(offset: prediction.description?.length ?? 0));
//         },
//         seperatedBuilder: Divider(),
//         containerHorizontalPadding: 10,


//         // OPTIONAL// If you want to customize list view item builder
//         itemBuilder: (context, index, Prediction prediction) {
//           return Container(
//             padding: EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Icon(Icons.location_on),
//                 SizedBox(
//                   width: 7,
//                 ),
//                 Expanded(child: Text("${prediction.description ?? ""}"))
//               ],
//             ),
//           );
//         },

//         isCrossBtnShown: true,

//         // default 600 ms ,
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:transportation/widget/row_button.dart';


// final homeScaffoldKey = GlobalKey<ScaffoldState>();
final kGoogleApiKey = "AIzaSyDFvR0Wqu6IS23_J8DUg5C9KM8mOXaEnHA";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  LatLng? _center;
  Position? _currentPosition;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

 
  _getUserLocation() async {
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
    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      log("in set state");
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    });
  }

  Widget placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey:"AIzaSyDFvR0Wqu6IS23_J8DUg5C9KM8mOXaEnHA",
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
        ),
        debounceTime: 400,
        countries: [],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,


        //OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: homeScaffoldKey,
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
            ),
          ),
          Positioned(
            top: 20,
            right: 0,
            left:0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                placesAutoCompleteTextField(),
                SizedBox(height: 10,),
                RowButton()
              ],
            ),
          )
        ]
      )
    );
  }
}

