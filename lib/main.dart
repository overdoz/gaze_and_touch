import 'dart:core';
// import 'package:udp/udp.dart';
import 'package:flutter/material.dart';
import 'package:gazeAndTouch/screens/drawer_screen.dart';
import 'package:gazeAndTouch/utils/gaze_listener.dart';
import 'package:gazeAndTouch/utils/math.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import './screens/notifications_screen.dart';
import './shapes/painters.dart';
import './screens/mapping_screen.dart';
import './screens/buttons_screen.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double screenSize;
  double aspectRatio;
  double mobileScreenSize;
  double mobileAspectRatio;

  // Map dimensions;

  /// eye tracking listener
  GazeReceiver _gazeInput;

  /// initial gaze data
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(100, 200)];

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  @override
  void initState() {
    super.initState();

    // _gazeInput = new GazeReceiver(_offsets, callback);

  }


  callback() {
    setState(
          () {

      },
    );
  }


  @override
  Widget build(BuildContext context) {
    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    _size = ScreenSize(height, width);

    return Scaffold(
      body: Container(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "screen size",
                        hintText: "screen size in inch (e.g. 13\")"
                      ),
                      onChanged: (text) {
                        screenSize = double.parse(text);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "aspect ratio",
                          hintText: "aspect ratio (e.g. 4:3 = 1.33)"
                      ),
                      onChanged: (text) {
                        aspectRatio = double.parse(text);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "mobile screen size",
                          hintText: "mobile screen size in inch (e.g. 6.5\")"
                      ),
                      onChanged: (text) {
                        mobileScreenSize = double.parse(text);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "mobile aspect ratio",
                          hintText: "mobile aspect ratio (e.g. 19.5:9 = 2.16)"
                      ),
                      onChanged: (text) {
                        mobileAspectRatio = double.parse(text);
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // Map<String, double> dimensions = calcMeasurements(screenSize, aspectRatio, mobileScreenSize, mobileAspectRatio);
                        Map<String, double> dimensions = calcMeasurements(12.3, 1.5, 6.5, 2.16);


                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Notifications(dimensions: dimensions)),
                        );
                      },
                      child: Text("Let's start"),
                  ),
                ],
              ),
            ),

            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => MyHomePage()),
            //       );
            //     },
            //     child: Text("Mapping")),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => DrawerScreen()),
            //       );
            //     },
            //     child: Text("Drawer")),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => ButtonsScreen()),
            //       );
            //     },
            //     child: Text("Buttons")),
          ],
        ),
      ),
    );
  }
}
