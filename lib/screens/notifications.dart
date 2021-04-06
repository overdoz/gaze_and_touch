import 'package:flutter/material.dart';
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
                      width: double.infinity, //double.infinity,
                      height: double.infinity, //double.infinity,
                      color: Colors.white,
                      child: CustomPaint(painter: FaceOutlinePainter(_offsets)),
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
                                      child: Center(child: height != 300 ? Text("open") : Text("Notifications")),
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
                                        )
                                    )

                                  ],
                                ),
                              ],
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    child: Text('Expand'),
                                    onPressed: () {
                                      setState(() {
                                        if(height == 40) {
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
