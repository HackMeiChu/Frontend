import 'package:flutter/material.dart';
import 'package:transportation/home_page.dart';
import 'package:transportation/services/fetch_parking_info.dart';
import 'package:provider/provider.dart';
// import 'package:device_preview/device_preview.dart';

void main() => runApp(
  // DevicePreview(builder: (context) => const MyApp(),),
  const MyApp()
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>FetchDataService(),
        child: MaterialApp(
          title: 'Flutter Demo',
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: HomePage(),
        
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        )
      );
  }
}
