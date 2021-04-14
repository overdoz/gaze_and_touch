import 'dart:ffi';
import 'dart:ui';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import '../models/screenDetails.dart';

typedef void VoidCallback();

class GazeReceiver {
  final VoidCallback callback;

  final InternetAddress addressesIListenFrom = InternetAddress.anyIPv4;
  final int portIListenOn = 65002;

  GazeReceiver(List<Offset> gazeData, ScreenSize size, this.callback) {
    _init(gazeData, size, this.callback);
  }

  _init(List<Offset> gazeData, ScreenSize size, Function callback) {
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.forEach((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();

          print(dg);
          /// read input coordinates and find semicolon for later parsing
          var coordinates = utf8.decode(dg.data);
          var indxFirstSemicolon = coordinates.indexOf(";");

          var coordinatesDigits = coordinates
              .replaceAll(new RegExp(r'\('), '')
              .replaceAll(new RegExp(r'\)'), '');

          if (RegExp(r"(0.([0-9])\w+)..(0.([0-9])\w+)..(0.([0-9])\w+)..(0.([0-9])\w+)").hasMatch(coordinatesDigits)) {
            List<String> rawLines = coordinatesDigits.split(';');
            List<String> leftEye = rawLines[0].split(', ');
            List<String> rightEye = rawLines[1].split(', ');

            print("$leftEye $rightEye");


            if(leftEye[0] != "nan" && leftEye[1] != "nan" && rightEye[0] != "nan" && rightEye[1] != "nan") {
              gazeData.add(Offset(double.parse(leftEye[0]) * size.width, double.parse(leftEye[1]) * size.height));
              gazeData.add(Offset(double.parse(rightEye[0]) * size.width, double.parse(rightEye[1]) * size.height));
              gazeData.removeAt(0);
              gazeData.removeAt(1);
              callback();
            }
          }

          // print(coordinatesDigits);

          /// coordinates as strings
          // var xDecode = coordinates
          //     .substring(0, indxFirstSemicolon)
          //     .replaceAll(new RegExp(r','), '.');
          //
          // var yDecode = coordinates
          //     .substring(indxFirstSemicolon + 1, coordinates.length - 1)
          //     .replaceAll(new RegExp(r','), '.');
          //
          // /// coodinates as double
          // var x = double.parse(xDecode);
          // var y = double.parse(yDecode);
          //
          // print("x: $x, y: $y");

          /// remove outliers and add gazepoint to array
          /// setState() ensures rerendering
          // if (x != 0.0) {
          //   gazeData.add(Offset(x * size.width, y * size.height));
          //   gazeData.removeAt(0);
          //   callback();
          // }
        }
      });
    });
  }

  void trigger(
    widgetDetails,
  ) {}
}
