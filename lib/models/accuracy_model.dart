import 'package:flutter/cupertino.dart';

class AccuracyTarget {
  Offset position;
  Offset recordedPos;
  Size size;
  GlobalKey key;
  double opacity;

  AccuracyTarget(this.position, this.recordedPos, this.size, this.opacity);

  void show() {
    this.opacity = 1;
  }

  void hide() {
    this.opacity = 0;
  }
}