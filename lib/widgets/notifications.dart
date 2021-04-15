

import 'package:flutter/material.dart';

class NotificationsBanner extends StatefulWidget {

  final double heightNotification;
  final double widthNotification;

  NotificationsBanner(this.heightNotification, this.widthNotification, { Key key }) : super(key: key);

  @override
  NotificationsBannerState createState() => NotificationsBannerState();
}


class NotificationsBannerState extends State<NotificationsBanner> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  double xPosBanner = -200.0;
  double widgetHeight = 90;
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
      widgetHeight = 250;
    });
  }

  void shrink() {
    setState(() {
      widgetHeight = 90;
    });
  }
  
  

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void slide() {

  }

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, animation.value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 900),
        height: widgetHeight,
        width: widget.widthNotification,
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Name"),
                ],
              ),
              Row(
                children: [
                  Text("Text"),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}