import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:gazeAndTouch/models/gaze_model.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../constants.dart';

typedef void VoidCallback();

class GazeReceiver {
  final InternetAddress addressesIListenFrom = InternetAddress.anyIPv4;
  final VoidCallback callbackx;
  final List<Gaze> gazeList;
  final List<GazePoint> gazePointList;
  String currentTestTarget = "";
  GazePoint currentTargetPosition = GazePoint.initial();

  GazeReceiver(this.callbackx, this.gazeList, this.gazePointList);

  setTarget(String testType) {
    currentTestTarget = testType;
  }

  setTargetPosition(GazePoint gazePoint) {
    currentTargetPosition = gazePoint;
  }

  Stream<Gaze> createGazeStream() async* {
    print("create Stream");

    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn, reusePort: false).then(
      (RawDatagramSocket udpSocket) {
        udpSocket.forEach(
          (RawSocketEvent event) async* {
            if (event == RawSocketEvent.read) {
              Datagram dg = udpSocket.receive();

              print(dg);

              /// read input coordinates and find semicolon for later parsing
              var eyeTrackerData = utf8.decode(dg.data);

              Map<String, dynamic> parsedGazeData;

              print(eyeTrackerData);

              try {
                double combX;
                double combY;

                var timeStampEyeTracker = parsedGazeData[deviceTimeStamp];
                // var timeStamp = DateTime.now().toUtc().toString();

                parsedGazeData = jsonDecode(eyeTrackerData);

                var leftEye = parsedGazeData[leftGazePointOnDisplayArea];
                // leftEyeY = parsedGazeData[leftGazePointOnDisplayArea][1];

                var rightEye = parsedGazeData[rightGazePointOnDisplayArea];
                // rightEyeY = parsedGazeData[rightGazePointOnDisplayArea][1];

                /// Mean of left and right eye x coordinate
                if (leftEye[0] != null && rightEye[0] != null) {
                  combX = (leftEye[0] + rightEye[0]) / 2;
                } else {
                  combX = 100000.0;
                }

                /// Mean of left and right eye y coordinate
                if (leftEye[1] != null && rightEye[1] != null) {
                  combY = (leftEye[1] + rightEye[1]) / 2;
                } else {
                  combY = 100000.0;
                }

                var gazePoint = GazePoint(x: combX, y: combY);

                yield Gaze(gazePoint: gazePoint, timeStampEyeTracker: timeStampEyeTracker, timeStampDevice: 1);
              } catch (e) {
                // print(e);
              }
              // TODO: decrease rerendering
            }
          },
        );
      },
    );
  }

  Future<void> init(List<GazePoint> gazePoints, Function callback) async {
    AccelerometerEvent accelerometerEvent;
	UserAccelerometerEvent userAccelerometerEvent;
    GyroscopeEvent gyroscopeEvent;

    accelerometerEvents.listen((AccelerometerEvent event) {
      // print(event);
      accelerometerEvent = event;
    });
	
	userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      // print(event);
      userAccelerometerEvent = event;
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      //print(event);
      gyroscopeEvent = event;
    });

    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn, reusePort: false).then(
      (RawDatagramSocket udpSocket) {
        udpSocket.forEach(
          (RawSocketEvent event) async {
            if (event == RawSocketEvent.read) {
              Datagram dg = udpSocket.receive();

              double combX = 0.0;
              double combY = 0.0;

              /// read input coordinates and find semicolon for later parsing
              var eyeTrackerData = utf8.decode(dg.data);
              var timeStamp = DateTime.now().millisecondsSinceEpoch;
              var leftEye = [];
              var rightEye = [];
              var leftPupilDiameter = 0.0;
              var rightPupilDiameter = 0.0;
              var timeStampDevice = 0; // parsedGazeData[deviceTimeStamp];

              // print(eyeTrackerData);

              Map<String, dynamic> parsedGazeData;

              try {
                parsedGazeData = jsonDecode(eyeTrackerData);
              } catch (e) {
                print(e);
              }

              try {
                timeStampDevice = parsedGazeData[deviceTimeStamp] ?? 0;
              } catch (e) {
                print(e);
              }

              try {
                leftEye = parsedGazeData[leftGazePointOnDisplayArea] ?? 0.0;

                rightEye = parsedGazeData[rightGazePointOnDisplayArea] ?? 0.0;

                leftPupilDiameter = parsedGazeData[leftPupilDiameter] ?? 0.0;
                rightPupilDiameter = parsedGazeData[rightPupilDiameter] ?? 0.0;
              } catch (e) {
                print("Eye data parsing error:");
                print(e);
              }

              try {
                /// Mean of left and right eye x coordinate
                if (leftEye.isNotEmpty && rightEye.isNotEmpty && leftEye[0] != null && rightEye[0] != null) {
                  combX = (leftEye[0] + rightEye[0]) / 2;
                }

                /// Mean of left and right eye y coordinate
                if (leftEye.isNotEmpty && rightEye.isNotEmpty && leftEye[1] != null && rightEye[1] != null) {
                  combY = (leftEye[1] + rightEye[1]) / 2;
                }

                // print("x: $combX y: $combY");
                var gazePoint = GazePoint(x: combX, y: combY);

                gazeList.add(Gaze(
                    gazePoint: gazePoint,
                    timeStampEyeTracker: timeStampDevice,
                    timeStampDevice: timeStamp,
                    currentTarget: currentTestTarget,
                    currentTargetPosition: currentTargetPosition,
                    accelerometerEvent: accelerometerEvent,
					userAccelerometerEvent: userAccelerometerEvent,
                    gyroscopeEvent: gyroscopeEvent));
                gazePoints.add(gazePoint);
                gazePoints.removeAt(0);
                callback();
              } catch (e) {
                print("Add gaze error:");
                print(e);
              }
              // TODO: decrease rerendering
            }
          },
        );
      },
    );
  }
}
