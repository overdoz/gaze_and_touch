import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import '../shapes/painters.dart';

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
  // add initial gaze points hidden at (0,0)
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(0, 0)];

  @override
  Widget build(BuildContext context) {
    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var addressesIListenFrom = InternetAddress.anyIPv4;
    int portIListenOn = 65002; //0 is random
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.forEach((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();

          /// read input coordinates and find semicolon for later parsing
          var coordinates = utf8.decode(dg.data);
          var indxFirstSemicolon = coordinates.indexOf(";");

          /// coordinates as strings
          var xDecode = coordinates
              .substring(0, indxFirstSemicolon)
              .replaceAll(new RegExp(r','), '.');

          var yDecode = coordinates
              .substring(indxFirstSemicolon + 1, coordinates.length - 1)
              .replaceAll(new RegExp(r','), '.');

          /// coodinates as double
          var x = double.parse(xDecode);
          var y = double.parse(yDecode);

          /// remove outliers and add gazepoint to array
          /// setState() ensures rerendering
          if (x != 0.0) {
            setState(() {
              _offsets.add(Offset(x * width, y * height));
              _offsets.removeAt(0);
            });
          }
        }
      });
      print('Did send data on the stream..');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapping'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity, //double.infinity,
              height: double.infinity, //double.infinity,
              color: Colors.white,
              child: CustomPaint(painter: FaceOutlinePainter(_offsets)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomPaint(painter: WheelPainter()),
                      CustomPaint(painter: WheelPainter())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomPaint(painter: WheelPainter()),
                      CustomPaint(painter: WheelPainter())
                    ],
                  ),
                  // Text(
                  //   'You have pushed the button this many times:',
                  // ),
                  // Text(
                  //   '$_counter',
                  //   style: Theme.of(context).textTheme.headline4,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}