import 'package:flutter/cupertino.dart';

class AccuracyTarget {
  final Offset position;
  final Offset recordedPos;
  final Size size;
  GlobalKey key;
  double opacity;

  AccuracyTarget(this.position, this.recordedPos, this.size, this.opacity);
}