import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

// import 'package:udp/udp.dart';
import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/screens/accuracy_screen.dart';
import 'package:gazeAndTouch/utils/gaze_listener.dart';
import 'package:gazeAndTouch/utils/math.dart';

import './screens/notifications_screen.dart';

Future<void> main() async {
  // // bind the socket server to an address and port
  // final server = await ServerSocket.bind(InternetAddress.anyIPv4, 65003);
  //
  // // listen for clent connections to the server
  // server.listen((client) {
  //   print("Listening...");
  //   handleConnection(client);
  // });

  runApp(MyApp());
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  // listen for events from the client
  client.listen(
    // handle data from the client
    (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);
      if (message == 'Knock, knock.') {
        client.write('Who is there?');
      } else if (message.length < 10) {
        client.write('$message who?');
      } else {
        client.write('Very funny.');
        client.close();
      }
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
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
          () {},
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
                      decoration: InputDecoration(labelText: "screen size", hintText: "screen size in inch (e.g. 13\")"),
                      onChanged: (text) {
                        screenSize = double.parse(text);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: "aspect ratio", hintText: "aspect ratio (e.g. 4:3 = 1.33)"),
                      onChanged: (text) {
                        aspectRatio = double.parse(text);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: "mobile screen size", hintText: "mobile screen size in inch (e.g. 6.5\")"),
                      onChanged: (text) {
                        mobileScreenSize = double.parse(text);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: "mobile aspect ratio", hintText: "mobile aspect ratio (e.g. 19.5:9 = 2.16)"),
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
                    child: Text("Example"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Map<String, double> dimensions = calcMeasurements(12.3, 1.5, 6.5, 2.16);

                      print(dimensions);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccuracyScreen(dimensions: dimensions)),
                      );
                    },
                    child: Text("Accuracy Test"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
