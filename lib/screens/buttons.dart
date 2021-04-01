import 'package:flutter/material.dart';
import 'package:gazeAndTouch/utils/widgetDetails.dart';


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

  var backButtonPosition;
  var backButtonSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      backButtonPosition = getWidgetPosition(backButtonKey);
      backButtonSize = getWidgetSize(backButtonKey);
      print(getWidgetPosition(backButtonKey));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Buttons'),
          leading: IconButton(
            key: backButtonKey,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              print(getWidgetPosition(backButtonKey));
              print(getWidgetSize(backButtonKey));
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Open route'),
              key: key1,
              onPressed: () {
                var position = getWidgetPosition(key1);
                var size = getWidgetSize(key1);
                print(position);
                print(size);
              },
            ),
            ElevatedButton(
              child: Text('Open route'),
              key: key2,
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text('Open route'),
              key: key3,
              onPressed: () {},
            ),
          ],
        )),
      ),
    );
  }
}
