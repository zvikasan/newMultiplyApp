import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData feedbackIcon;
Color feedbackIconColor;

class OtherButton extends StatelessWidget {
  final Widget buttonChild;
  final Function onPressed;

  OtherButton({
    @required this.buttonChild,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 8.0,
      child: buttonChild,
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 60.0,
        height: 60.0,
      ),
      shape: CircleBorder(),
      fillColor: Colors.white,
    );
  }
}

class FeedBackIcon extends StatelessWidget {
  FeedBackIcon({@required this.icon, this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        icon,
        size: 80.0,
        color: color,
      ),
      constraints: BoxConstraints.tightFor(
        width: 100.0,
        height: 100.0,
      ),
    );
  }
}
