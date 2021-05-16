import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import 'package:gazeAndTouch/utils/gaze_listener.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';
import 'package:gazeAndTouch/widgets/notifications.dart';
import 'package:gazeAndTouch/constants.dart';
import '../shapes/painters.dart';
import '../widgets/notifications.dart';
import '../widgets/feed.dart';
import '../data/feed_data.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key, this.dimensions}) : super(key: key);

  final Map<String, double> dimensions;

  @override
  _NotificationsState createState() => _NotificationsState(dimensions: this.dimensions);
}

class _NotificationsState extends State<Notifications> {
  /// keys
  final GlobalKey backButtonKey = GlobalKey();
  final GlobalKey<NotificationsBannerState> bannerKey = GlobalKey<NotificationsBannerState>();
  Map<String, double> dimensions;

  _NotificationsState({this.dimensions});

  /// eye tracking listener
  GazeReceiver _gazeInput;

  /// UI element
  RenderBox _banner;

  /// initial screen size which will be overwritten during render
  ScreenSize _size = new ScreenSize(0, 0);

  /// initial gaze data
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(100, 200)];


  @override
  void initState() {
    super.initState();

    /// determine banner size and position at rendering
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _banner = getWidget(bannerKey);
    });

    _gazeInput = new GazeReceiver(_offsets, callback);
  }

  callback() {
    setState(
      () {
        var timeStamp = DateTime.now().millisecondsSinceEpoch;
        print(bannerKey.currentState.lastGaze);

        /// just consider the first gaze point of array
        Offset first = _offsets[0];
        Offset gazePoint = new Offset(first.dx * _size.width, first.dy * _size.height);

        /// expand banner when gaze touches the UI element
        if (isWithinWidget(gazePoint, _banner)) {
          bannerKey.currentState.expand();
          bannerKey.currentState.setNewTime();
        }

        /// hide banner 3 seconds after you stop starring at it
        if (timeStamp >= bannerKey.currentState.lastGaze + 3000) {
          bannerKey.currentState.moveUp();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    _size = ScreenSize(height, width);

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
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
                        NotificationsBanner(key: bannerKey),
                      ],
                    ),

                    /// Visualization of gaze points on top level of stack
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CustomPaint(painter: FaceOutlinePainter(_offsets, _size, dimensions)),
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
                                    if (bannerKey.currentState.widgetHeight == bannerHeightMin) {
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
