import 'package:flutter/cupertino.dart';
import 'package:gazeAndTouch/models/gaze_model.dart';
import 'package:gazeAndTouch/utils/math.dart';

import '../models/screens_model.dart';

class AccuracyTarget {
  String name;
  GazePoint position;
  GazePoint recordedPos;
  Size size;
  GlobalKey key;
  double opacity;
  double angleHorizontal = 0.0;
  double angleVertical = 0.0;

  AccuracyTarget({this.name, this.position, this.recordedPos, this.size, this.opacity});

  void show() {
    this.opacity = 1;
  }

  void hide() {
    this.opacity = 0;
  }

  GazePoint getRecordedPosInPx(ScreenSize size, Map<String, double> dimensions, GazePoint pos) {
    var x = double.parse(mapNum(pos.x, dimensions["inputA width"], dimensions["inputB width"], 0, size.width).toStringAsFixed(1));
    var y = double.parse(mapNum(pos.y, dimensions["inputA height"], dimensions["inputB height"], 0, size.height).toStringAsFixed(1));

    return GazePoint(x: x, y: y);
  }

  double getAngleHorizontal(ScreenSize size) {
    return calcAngle((position.x - recordedPos.x).abs(), 600, size.width, 69);
  }

  double getAngleVertical(ScreenSize size) {
    return calcAngle((position.y - recordedPos.y).abs(), 600, size.height, 150);
  }
}
