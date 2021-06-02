import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:gazeAndTouch/screens/load_csv_data_screen.dart';
import 'package:path_provider/path_provider.dart';

generateCsv(context) async {
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
