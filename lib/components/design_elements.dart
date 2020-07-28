import 'package:flutter/material.dart';

String trainingAnswer = '?';

class NumberButton extends StatelessWidget {
  NumberButton({this.buttonNumber, this.buttonPressed});
  final String buttonNumber;
  final Function buttonPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        buttonNumber,
        style: TextStyle(
          fontSize: 40.0,
        ),
      ),
      color: Colors.lightBlueAccent,
      onPressed: buttonPressed,
    );
  }
}

class AnswersCount extends StatelessWidget {
  final Widget whatAnswer;
  final Color answerColor;
  final Widget correctIncorrect;
  AnswersCount(
      {@required this.whatAnswer,
      @required this.answerColor,
      @required this.correctIncorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          whatAnswer,
          correctIncorrect,
        ],
      ),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: answerColor,
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}
