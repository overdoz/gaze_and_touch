import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsBanner extends StatefulWidget {
  final double heightNotification;
  final double widthNotification;

  NotificationsBanner(this.heightNotification, this.widthNotification,
      {Key key})
      : super(key: key);

  @override
  NotificationsBannerState createState() => NotificationsBannerState();
}

class NotificationsBannerState extends State<NotificationsBanner> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final GlobalKey<_DescriptionTextState> textKey = GlobalKey<_DescriptionTextState>();

  final message =
      "Hey Thanh, wanna work for me? Would love to have you in my AI research team. We could maybe meet for a cup of coffee?!";

  double xPosBanner = -200.0;
  double widgetHeight = 100;
  bool isUp = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = Tween<double>(begin: -300, end: 0).animate(controller)
      ..addListener(() {
        setState(() {
          ///
        });
      });
  }

  void moveDown() {
    controller.forward();
    isUp = false;
  }

  void moveUp() {
    controller.reverse();
    isUp = true;
  }

  void expand() {
    setState(() {
      widgetHeight = 140;
      Future.delayed(const Duration(milliseconds: 500), () {
        textKey.currentState.showMore();
      });

    });
  }

  void shrink() {
    setState(() {
      widgetHeight = 100;
      Future.delayed(const Duration(milliseconds: 100), () {
        textKey.currentState.showLess();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void slide() {}

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, animation.value),
      child: Stack(
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  duration: Duration(milliseconds: 400),
                  height: widgetHeight,
                  width: widget.widthNotification,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Messenger(),
                        _Name(),
                        _DescriptionText(key: textKey, text: message),
                      ],
                    ),
                  )),
            ),
          ),
          Positioned(
            left: -5.0,
            top: -5.0,
            child: GestureDetector(
              onTap: (){
                moveUp();
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.3), spreadRadius: 2)],
                  ),
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Messenger extends StatelessWidget {
  const _Messenger({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "https://thumbs.dreamstime.com/b/whatsapp-logo-voronezh-russland-januar-symbol-168935006.jpg",
            height: 25,
            width: 25,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text("WHATSAPP"),
        Spacer(),
        Text("now"),
      ],
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Elon Musk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Text("Wanna work for me? <3"),
      ],
    );
  }
}

class _DescriptionText extends StatefulWidget {
  final String text;

  _DescriptionText({Key key, this.text}) : super(key: key);

  @override
  _DescriptionTextState createState() =>
      new _DescriptionTextState();
}

class _DescriptionTextState extends State<_DescriptionText> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  void showMore() {
    setState(() {
      flag = false;
    });
  }

  void showLess() {
    setState(() {
      flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
