import 'package:flutter/material.dart';

Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.localToGlobal(Offset.zero);
}

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.size;
}

bool isWithinWidget(Offset gazePoint, Offset widgetPosition, Size widgetSize) {
  return gazePoint.dx > widgetPosition.dx
      && gazePoint.dx < widgetPosition.dx + widgetSize.width
      && gazePoint.dy > widgetPosition.dy
      && gazePoint.dy < widgetPosition.dy + widgetSize.height;
}