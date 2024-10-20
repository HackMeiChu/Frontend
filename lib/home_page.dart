import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:transportation/services/fetch_parking_info.dart';
import 'package:transportation/widget/row_button.dart';

import 'package:transportation/widget/scroll_up_list.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _getUserLocation();
  }


  Widget placesAutoCompleteTextField(context) {

    final fetchDataService = Provider.of<FetchDataService>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey:"AIzaSyDFvR0Wqu6IS23_J8DUg5C9KM8mOXaEnHA",
        inputDecoration: const InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
        ),
        debounceTime: 800,
        countries: ['tw'],
        isLatLngRequired: true,
        
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          if(prediction.placeId==null) {
            log("Prediction is null");
          }
          else {
            fetchDataService.getNearbyPredictParkingSpe(24.8094861,120.9721461, 30, true);
          }
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

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
    
    final fetchDataService = Provider.of<FetchDataService>(context, listen: true);

    return Scaffold(
      // key: homeScaffoldKey,
      body: Stack(
        children: [
        fetchDataService.center == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
            height: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: fetchDataService.onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: fetchDataService.center!,
                zoom: 20.0,
              ),
              markers: fetchDataService.marker,
            ),
          ),
          Positioned(
            top: 20,
            right: 0,
            left:0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                placesAutoCompleteTextField(context),
                SizedBox(height: 10,),
                RowButton(),
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

