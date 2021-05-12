import 'dart:ffi';
import 'dart:ui';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import '../constants.dart';

typedef void VoidCallback();

class GazeReceiver {
  final VoidCallback callback;
  final InternetAddress addressesIListenFrom = InternetAddress.anyIPv4;

  GazeReceiver(List<Offset> gazeData, this.callback) {
    _init(gazeData, this.callback);
  }

  _init(List<Offset> gazeData, Function callback) {
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn, reusePort: true).then((RawDatagramSocket udpSocket) {
      udpSocket.forEach((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();

          /// read input coordinates and find semicolon for later parsing
          var coordinates = utf8.decode(dg.data);

          Map<String, dynamic> parsedGazeData;

          double rightEyeX;
          double rightEyeY;

          double leftEyeX;
          double leftEyeY;

          try {
            parsedGazeData = jsonDecode(coordinates);

            rightEyeX = parsedGazeData["right_gaze_point_on_display_area"][0];
            rightEyeY = parsedGazeData["right_gaze_point_on_display_area"][1];

            leftEyeX = parsedGazeData["left_gaze_point_on_display_area"][0];
            leftEyeY = parsedGazeData["left_gaze_point_on_display_area"][1];

          } catch(e) {
            print(e);
          }

          if (leftEyeX != null && leftEyeY != null) {
            gazeData.add(Offset(leftEyeX, leftEyeY));
            gazeData.removeAt(0);
          }

          if (rightEyeX != null && rightEyeY != null) {
            gazeData.add(Offset(rightEyeX, rightEyeY));
            gazeData.removeAt(0);
          }

          callback();

        }

      });
    });
  }
}
