import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/accuracy_model.dart';
import 'package:gazeAndTouch/utils/csv_results.dart';
import 'package:gazeAndTouch/utils/math.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';

import '../models/screens_model.dart';
import '../shapes/painters.dart';
import '../utils/gaze_listener.dart';

class AccuracyScreen extends StatefulWidget {
  AccuracyScreen({Key key, this.dimensions}) : super(key: key);

  final Map<String, double> dimensions;

  @override
  _AccuracyScreenState createState() => _AccuracyScreenState(dimensions: this.dimensions);
}

class _AccuracyScreenState extends State<AccuracyScreen> {
  // add 10 initial gaze points hidden at (0,0)
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(0, 0)];

  Map<String, double> dimensions;

  List<GlobalKey> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  List<AccuracyTarget> targets = [
    AccuracyTarget("Top Left", Offset.zero, Offset.zero, Size.zero, 0),
    AccuracyTarget("Top Right", Offset.zero, Offset.zero, Size.zero, 0),
    AccuracyTarget("Center", Offset.zero, Offset.zero, Size.zero, 0),
    AccuracyTarget("Bottom Left", Offset.zero, Offset.zero, Size.zero, 0),
    AccuracyTarget("Bottom Right", Offset.zero, Offset.zero, Size.zero, 0),
  ];

  initTargets() {}

  /// listens to incoming gaze data
  GazeReceiver _gazeInput;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  _AccuracyScreenState({this.dimensions}) {
    _gazeInput = new GazeReceiver(_offsets, callback);
  }

  Timer _timer;
  int _start = 3;
  int _timerCounter = 5;

  Future<void> startTest(int counter) async {
    if (counter == 0) return;
    _start = 3;
    setState(() {
      targets[counter - 1].show();
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 1) {
          var pos = getWidgetPosition(keys[counter - 1]);
          var size = getWidgetSize(keys[counter - 1]);

          targets[counter - 1].recordedPos = calcMeanPoint(_offsets);
          targets[counter - 1].size = size;
          targets[counter - 1].position = Offset(pos.dx + size.width / 2, pos.dy + size.height / 2);
        }
        if (_start == 0) {
          setState(() {
            timer.cancel();
            targets[counter - 1].hide();
          });
          await startTest(counter - 1);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_timerCounter == 0) {
          setState(() {
            timer.cancel();
          });
          await startTest(5);
        } else {
          setState(() {
            _timerCounter--;
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
                              _createTarget(keys[0], targets[0].opacity),

                              /// Top Right
                              _createTarget(keys[1], targets[1].opacity),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Middle
                              _createTarget(keys[2], targets[2].opacity),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Bottom Left
                              _createTarget(keys[3], targets[3].opacity),

                              /// Bottom Rights
                              _createTarget(keys[4], targets[4].opacity),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  var horizontal = 0.0;
                                  var vertical = 0.0;
                                  for (var t in targets) {
                                    t.recordedPos = t.getRecordedPos(_size, dimensions, t.recordedPos);
                                    horizontal += calcAngle((t.position.dx - t.recordedPos.dx).abs(), 600, _size.width, 69);
                                    vertical += calcAngle((t.position.dy - t.recordedPos.dy).abs(), 600, _size.width, 150);
                                  }
                                  var angleHorizontal = horizontal / targets.length;
                                  var angleVertical = vertical / targets.length;

                                  return Container(
                                    height: 500,
                                    color: Colors.amber,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _createRecording("Top Left", targets[0]),
                                          _createRecording("Top Right", targets[1]),
                                          _createRecording("Bottom Left", targets[3]),
                                          _createRecording("Bottom Right", targets[4]),
                                          _createRecording("Center", targets[2]),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Angle horizontal: "),
                                              Text("${angleHorizontal.toStringAsFixed(3)}"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Angle vertical: "),
                                              Text("${angleVertical.toStringAsFixed(3)}"),
                                            ],
                                          ),
                                          ElevatedButton(
                                            child: const Text('Close BottomSheet'),
                                            // onPressed: () => Navigator.pop(context),
                                            onPressed: () {
                                              generateCsv(context);
                                            },
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
                Center(
                    child: Opacity(
                        opacity: 0.3,
                        child: Text(
                          _timerCounter != 0 ? "$_timerCounter" : "",
                          style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createRecording(String title, AccuracyTarget target) {
    return Column(
      children: [
        Text(title),
        Text('x: ${target.position.dx} y: ${target.position.dy}'),
        Text('x^: ${target.recordedPos.dx} y^: ${target.recordedPos.dy}'),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _createTarget(Key key, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          Icons.album_outlined,
          key: key,
        ),
      ),
    );
  }
}
