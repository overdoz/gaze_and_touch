import 'dart:ui';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
// import 'package:udp/udp.dart';
import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _offsets = <Offset>[];
    // var data = "Hello, World";
    // var codec = new Utf8Codec();
    // List<int> dataToSend = codec.encode(data);
    var addressesIListenFrom = InternetAddress.anyIPv4;
    int portIListenOn = 65002; //0 is random
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.forEach((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();
          // dg.data.forEach((x) => print(utf8.decode(x)));
          // dg.data.forEach((x) => print(utf8.decode(x)));
          var coordinates = utf8.decode(dg.data);
          //print(utf8.decode(dg.data));
          var indxFirstSemicolon = coordinates.indexOf(";");
          var x = coordinates.substring(0, indxFirstSemicolon);
          var y =
              coordinates.substring(indxFirstSemicolon, coordinates.length - 1);
          print("x: $x, y: $y");
        }
      });
      // udpSocket.send(dataToSend, addressesIListenFrom, portIListenOn);
      print('Did send data on the stream..');
    });

    _offsets.add(Offset(50.0, 50.0));
    _offsets.add(Offset(60.0, 60.0));
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300, //double.infinity,
              height: 300, //double.infinity,
              color: Colors.yellow,
              child: CustomPaint(painter: FaceOutlinePainter(_offsets)),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  final offsets;

  FaceOutlinePainter(this.offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    // Left eye
    // canvas.drawRRect(
    //   RRect.fromRectAndRadius(
    //       Rect.fromLTWH(20, 40, 10, 10), Radius.circular(20)),
    //   paint,
    // );
    for (var offset in offsets) {
      canvas.drawPoints(PointMode.points, [offset], paint);
    }
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => true;
}
