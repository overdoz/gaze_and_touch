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
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn).then((RawDatagramSocket udpSocket) {
      udpSocket.forEach((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();

          /// read input coordinates and find semicolon for later parsing
          var coordinates = utf8.decode(dg.data);

          /// remove parenthesis
          var coordinatesDigits = coordinates.replaceAll(new RegExp(r'\('), '').replaceAll(new RegExp(r'\)'), '');

          /// ignore values which doesn't represent a number
          if (RegExp(r"0\.[0-9]{15,18}..?0\.[0-9]{15,18}..?0\.[0-9]{15,18}..?0\.[0-9]{15,18}").hasMatch(coordinatesDigits)) {
            /// split up package into left and right eye lists
            List<String> rawLines = coordinatesDigits.split(';');

            /// split up left eye into x and y coordinates
            List<String> leftEye = rawLines[0].split(', ');

            /// split up right eye into x and y coordinates
            List<String> rightEye = rawLines[1].split(', ');

            /// add Left eye data and remove first offset
            gazeData.add(Offset(double.parse(leftEye[0]), double.parse(leftEye[1])));
            gazeData.removeAt(0);

            /// add Right eye data and remove first offset
            gazeData.add(Offset(double.parse(rightEye[0]), double.parse(rightEye[1])));
            gazeData.removeAt(0);

            /// trigger setState callback function
            callback();
          }
        }
        // udpSocket.close();
      });
    });
  }
}
