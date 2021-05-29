import 'dart:async';

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
  final GlobalKey _centerKey = GlobalKey();

  Map<String, double> dimensions;

  Offset topLeft = Offset.zero;
  Offset topLeftIcon = Offset.zero;
  Size topLeftIconSize;

  Offset topRight = Offset.zero;
  Offset topRightIcon = Offset.zero;
  Size topRightIconSize;

  Offset bottomLeft = Offset.zero;
  Offset bottomLeftIcon = Offset.zero;
  Size bottomLeftIconSize;

  Offset bottomRight = Offset.zero;
  Offset bottomRightIcon = Offset.zero;
  Size bottomRightIconSize;

  Offset center = Offset.zero;
  Offset centerIcon = Offset.zero;
  Size centerIconSize;

  /// listens to incoming gaze data
  GazeReceiver _gazeInput;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  _AccuracyScreenState({this.dimensions}) {
    _gazeInput = new GazeReceiver(_offsets, callback);
  }

  Timer _timer;
  int _start = 10;

  void startTimer() {
    print("Start timer");
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          print(_start);
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print("init State");
    startTimer();
  }

  // Future<Widget> setupTest() async {}

  @override
  Widget build(BuildContext context) {
    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _size = ScreenSize(height, width);
    print(_size.width);
    print(_size.height);

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
                                  Icon(
                                    Icons.accessibility_new,
                                    key: _topLeftKey,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        topLeft = calcMeanPoint(_offsets);
                                        topLeftIcon = getWidgetPosition(_topLeftKey);
                                        topLeftIconSize = getWidgetSize(_topLeftKey);
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
                                        topRightIconSize = getWidgetSize(_topRightKey);
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
                                  Icon(Icons.accessibility_new, key: _centerKey),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        center = calcMeanPoint(_offsets);
                                        centerIcon = getWidgetPosition(_centerKey);
                                        centerIconSize = getWidgetSize(_centerKey);
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
                                        bottomLeftIconSize = getWidgetSize(_bottomLeftKey);
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
                                        bottomRightIconSize = getWidgetSize(_bottomRightKey);
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
                                  var topLeftX = topLeftIcon.dx + topLeftIconSize.width / 2;
                                  var topLeftY = topLeftIcon.dy + topLeftIconSize.height / 2;
                                  var topLeftXhat = double.parse(
                                      mapNum(topLeft.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1));
                                  var topLeftYhat = double.parse(
                                      mapNum(topLeft.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height)
                                          .toStringAsFixed(1));

                                  var topRightX = topRightIcon.dx + topRightIconSize.width / 2;
                                  var topRightY = topRightIcon.dy + topRightIconSize.height / 2;
                                  var topRightXhat = double.parse(
                                      mapNum(topRight.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1));
                                  var topRightYhat = double.parse(
                                      mapNum(topRight.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height)
                                          .toStringAsFixed(1));

                                  var bottomLeftX = bottomLeftIcon.dx + bottomLeftIconSize.width / 2;
                                  var bottomLeftY = bottomLeftIcon.dy + bottomLeftIconSize.height / 2;
                                  var bottomLeftXhat = double.parse(
                                      mapNum(bottomLeft.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width)
                                          .toStringAsFixed(1));
                                  var bottomLeftYhat = double.parse(
                                      mapNum(bottomLeft.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height)
                                          .toStringAsFixed(1));

                                  var bottomRightX = bottomRightIcon.dx + bottomRightIconSize.width / 2;
                                  var bottomRightY = bottomRightIcon.dy + bottomRightIconSize.height / 2;
                                  var bottomRightXhat = double.parse(
                                      mapNum(bottomRight.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width)
                                          .toStringAsFixed(1));
                                  var bottomRightYhat = double.parse(
                                      mapNum(bottomRight.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height)
                                          .toStringAsFixed(1));

                                  var centerX = centerIcon.dx + centerIconSize.width / 2;
                                  var centerY = centerIcon.dy + centerIconSize.height / 2;
                                  var centerXhat = double.parse(
                                      mapNum(center.dx, dimensions["inputA width"], dimensions["inputB width"], 0, _size.width).toStringAsFixed(1));
                                  var centerYhat = double.parse(
                                      mapNum(center.dy, dimensions["inputA height"], dimensions["inputB height"], 0, _size.height)
                                          .toStringAsFixed(1));
                                  return Container(
                                    height: 500,
                                    color: Colors.amber,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('Top Left'),
                                          Text('x: $topLeftX y: $topLeftY'),
                                          Text('x^: $topLeftXhat y^: $topLeftYhat'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Top Right'),
                                          Text('x: $topRightX y: $topRightY'),
                                          Text('x^: $topRightXhat y^: $topRightYhat'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Bottom Left'),
                                          Text('x: $bottomLeftX y: $bottomLeftY'),
                                          Text('x^: $bottomLeftXhat y^: $bottomLeftYhat'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Bottom Right'),
                                          Text('x: $bottomRightX y: $bottomRightY'),
                                          Text('x^: $bottomRightXhat y^: $bottomRightYhat'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Center'),
                                          Text('x: $centerX y: $centerY'),
                                          Text('x^: $centerXhat y^: $centerYhat'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text("Angle horizontal: "),
                                              Text("${calcAngle((topLeftX - topLeftXhat).abs(), 600, _size.width, 69)}"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Angle vertical: "),
                                              Text("${calcAngle((topLeftY - topLeftYhat).abs(), 600, _size.height, 150)}"),
                                            ],
                                          ),
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
                ),
                Center(child: Text("$_start")),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
