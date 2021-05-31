import 'package:flutter/cupertino.dart';
import 'package:gazeAndTouch/utils/math.dart';
import '../models/screens_model.dart';


class AccuracyTarget {
  String name;
  Offset position;
  Offset recordedPos;
  Size size;
  GlobalKey key;
  double opacity;

  AccuracyTarget(this.name, this.position, this.recordedPos, this.size, this.opacity);

  void show() {
    this.opacity = 1;
  }

  void hide() {
    this.opacity = 0;
  }

  Offset getRecordedPos(ScreenSize size, Map<String, double> dimensions, Offset pos) {
    var x = double.parse(
        mapNum(pos.dx, dimensions["inputA width"], dimensions["inputB width"], 0, size.width).toStringAsFixed(1));
    var y = double.parse(
        mapNum(pos.dy, dimensions["inputA height"], dimensions["inputB height"], 0, size.height)
            .toStringAsFixed(1));

    return Offset(x, y);
  }
}