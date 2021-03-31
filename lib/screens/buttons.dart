import 'package:flutter/material.dart';

class ButtonsScreen extends StatelessWidget {
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buttons'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('Open route'),
            key: key1,
            onPressed: () {
              // Navigator.pop(context);
              final RenderBox renderBoxRed =
                  key1.currentContext.findRenderObject();
              final sizeRed = renderBoxRed.size;
              Offset position = renderBoxRed
                  .localToGlobal(Offset.zero); //this is global position
              // double y = position.dy;
              print(position);
            },
          ),
          ElevatedButton(
            child: Text('Open route'),
            key: key2,
            onPressed: () {
              // Navigator.pop(context);
              final RenderBox renderBoxRed =
                  key2.currentContext.findRenderObject();
              final sizeRed = renderBoxRed.size;
              Offset position = renderBoxRed
                  .localToGlobal(Offset.zero); //this is global position
              // double y = position.dy;
              print(position);
            },
          ),
          ElevatedButton(
            child: Text('Open route'),
            key: key3,
            onPressed: () {
              // Navigator.pop(context);
              final RenderBox renderBoxRed =
                  key3.currentContext.findRenderObject();
              final sizeRed = renderBoxRed.size;
              Offset position = renderBoxRed
                  .localToGlobal(Offset.zero); //this is global position
              // double y = position.dy;
              print(position);
            },
          ),
        ],
      )),
    );
  }
}
