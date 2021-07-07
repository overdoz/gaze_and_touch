import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
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

saveData(List<List<String>> results) async {
  List<List<String>> data = [
    ["X", "Y", "Timestamp Device", "Timestamp EyeTracker"],
  ];

  results.forEach((element) {
    data.add(element);
  });

  // var status = await Permission.storage.status;
  if (await Permission.storage.request().isGranted) {
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    print(directory);
    // final path = "$directory/csv-${DateTime.now()}.csv";
    final path = "/storage/emulated/0/Download/csv-${DateTime.now()}.csv";
    // print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
  }
}
