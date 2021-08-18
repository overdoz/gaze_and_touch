import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/utils/math.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Gaze {
  final GazePoint gazePoint;
  final int timeStampEyeTracker;
  final int timeStampDevice;
  final String currentTarget;
  final GazePoint currentTargetPosition;
  final AccelerometerEvent accelerometerEvent;
  final UserAccelerometerEvent userAccelerometerEvent;
  final GyroscopeEvent gyroscopeEvent;
  final double leftPupilDiameter;
  final double rightPupilDiameter;

  List get studyData {
    return [gazePoint.x, gazePoint.y, timeStampEyeTracker, timeStampDevice];
  }

  String get sx {
    return gazePoint.x.toStringAsFixed(4);
  }

  String get sy {
    return gazePoint.y.toStringAsFixed(4);
  }

  double get dx {
    return gazePoint.x;
  }

  double get dy {
    return gazePoint.y;
  }

  String get getTimeEyeTracker {
    return timeStampEyeTracker.toString();
  }

  String get getTimeDevice {
    return timeStampDevice.toString();
  }

  Gaze(
      {this.gazePoint,
      this.timeStampEyeTracker,
      this.timeStampDevice,
      this.currentTarget,
      this.currentTargetPosition,
      this.accelerometerEvent,
      this.userAccelerometerEvent,
      this.gyroscopeEvent,
      this.leftPupilDiameter,
      this.rightPupilDiameter});
}

class GazePoint {
  final double x;
  final double y;

  GazePoint({this.x, this.y});

  String get sx {
    return x.toStringAsFixed(4);
    ;
  }

  String get sy {
    return y.toStringAsFixed(4);
    ;
  }

  GazePoint getRecordedPosInPx(ScreenSize size, Map<String, double> dimensions, GazePoint pos) {
    if (pos.x == 0.0 && pos.y == 0.0) return GazePoint.initial();

    var x = double.parse(mapNum(pos.x, dimensions["inputA width"], dimensions["inputB width"], 0, size.width).toStringAsFixed(4));
    var y = double.parse(mapNum(pos.y, dimensions["inputA height"], dimensions["inputB height"], 0, size.height).toStringAsFixed(4));

    return GazePoint(x: x, y: y);
  }

  static GazePoint initial() {
    return GazePoint(x: 0.0, y: 0.0);
  }
}
