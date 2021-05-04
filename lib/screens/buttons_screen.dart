import 'package:flutter/material.dart';
import 'package:gazeAndTouch/utils/widget_details.dart';
import '../shapes/painters.dart';
import '../models/screens_model.dart';
import '../utils/gaze_listener.dart';



class ButtonsScreen extends StatefulWidget {
  ButtonsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ButtonsScreenState createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey backButtonKey = GlobalKey();

  // Initial offsets with 10 gazepoints
  final _offsets = <Offset>[for (var i = 0; i < 10; i++) Offset(100, 200)];


  GazeReceiver gazeListener;

  RenderBox backButton;
  RenderBox testButton;

  @override
  void initState() {
    super.initState();

    /// determine backbutton size and position at rendering
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      backButton = getWidget(backButtonKey);
    });

    /// determine button 1 size and position at rendering
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testButton = getWidget(key1);
    });

    /// initialize gaze listener 
    gazeListener = new GazeReceiver(_offsets, callback);

  }

  callback() {
    setState(() {
      if (isWithinWidget(_offsets[0], backButton)) {
        Navigator.of(context).pop();
      }
    });

    // TODO: calculate the mean of the latest 10 gaze points
  }

  @override
  Widget build(BuildContext context) {

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
                                key: backButtonKey,
                                child: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                child: Text('Press me'),
                                key: key1,
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(Size(180.0, 80.0))
                                ),
                                onPressed: () {
                                  print(getWidgetPosition(backButtonKey));
                                  print(getWidgetSize(backButtonKey));
                                },
                              ),
                              ElevatedButton(
                                child: Text('Press me'),
                                key: key2,
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(120.0, 60.0))
                                ),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: Text('Press me'),
                                key: key3,
                                onPressed: () {},
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                    // Container(
                    //     width: double.infinity,
                    //     height: double.infinity,
                    //     child: CustomPaint(painter: FaceOutlinePainter(_offsets, size)),
                    //   ),
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
