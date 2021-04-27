import 'package:flutter/material.dart';

RenderBox getWidget(GlobalKey key) {
  return key.currentContext.findRenderObject();
}

Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.localToGlobal(Offset.zero);
}

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.size;
}

bool isWithinWidget(Offset gazePoint, RenderBox widget) {
  final widgetSize = widget.size;
  final widgetPosition = widget.localToGlobal(Offset.zero);

  return gazePoint.dx > widgetPosition.dx
      && gazePoint.dx < widgetPosition.dx + widgetSize.width
      && gazePoint.dy > widgetPosition.dy
      && gazePoint.dy < widgetPosition.dy + widgetSize.height;
}