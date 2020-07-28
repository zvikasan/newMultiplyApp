import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData topIcon = FontAwesomeIcons.smileWink;
Color topIconColor = Colors.green;

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
