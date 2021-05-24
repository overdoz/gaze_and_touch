import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double mapNum(double input, double inputA, double inputZ, double outputA, double outputZ) {
  return (input - inputA) / (inputZ - inputA) * (outputZ - outputA) + outputA;
}

/// This function takes the dimensions of computer and mobile device
/// in order to calculate the percentual starting and endpoint of the inner screen
/// related to the outer screen.
/// [screenSize] = diagonal screen size of computer in inch
/// [mobileScreenSize] = diagonal screen size of mobile device in inch
Map<String, double> calcMeasurements(double screenSize, double aspectRatio, double mobileScreenSize, double mobileAspectRatio) {
  var measurements = new Map<String, double>();

  var heightScreen = screenSize / sqrt(pow(aspectRatio, 2) + 1);
  print("height screen: $heightScreen inch | ${heightScreen * 2.54} cm");

  var widthScreen = aspectRatio * heightScreen;
  print("desktopWidth: $widthScreen inch | ${widthScreen * 2.54} cm");

  var widthMobile = mobileScreenSize / sqrt(pow(mobileAspectRatio, 2) + 1);
  var heightMobile = mobileAspectRatio * widthMobile;
  print("mobile height: $heightMobile inch | ${heightMobile * 2.54} cm");
  print("mobile width: $widthMobile inch | ${widthMobile * 2.54} cm");

  var marginHorizontal = (widthScreen - widthMobile) / 2;
  var marginVertical = (heightScreen - heightMobile) / 2;

  /// horizontal starting and endpoint in percent
  var inputAWidth = marginHorizontal / widthScreen;
  var inputBWidth = inputAWidth + (widthMobile / widthScreen);

  /// vertical starting and endpoint in percent
  var inputAHeight = marginVertical / heightScreen;
  var inputBHeight = inputAHeight + (heightMobile / heightScreen);

  /// TODO: get aspect ratio from context

  measurements["inputA width"] = inputAWidth;
  print(measurements["inputA width"]);

  measurements["inputB width"] = inputBWidth;
  print(measurements["inputB width"]);

  measurements["inputA height"] = inputAHeight;
  print(measurements["inputA height"]);

  measurements["inputB height"] = inputBHeight;
  print(measurements["inputB height"]);


  return measurements;
}

Offset calcMeanPoint(List<Offset> offsets) {
  double sumX = 0;
  double sumY = 0;

  int l = offsets.length;
  print("length: $l");

  for(final coordinate in offsets) {
    print(coordinate);
    sumX = sumX + coordinate.dx;

    print(sumX);

    sumY = sumY + coordinate.dy;
    print(sumY);

  }

  return Offset(sumX / l, sumY / l);
}

double calcAngle(double pixel, double distance, double screenPixel, double screenMM) {
  // return (degrees(atan((pixel / 2) / (distance * screenPixel / screenMM))) * 2);
  return (degrees(atan((pixel / 2) / (distance * screenPixel / screenMM))) * 2);
}