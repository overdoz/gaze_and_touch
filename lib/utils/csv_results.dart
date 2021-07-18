import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/gaze_model.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/models/user_test_model.dart';
import 'package:gazeAndTouch/screens/load_csv_data_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

generateCsv(BuildContext context) async {
  List<List<String>> data = [
    ["No.", "Name", "Pos X", "Pos Y", "Rec X", "Rec Y"],
    ["1.", "Top Left", "233.2", "432.6", "231.1", "433.6"],
  ];
  String csvData = ListToCsvConverter().convert(data);
  final String directory = (await getApplicationSupportDirectory()).path;
  final path = "$directory/csv-${DateTime.now()}.csv";
  print(path);
  final File file = File(path);
  await file.writeAsString(csvData);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) {
        return LoadCsvDataScreen(path: path);
      },
    ),
  );
}

saveTestResultToLocalStorage(UserTest userTest, ScreenSize size, Map<String, double> dimensions) async {
  var horizontal = 0.0;
  var vertical = 0.0;
  for (var target in userTest.targetResults) {
    target.recordedPos = target.getRecordedPosInPx(size, dimensions, target.recordedPos);
    horizontal += target.getAngleHorizontal(size);
    vertical += target.getAngleVertical(size);
  }
  var angleHorizontal = horizontal / userTest.targetResults.length;
  var angleVertical = vertical / userTest.targetResults.length;

  List<List<String>> data = [
    ["User id", "Date", "Test Type", "Target id", "X", "X^", "Angle horizontal", "Angle horizontal combined", "Y", "Y^", "Angle vertical", "Angle vertical combined"],
  ];

  userTest.targetResults.forEach((d) {
    data.add([
      userTest.name,
      userTest.date,
      userTest.testType,
      d.name,
      d.position.sx,
      d.recordedPos.sx,
      d.getAngleHorizontal(size).toString(),
      angleHorizontal.toString(),
      d.position.sy,
      d.recordedPos.sy,
      d.getAngleVertical(size).toString(),
      angleVertical.toString()
    ]);
  });

  if (await Permission.storage.request().isGranted) {
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    print(directory);
    // final path = "$directory/csv-${DateTime.now()}.csv";
    final path = "/storage/emulated/0/Download/${userTest.name}-${userTest.testType}-${DateTime.now()}.csv";
    // print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
  }
}

saveDataToLocalStorage(UserTest userTest, ScreenSize size, Map<String, double> dimensions) async {
  List<List<String>> data = [
    ["User Id", "Date", "Test Type", "X px", "Y px", "X", "Y", "Timestamp Device", "Timestamp EyeTracker", "Target", "Target X", "Target Y", "Acc X", "Acc Y", "Acc Z", "Gy X", "Gy Y", "Gy Z"],
  ];

  userTest.gazeData.forEach((e) {
    GazePoint pointInPx = e.gazePoint.getRecordedPosInPx(size, dimensions, e.gazePoint);
    data.add([
      userTest.name,
      userTest.date,
      userTest.testType,
      pointInPx.sx,
      pointInPx.sy,
      e.sx,
      e.sy,
      e.getTimeDevice,
      e.getTimeEyeTracker,
      e.currentTarget,
      e.currentTargetPosition.sx,
      e.currentTargetPosition.sy,
      e.accelerometerEvent.x.toString(),
      e.accelerometerEvent.y.toString(),
      e.accelerometerEvent.z.toString(),
      e.gyroscopeEvent.x.toString(),
      e.gyroscopeEvent.y.toString(),
      e.gyroscopeEvent.z.toString()
    ]);
  });

  // var status = await Permission.storage.status;
  if (await Permission.storage.request().isGranted) {
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    print(directory);
    // final path = "$directory/csv-${DateTime.now()}.csv";
    final path = "/storage/emulated/0/Download/${userTest.name}-${userTest.testType}-${DateTime.now()}-all.csv";
    // print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
  }
}
