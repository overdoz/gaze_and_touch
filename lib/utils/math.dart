import 'dart:math';

import 'package:gazeAndTouch/models/gaze_model.dart';
import 'package:vector_math/vector_math.dart';

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
  var inputAHeight = marginVertical / heightScreen; // correction
  var inputBHeight = inputAHeight + (heightMobile / heightScreen);

  /// TODO: get aspect ratio from context

  measurements["inputA width"] = inputAWidth;

  measurements["inputB width"] = inputBWidth;

  measurements["inputA height"] = inputAHeight;
  print("InputA Height:");
  print(measurements["inputA height"]);

  measurements["inputB height"] = inputBHeight;

  return measurements;
}

GazePoint calcMeanPoint(List<GazePoint> gazePoints) {
  double sumX = 0;
  double sumY = 0;

  int l = gazePoints.length;

  for (final gaze in gazePoints) {
    sumX = sumX + gaze.x;
    sumY = sumY + gaze.y;
  }

  return GazePoint(x: (sumX / l), y: (sumY / l));
}

double calcAngle(double pixel, double distance, double screenPixel, double screenMM) {
  // return (degrees(atan((pixel / 2) / (distance * screenPixel / screenMM))) * 2);
  return (degrees(atan((pixel / 2) / (distance * screenPixel / screenMM))) * 2);
}
