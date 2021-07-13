import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/gaze_model.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/utils/math.dart';

class FaceOutlinePainter extends CustomPainter {
  final List<GazePoint> gazePoints;
  final ScreenSize screen;
  final Map<String, double> dimensions;

  FaceOutlinePainter(this.gazePoints, this.screen, this.dimensions) : super();

  @override
  void paint(Canvas canvas, Size size) {
    /// Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    /// iterate through all gazepoints
    for (var point in gazePoints) {
      // var screenPoint = Offset(mapNum(point.x, dimensions["inputA width"], dimensions["inputB width"], 0, screen.width),
      //     mapNum(point.y, dimensions["inputA height"], dimensions["inputB height"], 0, screen.height));
      var screenPoint = Offset(mapNum(point.x, 0.392, 0.6159, 0, screen.width), mapNum(point.y, 0.154, 0.71, 0, screen.height));
      canvas.drawPoints(PointMode.points, [screenPoint], paint);
    }
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => true;
}

class WheelPainter extends CustomPainter {
  Path getWheelPath(double wheelSize, double fromRadius, double toRadius) {
    return new Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(Rect.fromCircle(radius: wheelSize, center: Offset(wheelSize, wheelSize)), fromRadius, toRadius, false)
      ..close();
  }

  Paint getColoredPaint(Color color) {
    Paint paint = Paint();
    paint.color = color;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 20;
    double nbElem = 6;
    double radius = (2 * pi) / nbElem;

    canvas.drawPath(getWheelPath(wheelSize, 0, radius), getColoredPaint(Colors.red));
    canvas.drawPath(getWheelPath(wheelSize, radius, radius), getColoredPaint(Colors.purple));
    canvas.drawPath(getWheelPath(wheelSize, radius * 2, radius), getColoredPaint(Colors.blue));
    canvas.drawPath(getWheelPath(wheelSize, radius * 3, radius), getColoredPaint(Colors.green));
    canvas.drawPath(getWheelPath(wheelSize, radius * 4, radius), getColoredPaint(Colors.yellow));
    canvas.drawPath(getWheelPath(wheelSize, radius * 5, radius), getColoredPaint(Colors.orange));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
