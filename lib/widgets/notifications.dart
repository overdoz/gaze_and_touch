import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gazeAndTouch/constants.dart';

class NotificationsBanner extends StatefulWidget {
  NotificationsBanner({Key key}) : super(key: key);

  @override
  NotificationsBannerState createState() => NotificationsBannerState();
}

class NotificationsBannerState extends State<NotificationsBanner> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Timer _timer;
  int lastGaze = 0;
  double widgetHeight = bannerHeightMin;
  double widgetWidth = 400;
  bool isUp = true;

  /// Key for collapsible text
  final GlobalKey<_DescriptionTextState> textKey = GlobalKey<_DescriptionTextState>();

  /// Constructor
  NotificationsBannerState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    /// set time to moment when banner pops up
    _timer = new Timer(const Duration(milliseconds: 4000), () {
      setState(() {
        moveDown();
        lastGaze = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    animation = Tween<double>(begin: -300, end: 0).animate(controller)
      ..addListener(() {
        setState(() {
          ///
        });
      });
  }

  void setNewTime() {
    lastGaze = DateTime.now().millisecondsSinceEpoch;
  }

  void moveDown() {
    controller.forward();
    isUp = false;

    /// slide banner up again after a particular amount of time
    _timer = new Timer(const Duration(milliseconds: 6000), () {
      var timeStamp = DateTime.now().millisecondsSinceEpoch;

      if (timeStamp >= lastGaze + 5000) {
        setState(() {
          moveUp();
        });
      }
    });
  }

  void moveUp() {
    controller.reverse();
    isUp = true;
  }

  void expand() {
    setState(() {
      widgetHeight = bannerHeightMax;
      Future.delayed(const Duration(milliseconds: 500), () {
        textKey.currentState.showMore();
      });
    });
  }

  void shrink() {
    setState(() {
      widgetHeight = bannerHeightMin;
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
                decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(10))),
                duration: Duration(milliseconds: 400),
                height: widgetHeight,
                width: widgetWidth,
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
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            logoWhatsApp,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
          child: Text(
            "Elon Musk",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _DescriptionText extends StatefulWidget {
  final String text;

  _DescriptionText({Key key, this.text}) : super(key: key);

  @override
  _DescriptionTextState createState() => new _DescriptionTextState();
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
                    setState(
                      () {
                        flag = !flag;
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
