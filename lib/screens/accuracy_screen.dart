import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/accuracy_model.dart';
import 'package:gazeAndTouch/models/gaze_model.dart';
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
  /// add 10 initial gaze points hidden at (0,0)
  final _gazePoints = <GazePoint>[for (var i = 0; i < 10; i++) GazePoint.initial()];
  final _userData = <Gaze>[];

  Map<String, double> dimensions;

  List<GlobalKey> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  List<AccuracyTarget> targets = [
    AccuracyTarget(name: "Top Left", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
    AccuracyTarget(name: "Top Right", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
    AccuracyTarget(name: "Center", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
    AccuracyTarget(name: "Bottom Left", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
    AccuracyTarget(name: "Bottom Right", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
  ];

  /// listens to incoming gaze data
  GazeReceiver _gazeInput;
  Stream<Gaze> _gazeStream;

  Timer _timer;
  int _start = 3;
  int _timerCounter = 5;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  _AccuracyScreenState({this.dimensions}) {
    _gazeInput = new GazeReceiver(this.callback, this._userData, this._gazePoints);
  }

  void callback() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _gazeInput.init(this._gazePoints, this.callback);
    // _gazeStream = _gazeInput.createGazeStream();
    // _gazeInput.init();
    // var subscription = _gazeStream.listen((gaze) {
    //   setState(() {
    //     /// collect data for rendering
    //     _gazePoints.add(gaze.gazePoint);
    //     _gazePoints.removeAt(0);
    //
    //     /// collect data for study
    //     _userData.add(gaze);
    //   });
    // });
    print("init State");
    startTimer();

    // subscription.cancel();
  }

  // TODO: collect IMU data
  Future<void> startTest(int counter) async {
    /// listen to stream
    // var subscription = _gazeStream.listen((gaze) {
    //   setState(() {
    //     /// collect data for rendering
    //     _gazePoints.add(gaze.gazePoint);
    //     _gazePoints.removeAt(0);
    //
    //     /// collect data for study
    //     _userData.add(gaze);
    //   });
    // });

    Future<void> iterateTest(int c) async {
      if (c == 0) return;
      _start = 3;
      setState(() {
        targets[c - 1].show();
      });
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) async {
          if (_start == 1) {
            var pos = getWidgetPosition(keys[c - 1]);
            var size = getWidgetSize(keys[c - 1]);

            /// record all metrics when the timer hits 1
            targets[c - 1].recordedPos = calcMeanPoint(_gazePoints);
            targets[c - 1].size = size;
            targets[c - 1].position = GazePoint(x: pos.dx + size.width / 2, y: pos.dy + size.height / 2);
          }
          if (_start == 0) {
            setState(() {
              timer.cancel();
              targets[c - 1].hide();
            });
            await iterateTest(c - 1);
          } else {
            setState(() {
              _start--;
            });
          }
        },
      );
      if (c == 0) {
        // subscription.cancel();
      }
    }

    iterateTest(counter);
  }

  Future<void> startTimer() async {
    /// create stream for timer
    var counterStream = Stream<int>.periodic(Duration(seconds: 1), (x) => x).take(5);
    counterStream.forEach(
      (e) => {
        setState(
          () {
            _timerCounter--;
          },
        ),
        if (_timerCounter == 0) {startTest(5)}
      },
    );
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
                    child: CustomPaint(painter: FaceOutlinePainter(_gazePoints, _size, dimensions)),
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
                              // TODO: create CSV
                              var matrix = _generateDataMatrix(this._userData);
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  var horizontal = 0.0;
                                  var vertical = 0.0;
                                  for (var target in targets) {
                                    target.recordedPos = target.getRecordedPosInPx(_size, dimensions, target.recordedPos);
                                    horizontal += calcAngle((target.position.x - target.recordedPos.x).abs(), 600, _size.width, 69);
                                    vertical += calcAngle((target.position.y - target.recordedPos.y).abs(), 600, _size.width, 150);
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
                                          _createAngle("Angle horizontal: ", angleHorizontal.toStringAsFixed(3)),
                                          _createAngle("Angle vertical: ", angleVertical.toStringAsFixed(3)),
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
                _createCountdown(_timerCounter),
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
        Text('x: ${target.position.x} y: ${target.position.y}'),
        Text('x^: ${target.recordedPos.x} y^: ${target.recordedPos.y}'),
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

  Widget _createAngle(String title, String angle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        Text(angle),
      ],
    );
  }

  Widget _createCountdown(int counter) {
    return Center(
      child: Opacity(
        opacity: 0.3,
        child: Text(
          counter != 0 ? "$counter" : "",
          style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<List> _generateDataMatrix(List<Gaze> gazeData) {
    return gazeData.map((gaze) => [gaze.gazePoint.x, gaze.gazePoint.y, gaze.timeStampDevice, gaze.timeStampEyeTracker]).toList();
  }
}
