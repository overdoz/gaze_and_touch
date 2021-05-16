import 'package:flutter/material.dart';
import 'package:gazeAndTouch/utils/math.dart';
import 'dart:ui';
import 'dart:core';
import '../shapes/painters.dart';
import '../utils/gaze_listener.dart';
import '../models/screens_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.dimensions}) : super(key: key);

  final Map<String, double> dimensions;

  @override
  _MyHomePageState createState() => _MyHomePageState(dimensions: this.dimensions);
}

class _MyHomePageState extends State<MyHomePage> {
  // add 10 initial gaze points hidden at (0,0)
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(0, 0)];
  final GlobalKey _key = GlobalKey();
  Map<String, double> dimensions;



  Offset topLeft = Offset.zero;
  Offset topRight = Offset.zero;
  Offset bottomLeft = Offset.zero;
  Offset bottomRight = Offset.zero;

  Offset xRange = Offset.zero;
  Offset yRange = Offset.zero;

  /// listens to incoming gaze data
  GazeReceiver _gazeInput;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  _MyHomePageState({this.dimensions}) {
    _gazeInput = new GazeReceiver(_offsets, callback);
  }

  callback() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _size = ScreenSize(height, width);


    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Stack(
              children: <Widget>[
                /// Visualization of gaze points on top level of stack
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(painter: FaceOutlinePainter(_offsets, _size, dimensions)),
                  ),
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FlatButton(
                          child: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("x: ${topLeft.dx} y: ${topLeft.dy}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    topLeft = calcMeanPoint(_offsets);
                                  });
                                },
                                child: Text("Get Top Left Corner"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("x: ${topRight.dx} y: ${topRight.dy}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    topRight = calcMeanPoint(_offsets);
                                  });
                                },
                                child: Text("Get Top Right Corner"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("x: ${bottomLeft.dx} y: ${bottomLeft.dy}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    bottomLeft = calcMeanPoint(_offsets);
                                  });
                                },
                                child: Text("Get Bottom Left Corner"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("x: ${bottomRight.dx} y: ${bottomRight.dy}"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    bottomRight = calcMeanPoint(_offsets);
                                  });
                                },
                                child: Text("Get Bottom Right Corner"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text("x start: ${xRange.dx.toStringAsFixed(4)}"),
                                  Text("x end: ${xRange.dy.toStringAsFixed(4)}"),
                                  ElevatedButton(
                                    onPressed: () {
                                      double xStart = (topLeft.dx + bottomLeft.dx) / 2;
                                      double xEnd = (topRight.dx + bottomRight.dx) / 2;

                                      setState(() {
                                        xRange = Offset(xStart, xEnd);
                                      });
                                    },
                                    child: Text("Get x range"),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("y start: ${yRange.dx.toStringAsFixed(4)}"),
                                  Text("y end: ${yRange.dy.toStringAsFixed(4)}"),
                                  ElevatedButton(
                                    onPressed: () {
                                      double yStart = (topLeft.dy + topRight.dy) / 2;
                                      double yEnd = (bottomLeft.dy + bottomRight.dx) / 2;

                                      setState(() {
                                        yRange = Offset(yStart, yEnd);
                                      });
                                    },
                                    child: Text("Get y range"),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

