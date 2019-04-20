import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final Color color;
  final Icon icon;
  final String text;
  final DismissDirection direction;

  DismissBackground({this.color, this.icon, this.text, this.direction});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.all(16),
      child: direction == DismissDirection.startToEnd
          ? Row(
              children: <Widget>[
                Row(children: <Widget>[
                  icon,
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ])
              ],
            )
          : Row(
        mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  icon,

                ])
              ],
            ),
    );
  }

  static DismissBackground unarchiveBackground = DismissBackground(
      color: Colors.grey,
      icon: Icon(
        Icons.unarchive,
        color: Colors.white,
      ),
      text: ("Unarchive"), direction: DismissDirection.startToEnd,);
  static DismissBackground archiveBackground = DismissBackground(
      color: Colors.orange,
      icon: Icon(Icons.archive, color: Colors.white),
      text: ("Archive"), direction: DismissDirection.startToEnd,);
  static DismissBackground deleteBackground = DismissBackground(
      color: Colors.red,
      icon: Icon(Icons.delete, color: Colors.white),
      text: ("Delete"), direction: DismissDirection.endToStart,);
}
