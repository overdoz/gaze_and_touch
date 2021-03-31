static import 'package:flutter/material.dart';

import 'package:flutter/material.dart';


Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  return renderBox.localToGlobal(Offset.zero);
}