import 'package:flutter/material.dart';
import 'package:gazeAndTouch/utils/math.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';
import 'dart:ui';
import 'dart:core';
import '../shapes/painters.dart';
import '../utils/gaze_listener.dart';
import '../models/screens_model.dart';

class AccuracyScreen extends StatefulWidget {
  AccuracyScreen({Key key, this.dimensions}) : super(key: key);

  final Map<String, double> dimensions;

  @override
  _AccuracyScreenState createState() => _AccuracyScreenState(dimensions: this.dimensions);
}

class _AccuracyScreenState extends State<AccuracyScreen> {
  // add 10 initial gaze points hidden at (0,0)
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(0, 0)];

  final GlobalKey _key = GlobalKey();

  final GlobalKey _topLeftKey = GlobalKey();
  final GlobalKey _topRightKey = GlobalKey();
  final GlobalKey _bottomLeftKey = GlobalKey();
  final GlobalKey _bottomRightKey = GlobalKey();

  Map<String, double> dimensions;

  Offset topLeft = Offset.zero;
  Offset topLeftIcon = Offset.zero;

  Offset topRight = Offset.zero;
  Offset topRightIcon = Offset.zero;

  Offset bottomLeft = Offset.zero;
  Offset bottomLeftIcon = Offset.zero;

  Offset bottomRight = Offset.zero;
  Offset bottomRightIcon = Offset.zero;


  /// listens to incoming gaze data
  GazeReceiver _gazeInput;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  _AccuracyScreenState({this.dimensions}) {
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Top Left
                              Column(
                                children: [
                                  Icon(Icons.accessibility_new, key: _topLeftKey,),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        topLeft = calcMeanPoint(_offsets);
                                        topLeftIcon = getWidgetPosition(_topLeftKey);
                                      });
                                    },
                                    child: Text("Test"),
                                  ),
                                ],
                              ),

                              /// Top Right
                              Column(
                                children: [
                                  Icon(Icons.accessibility_new, key: _topRightKey),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        topRight = calcMeanPoint(_offsets);
                                        topRightIcon = getWidgetPosition(_topRightKey);
                                      });
                                    },
                                    child: Text("Test"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              /// Middle
                              Column(
                                children: [
                                  Icon(Icons.accessibility_new),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        bottomLeft = calcMeanPoint(_offsets);
                                        bottomLeftIcon = getWidgetPosition(_bottomLeftKey);
                                      });
                                    },
                                    child: Text("Test"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// Bottom Left
                              Column(
                                children: [
                                  Icon(Icons.accessibility_new, key: _bottomLeftKey),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        bottomLeft = calcMeanPoint(_offsets);
                                        bottomLeftIcon = getWidgetPosition(_bottomLeftKey);
                                      });
                                    },
                                    child: Text("Test"),
                                  ),
                                ],
                              ),
                              /// Bottom Right
                              Column(
                                children: [
                                  Icon(Icons.accessibility_new, key: _bottomRightKey),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        bottomRight = calcMeanPoint(_offsets);
                                        bottomRightIcon = getWidgetPosition(_bottomRightKey);
                                      });
                                    },
                                    child: Text("Test"),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () {

                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 500,
                                    color: Colors.amber,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('Top Left'),
                                          Text('x: ${topLeftIcon.dx} y: ${topLeftIcon.dy}'),
                                          Text('x^: ${mapNum(topLeft.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1)} y^: ${mapNum(topLeft.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height).toStringAsFixed(1)}'),
                                          SizedBox(height: 20,),
                                          Text('Top Right'),
                                          Text('x: ${topRightIcon.dx} y: ${topRightIcon.dy}'),
                                          Text('x^: ${mapNum(topRight.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1)} y^: ${mapNum(topRight.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height).toStringAsFixed(1)}'),
                                          SizedBox(height: 20,),
                                          Text('Bottom Left'),
                                          Text('x: ${bottomLeftIcon.dx} y: ${bottomLeftIcon.dy}'),
                                          Text('x^: ${mapNum(bottomLeft.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1)} y^: ${mapNum(bottomLeft.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height).toStringAsFixed(1)}'),
                                          SizedBox(height: 20,),
                                          Text('Bottom Right'),
                                          Text('x: ${bottomRightIcon.dx} y: ${bottomRightIcon.dy}'),
                                          Text('x^: ${mapNum(bottomRight.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1)} y^: ${mapNum(bottomLeft.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height).toStringAsFixed(1)}'),
                                          SizedBox(height: 20,),

                                          ElevatedButton(
                                            child: const Text('Close BottomSheet'),
                                            onPressed: () => Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text("Show results"),
                          ),
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

