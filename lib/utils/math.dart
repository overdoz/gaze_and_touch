import 'dart:math';

double mapNum(double input, double inputA, double inputZ, double outputA, double outputZ) {
  return (input - inputA) / (inputZ - inputA) * (outputZ - outputA) + outputA;
}

Map<String, double> calcMeasurements(screenSize, aspectRatio, mobileScreenSize, mobileAspectRatio) {
  var measurements = new Map();

  var heightScreen = screenSize / sqrt(pow(aspectRatio, 2) + 1);
  var widthScreen = aspectRatio * heightScreen;

  var heightMobile = mobileScreenSize / sqrt(pow(mobileAspectRatio, 2) + 1);
  var widthMobile = aspectRatio * heightMobile;

  var marginHorizontal = (widthScreen - widthMobile) / 2;
  var marginVertical = (heightScreen - heightMobile) / 2;

  var inputAWidth = marginHorizontal / widthScreen * 100;
  var inputBWidth = inputAWidth + (widthMobile / widthScreen * 100);

  var inputAHeight = marginVertical / heightScreen * 100;
  var inputBHeight = inputAHeight + (heightMobile / heightScreen * 100);

  /// TODO: get aspect ratio from context

  measurements["inputA width"] = inputAWidth;
  measurements["inputB width"] = inputBWidth;
  measurements["inputA height"] = inputAHeight;
  measurements["inputB height"] = inputBHeight;


  return measurements;
}