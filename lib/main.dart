import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:device_preview/device_preview.dart';
import 'package:intl/intl.dart'; // For date and time formatting

void main() => runApp(
  DevicePreview(builder: (context) => const MyApp(),),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isImmediate = true; // Whether "立即出發" is selected
  Color leftButtonColor = Colors.purple; // Default color for the left button ("立即出發")
  Color rightButtonColor = Colors.blue; // Default color for the right button
  String selectedDateTime = ''; // For displaying selected date and time

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _pickDateTime() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: "預計抵達日期及時間"
    );

    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          isImmediate = false; // "選擇日期與時間" is now selected
          DateTime fullDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(52.2677, 5.1689),
              initialZoom: 3.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          // Search bar and buttons
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index\nitem $index address';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    },
                ),
                const SizedBox(height: 10), // Space between search bar and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left button - "立即出發"
                    FilledButton(
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: Colors.white,
                      //   foregroundColor: leftButtonColor, // Text color
                      // ),
                      onPressed: () {
                        setState(() {
                          leftButtonColor = Colors.purple;
                          rightButtonColor = Colors.blue;
                          isImmediate = true; // "立即出發" is selected
                          selectedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            isImmediate
                                ? '立即出發'
                                : '抵達時間'
                          ),
                          const SizedBox(width: 5),
                          // const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    // Right button - Date & Time Picker
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: rightButtonColor, // Text color
                      ),
                      onPressed: () {
                        setState(() {
                          leftButtonColor = Colors.blue;
                          rightButtonColor = Colors.purple;
                        });
                        _pickDateTime();
                      },
                      child: Row(
                        children: [
                          Text(
                            isImmediate
                                ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()) // Show current time if "立即出發"
                                : (selectedDateTime.isEmpty ? '選擇日期與時間' : selectedDateTime),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
