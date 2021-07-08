import 'dart:ui';

import 'package:gazeAndTouch/models/accuracy_model.dart';
import 'package:gazeAndTouch/models/gaze_model.dart';

class UserTest {
  String name;
  String testType;
  List<Gaze> gazeData = [];
  DateTime dateTime;
  List<AccuracyTarget> targetResults;

  UserTest({this.name, this.testType, this.targetResults, this.gazeData}) {
    targetResults = [
      AccuracyTarget(name: "Top Left", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
      AccuracyTarget(name: "Top Right", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
      AccuracyTarget(name: "Center", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
      AccuracyTarget(name: "Bottom Left", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
      AccuracyTarget(name: "Bottom Right", position: GazePoint.initial(), recordedPos: GazePoint.initial(), size: Size.zero, opacity: 0),
    ];

    dateTime = DateTime.now();
  }

  String get date {
    return dateTime.toString();
  }

  List<List<String>> get generateExportData {
    return gazeData.map((gaze) => [gaze.sx, gaze.sy, gaze.getTimeDevice, gaze.getTimeEyeTracker]).toList();
  }
}
