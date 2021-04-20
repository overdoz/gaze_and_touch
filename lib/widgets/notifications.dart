

import 'package:flutter/cupertino.dart';
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


  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, animation.value),
      child: AnimatedContainer(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        duration: Duration(milliseconds: 900),
        height: widgetHeight,
        width: widget.widthNotification,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Messenger(),
              _NameAndMessage(),
            ],
          ),
        )
      ),
    );
  }
}

class _Messenger extends StatelessWidget {
  const _Messenger({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // flex: 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network("https://thumbs.dreamstime.com/b/whatsapp-logo-voronezh-russland-januar-symbol-168935006.jpg",
              height: 25,
                  width: 25,),

          ),
          SizedBox(width: 5,),
          Text("WHATSAPP"),
          Spacer(),
          Text("now"),
        ],
      ),
    );
  }
}

class _NameAndMessage extends StatelessWidget {
  const _NameAndMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Elon Musk",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        ),
        Text("Wanna work for me? <3"),
      ],
    );
  }
}