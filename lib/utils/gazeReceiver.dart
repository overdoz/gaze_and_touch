import 'dart:ffi';
import 'dart:ui';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import '../models/screenDetails.dart';

class GazeReceiver {
  var addressesIListenFrom = InternetAddress.anyIPv4;
  final int portIListenOn = 65002;

  GazeReceiver(List<Offset> gazeData, ScreenSize size) {
    _init(gazeData, size);
  }

  _init(List<Offset> gazeData, ScreenSize size) {
    RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.forEach((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();

          /// read input coordinates and find semicolon for later parsing
          var coordinates = utf8.decode(dg.data);
          var indxFirstSemicolon = coordinates.indexOf(";");

          /// coordinates as strings
          var xDecode = coordinates
              .substring(0, indxFirstSemicolon)
              .replaceAll(new RegExp(r','), '.');

          var yDecode = coordinates
              .substring(indxFirstSemicolon + 1, coordinates.length - 1)
              .replaceAll(new RegExp(r','), '.');

          /// coodinates as double
          var x = double.parse(xDecode);
          var y = double.parse(yDecode);

          /// remove outliers and add gazepoint to array
          /// setState() ensures rerendering
          if (x != 0.0) {
            gazeData.add(Offset(x * size.width, y * size.height));
            gazeData.removeAt(0);
          }
        }
      });
    });
  }
}
