import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this for launching Google Maps

class ScrollUpList extends StatefulWidget {
  const ScrollUpList({Key? key}) : super(key: key);

  @override
  State<ScrollUpList> createState() => _ScrollUpListState();
}

class _ScrollUpListState extends State<ScrollUpList> {
  bool isPanelExpanded = false; // Whether the panel is expanded (scroll-up list)
  final double collapsedHeight = 80.0; // Collapsed panel height
  final double expandedHeight = 400.0; // Expanded panel height
  int? selectedIndex; // Track which item is clicked

  // Sample data for parking locations
  final List<Map<String, dynamic>> parkingData = [
    {
      'title': '機械停車場A',
      'carTotal': '50',
      'carAvail': '40',
      'carAvailPred': '38',
      'distance': '50公尺(1 min)',
      'liked': true
    },
    {
      'title': '立體停車場B',
      'carTotal': '200',
      'carAvail': '140',
      'carAvailPred': '173',
      'distance': '250公尺(5 min)',
      'liked': false
    },
    {
      'title': '地下停車場C',
      'carTotal': '150',
      'carAvail': '148',
      'carAvailPred': '150',
      'distance': '350公尺(7 min)',
      'liked': false
    },
    // Add more parking data if needed
  ];

  // Function to toggle the panel state
  void _togglePanel() {
    setState(() {
      isPanelExpanded = !isPanelExpanded;
    });
  }

  // Function to open Google Maps for navigation based on the title
  Future<void> _openGoogleMaps(String title) async {
    final String query = Uri.encodeComponent(title); // Encode the title
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$query';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl); // Launch the Google Maps URL
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          )
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
              child: ListView.builder(
                itemCount: parkingData.length, // Number of items in the list
                itemBuilder: (context, index) {
                  final item = parkingData[index];
                  bool isSelected = selectedIndex == index; // Check if the item is selected

                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text(
                      '當前: ${item['carAvail']}  總共: ${item['carTotal']}\n'
                      '預計剩餘: ${item['carAvailPred']}\n'
                      '距離目的地: ${item['distance']}',
                    ),
                    trailing: isSelected
                        ? ElevatedButton(
                            onPressed: () {
                              _openGoogleMaps(item['title']); // Navigate to Google Maps
                            },
                            child: const Text('導航'),
                          )
                        : (item['liked']
                            ? const Icon(Icons.thumb_up, color: Colors.blue)
                            : null),
                    onTap: () {
                      setState(() {
                        selectedIndex = index; // Set the selected index
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
}
