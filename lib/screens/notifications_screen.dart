import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/utils/gaze_listener.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';
import 'package:gazeAndTouch/widgets/notifications.dart';
import '../shapes/painters.dart';
import '../widgets/notifications.dart';
import '../widgets/feed.dart';
import '../data/feed_data.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  /// keys
  final GlobalKey backButtonKey = GlobalKey();
  final GlobalKey<NotificationsBannerState> bannerKey = GlobalKey<NotificationsBannerState>();

  /// eye tracking listener
  GazeReceiver _gazeInput;

  /// position and size of UI element
  Size _notificationSize;
  Offset _notificationPos;

  /// initial gaze data
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(100, 200)];

  double heightNotification = 50;
  double widthNotification = 400;

  @override
  void initState() {
    super.initState();
    _gazeInput = new GazeReceiver(_offsets, callback);

  }

  callback() {
    setState(
      () {
        // print(DateTime.now());
        // if (isWithinWidget(_offsets[0], _widget)) {
        //   bannerKey.currentState.expand();
        // }
        /// init information about notifications banner
        final RenderBox banner = bannerKey.currentContext.findRenderObject();
        _notificationSize = banner.size;
        _notificationPos = banner.localToGlobal(Offset.zero);
      },
    );
  }

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
                              FlatButton(
                                key: backButtonKey,
                                child: Icon(Icons.auto_awesome),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Text(
                                "Instaplants",
                                style: TextStyle(fontFamily: "Insta", fontSize: 25),
                              ),
                              Spacer(),
                              Icon(Icons.live_tv),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.send_outlined),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: feedData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return PostCard(feedData[index]);
                                    },
                                  ),
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
                      ],
                    ),

                    /// Visualization of gaze points on top level of stack
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CustomPaint(painter: FaceOutlinePainter(_offsets, size)),
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              child: heightNotification != 300 ? Text('Expand') : Text('Close'),
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
                                    if (bannerKey.currentState.widgetHeight == 100) {
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
                      ],
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
