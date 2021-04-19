import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/widgets/notifications.dart';
import '../shapes/painters.dart';
import '../widgets/notifications.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey backButtonKey = GlobalKey();
  final GlobalKey<NotificationsBannerState> bannerKey = GlobalKey<NotificationsBannerState>();
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(100, 200)];

  double heightNotification = 40;
  double widthNotification = 400;

  @override
  Widget build(BuildContext context) {

    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ScreenSize size = ScreenSize(height, width);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Scaffold(
                body: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                                  key: backButtonKey,
                                  child: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Text("Plantygram"),
                            ],
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                ElevatedButton(
                                  child: heightNotification != 300
                                      ? Text('Expand')
                                      : Text('Close'),
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (heightNotification == 40) {
                                          heightNotification = 300;
                                          widthNotification = 400;
                                        } else {
                                          heightNotification = 40;
                                          widthNotification = 100;
                                        }
                                      },
                                    );
                                  },
                                ),

                                ElevatedButton(
                                  child: Text("Drop it"),
                                  onPressed: () {
                                    setState(
                                          () {
                                        if (bannerKey.currentState.isUp) {
                                          bannerKey.currentState.moveDown();
                                        } else {
                                          bannerKey.currentState.moveUp();
                                        }
                                      },
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Increase"),
                                  onPressed: () {
                                    setState(
                                          () {
                                        if (bannerKey.currentState.widgetHeight == 90) {
                                          bannerKey.currentState.expand();
                                        } else {
                                          bannerKey.currentState.shrink();
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Notifications banner on second level of stack
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NotificationsBanner(heightNotification, widthNotification, key: bannerKey),
                        // Text("Hallo"),
                      ],
                    ),

                    /// Visualization of gaze points on top level of stack
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CustomPaint(
                            painter: FaceOutlinePainter(_offsets, size)),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

