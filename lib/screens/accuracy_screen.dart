import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/accuracy_model.dart';
import 'package:gazeAndTouch/models/gaze_model.dart';
import 'package:gazeAndTouch/models/user_test_model.dart';
import 'package:gazeAndTouch/utils/csv_results.dart';
import 'package:gazeAndTouch/utils/math.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/screens_model.dart';
import '../shapes/painters.dart';
import '../utils/gaze_listener.dart';

class AccuracyScreen extends StatefulWidget {
  AccuracyScreen({Key key, this.dimensions, this.userTest}) : super(key: key);

  final Map<String, double> dimensions;
  final UserTest userTest;

  @override
  _AccuracyScreenState createState() => _AccuracyScreenState(dimensions: this.dimensions, userTest: this.userTest);
}

class _AccuracyScreenState extends State<AccuracyScreen> {
  /// add 10 initial gaze points hidden at (0,0)
  final _gazePoints = <GazePoint>[for (var i = 0; i < 10; i++) GazePoint.initial()];
  final _userData = <Gaze>[];

  Map<String, double> dimensions;
  UserTest userTest;

  List<GlobalKey> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  // List<AccuracyTarget> targets = [
  //   AccuracyTarget(name: "Top Left", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
  //   AccuracyTarget(name: "Top Right", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
  //   AccuracyTarget(name: "Center", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
  //   AccuracyTarget(name: "Bottom Left", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
  //   AccuracyTarget(name: "Bottom Right", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
  // ];

  /// listens to incoming gaze data
  GazeReceiver gazeInput;
  Stream<Gaze> _gazeStream;

  Timer _timer;
  int _start = 3;
  int _timerCounter = 5;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  _AccuracyScreenState({this.dimensions, this.userTest}) {
    gazeInput = new GazeReceiver(this.callback, this._userData, this._gazePoints);
  }

  void callback() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    gazeInput.init(this._gazePoints, this.callback);
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
    // userTest.targetResults = shuffle(userTest.targetResults);
    startTimer();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      print(event);
    });

    // subscription.cancel();
  }

  // TODO: collect IMU data
  Future<void> startTest(int counter) async {
    /// create indices and shuffle them
    var targetIndex = [for (var i = 0; i < userTest.targetResults.length; i++) i];
    targetIndex = shuffle(targetIndex);

    Future<void> iterateTest(int c) async {
      if (c == 0) return;

      var targets = userTest.targetResults;
      var randomIndex = targetIndex.removeLast();

      /// initialize target infos
      var pos = getWidgetPosition(keys[randomIndex]);
      var size = getWidgetSize(keys[randomIndex]);
      var targetPosition = GazePoint(x: pos.dx + size.width / 2, y: pos.dy + size.height / 2);

      /// log target infos
      this.gazeInput.setTarget((targets[randomIndex].name));
      this.gazeInput.setTargetPosition(targetPosition);

      _start = 3;
      setState(() {
        targets[randomIndex].show();
      });
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) async {
          if (_start == 1) {
            /// record all metrics when the timer hits 1
            targets[randomIndex].recordedPos = calcMeanPoint(_gazePoints);
            targets[randomIndex].size = size;
            targets[randomIndex].position = targetPosition;
          }
          if (_start == 0) {
            setState(() {
              timer.cancel();
              targets[randomIndex].hide();
              this.gazeInput.setTarget("");
            });
            await iterateTest(c - 1);
          } else {
            setState(() {
              _start--;
            });
          }
        },
      );
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
    var targets = userTest.targetResults;

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
                              userTest.gazeData = this._userData;
                              saveTestResultToLocalStorage(userTest, _size, dimensions);
                              saveDataToLocalStorage(userTest, _size, dimensions);

                              // var matrix = _generateDataMatrix(this._userData);
                              // saveDataToLocalStorage(matrix);

                              //   showModalBottomSheet<void>(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return Container(
                              //         height: 700,
                              //         color: Colors.amber,
                              //         child: Center(
                              //           child: Column(
                              //             mainAxisAlignment: MainAxisAlignment.center,
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: <Widget>[
                              //               _createRecording("Top Left", targets[0]),
                              //               _createRecording("Top Right", targets[1]),
                              //               _createRecording("Bottom Left", targets[3]),
                              //               _createRecording("Bottom Right", targets[4]),
                              //               _createRecording("Center", targets[2]),
                              //               _createAngle("Angle horizontal: ", angleHorizontal.toStringAsFixed(3)),
                              //               _createAngle("Angle vertical: ", angleVertical.toStringAsFixed(3)),
                              //               ElevatedButton(
                              //                 child: const Text('Close BottomSheet'),
                              //                 // onPressed: () => Navigator.pop(context),
                              //                 onPressed: () {
                              //                   generateCsv(context);
                              //                 },
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   );
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

  List<List<String>> _generateDataMatrix(List<Gaze> gazeData) {
    return gazeData.map((gaze) => [gaze.sx, gaze.sy, gaze.getTimeDevice, gaze.getTimeEyeTracker]).toList();
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}
