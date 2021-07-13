import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/utils/math.dart';

class Gaze {
  final GazePoint gazePoint;
  final int timeStampEyeTracker;
  final int timeStampDevice;
  final String currentTarget;

  List get studyData {
    return [gazePoint.x, gazePoint.y, timeStampEyeTracker, timeStampDevice];
  }

  String get sx {
    return gazePoint.x.toString();
  }

  String get sy {
    return gazePoint.y.toString();
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

  Gaze({this.gazePoint, this.timeStampEyeTracker, this.timeStampDevice, this.currentTarget});
}

class GazePoint {
  final double x;
  final double y;

  GazePoint({this.x, this.y});

  String get sx {
    return x.toString();
  }

  String get sy {
    return y.toString();
  }

  GazePoint getRecordedPosInPx(ScreenSize size, Map<String, double> dimensions, GazePoint pos) {
    var x = double.parse(mapNum(pos.x, dimensions["inputA width"], dimensions["inputB width"], 0, size.width).toStringAsFixed(1));
    var y = double.parse(mapNum(pos.y, dimensions["inputA height"], dimensions["inputB height"], 0, size.height).toStringAsFixed(1));

    return GazePoint(x: x, y: y);
  }

  static GazePoint initial() {
    return GazePoint(x: 0.0, y: 0.0);
  }
}
