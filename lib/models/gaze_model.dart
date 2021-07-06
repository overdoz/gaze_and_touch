class Gaze {
  final GazePoint gazePoint;
  final String timeStampEyeTracker;
  final String timeStampDevice;

  List get studyData {
    return [gazePoint.x, gazePoint.y, timeStampEyeTracker, timeStampDevice];
  }

  Gaze({this.gazePoint, this.timeStampEyeTracker, this.timeStampDevice});
}

class GazePoint {
  final double x;
  final double y;

  GazePoint({this.x, this.y});

  static GazePoint initial() {
    return GazePoint(x: 0.0, y: 0.0);
  }
}
