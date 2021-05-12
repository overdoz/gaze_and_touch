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

          double leftEyeX;
          double leftEyeY;

          double rightEyeX;
          double rightEyeY;

          try {
            parsedGazeData = jsonDecode(coordinates);

            print(parsedGazeData);

            leftEyeX = parsedGazeData[leftGazePointOnDisplayArea][0];
            leftEyeY = parsedGazeData[leftGazePointOnDisplayArea][1];

            rightEyeX = parsedGazeData[rightGazePointOnDisplayArea][0];
            rightEyeY = parsedGazeData[rightGazePointOnDisplayArea][1];

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
