import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For calculating distance
import 'package:provider/provider.dart';
import 'package:transportation/models/parking_info_model.dart';
import 'package:transportation/services/fetch_parking_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ScrollUpList extends StatefulWidget {
  const ScrollUpList({super.key});

  @override
  State<ScrollUpList> createState() => _ScrollUpListState();
}

class _ScrollUpListState extends State<ScrollUpList> {
  bool isPanelExpanded = false; // Panel expansion state
  final double collapsedHeight = 80.0; // Collapsed panel height
  final double expandedHeight = 400.0; // Expanded panel height
  int? selectedIndex; // Track the selected item

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  // Fetch initial parking data when the component is initialized
  void _fetchInitialData() async {
    final fetchDataService = Provider.of<FetchDataService>(context, listen: false);
    // Call the method to fetch parking information
    await fetchDataService.getParkingInfo();
    // Optionally call getNearbyPredictParkingSpe if needed
    await fetchDataService.getNearbyPredictParkingSpe(24.8095628, 120.9721614, 30);
  }

  // Toggle panel expansion state
  void _togglePanel() {
    setState(() {
      isPanelExpanded = !isPanelExpanded;
    });
  }

  // Calculate the distance between two coordinates (in meters)
  (String, int) _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return ("${(distanceInMeters).toStringAsFixed(2)} 公尺", (distanceInMeters / 60).round());
  }

  @override
  Widget build(BuildContext context) {
    final fetchDataService = Provider.of<FetchDataService>(context);

    // Assuming user's search location is available as _userLat and _userLng
    double _userLat = 24.8095628; // Example: 巨城 latitude
    double _userLng = 120.9721614; // Example: 巨城 longitude

    // Fetch data from FetchDataService
    List<Map<String, dynamic>> parkingData = [];

    // Match parkinglotPredSpaces and parkinglogInfo by parking lot ID
    for (ParkinglotPredSpace predSpace in fetchDataService.parkinglotPredSpace_list) {
      for (ParkinglotInfo info in fetchDataService.parkinglogInfo) {
        if (info.id == predSpace.parkinglot_id) {
          // Calculate the distance from the user's search location to the parking lot
          String distance = '';
          int time = 0;
          (distance, time) = _calculateDistance(info.latitude, info.longitude, _userLat, _userLng);
          // print('============================================');
          // print(info.name);
          // Add the matched parking lot data to the list
          parkingData.add({
            'title': info.name,
            'latitude': info.latitude,
            'longitude': info.longitude,
            'carTotal': predSpace.carTotal.toString(),
            'carAvail': predSpace.carAvail.toString(),
            'carAvailPred': predSpace.carAvailPred.toString(),
            'distance': distance,
            'time': time,
            'liked': parkingData.isEmpty, // First item is liked, others are not
          });
        }
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isPanelExpanded ? expandedHeight : collapsedHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _togglePanel,
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                isPanelExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                size: 30,
              ),
            ),
          ),
          if (isPanelExpanded) ...[
            const Text(
              '停車場清單',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: parkingData.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Show loading spinner when parkingData is empty
                  : ListView.builder(
                      itemCount: parkingData.length, // List length based on matched data
                      itemBuilder: (context, index) {
                        final item = parkingData[index];
                        bool isSelected = selectedIndex == index; // Track selected item

                        return ListTile(
                          title: Text(item['title']),
                          subtitle: Text(
                            '當前: ${item['carAvail']}  總共: ${item['carTotal']}\n'
                            '預計剩餘: ${item['carAvailPred']}\n'
                            '距離目的地: ${item['distance']} (${item['time']} min)',
                          ),
                          trailing: isSelected
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Open Google Maps with the parking lot's latitude and longitude
                                    _openGoogleMaps(item['latitude'], item['longitude']);
                                  },
                                  child: const Text('導航'),
                                )
                              : (item['liked']
                                  ? const Icon(Icons.thumb_up, color: Colors.blue)
                                  : null),
                          onTap: () {
                            setState(() {
                              selectedIndex = index; // Set the selected item
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }

  // Open Google Maps with the parking lot's latitude and longitude (for navigation)
  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}
