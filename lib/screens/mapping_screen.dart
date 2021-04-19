import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:core';
import '../shapes/painters.dart';
import '../utils/gaze_listener.dart';
import '../models/screens_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // add 10 initial gaze points hidden at (0,0)
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(0, 0)];
  final GlobalKey _key = GlobalKey();

  GazeReceiver _gazeInput;

  @override
  void initState() {
    super.initState();

    _gazeInput = new GazeReceiver(_offsets, callback);
  }

  callback() {
    setState(() {
      print(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {

    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var size = ScreenSize(height, width);


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
              child: CustomPaint(painter: FaceOutlinePainter(_offsets, size)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomPaint(
                        painter: WheelPainter(),
                        key: _key,
                      ),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
