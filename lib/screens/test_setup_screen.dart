import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/user_test_model.dart';
import 'package:gazeAndTouch/screens/accuracy_screen.dart';

class TestSetup extends StatefulWidget {
  TestSetup({Key key, this.dimensions}) : super(key: key);

  final Map<String, double> dimensions;

  @override
  _TestSetupState createState() => _TestSetupState(dimensions: this.dimensions);
}

class _TestSetupState extends State<TestSetup> {
  Map<String, double> dimensions;
  UserTest userTest = UserTest();

  _TestSetupState({this.dimensions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      decoration: InputDecoration(labelText: "Name", hintText: "Participant name"),
                      onChanged: (name) {
                        userTest.name = name;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      decoration: InputDecoration(labelText: "Test type", hintText: "body position"),
                      onChanged: (testType) {
                        userTest.testType = testType;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccuracyScreen(
                            dimensions: dimensions,
                            userTest: userTest,
                          ),
                        ),
                      );
                    },
                    child: Text("Start test"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
