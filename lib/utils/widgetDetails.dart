import 'package:flutter/material.dart';

Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.localToGlobal(Offset.zero);
}

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.size;
}
