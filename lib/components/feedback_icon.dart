import 'package:flutter/material.dart';

IconData topIcon;
Color topIconColor;

class FeedbackIcon extends StatelessWidget {
  FeedbackIcon({@required this.icon, this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        icon,
        size: 100.0,
        color: color,
      ),
      constraints: BoxConstraints.tightFor(
        width: 100.0,
        height: 100.0,
      ),
    );
  }
}
