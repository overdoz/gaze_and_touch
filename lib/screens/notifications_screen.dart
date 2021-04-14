import 'package:flutter/material.dart';
import 'package:gazeAndTouch/models/screens_model.dart';
import '../shapes/painters.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey backButtonKey = GlobalKey();
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(100, 200)];

  double height = 40;
  double width = 100;

  @override
  Widget build(BuildContext context) {

    /// Screen height and width
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var size = ScreenSize(height, width);

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
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: CustomPaint(painter: FaceOutlinePainter(_offsets, size)),
                    ),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 900),
                                  height: height,
                                  width: width,
                                  color: Colors.grey,
                                  child: Center(
                                      child: height != 300
                                          ? Text("open")
                                          : Text("Notifications")),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      key: backButtonKey,
                                      child: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ))
                              ],
                            ),
                          ],
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                child: height != 300
                                    ? Text('Expand')
                                    : Text('Close'),
                                onPressed: () {
                                  setState(() {
                                    if (height == 40) {
                                      height = 300;
                                      width = 400;
                                    } else {
                                      height = 40;
                                      width = 100;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    )),
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
