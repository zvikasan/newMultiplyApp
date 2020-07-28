import 'dart:math';
import 'package:flutter/material.dart';
import 'package:multiplyapp/components/number_button.dart';
import 'feedback_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

int firstNumber;
int secondNumber;
int correctAnswers = 0;
int wrongAnswers = 0;

void setNumbers() {
  firstNumber = Random().nextInt(8) + 1;
  secondNumber = Random().nextInt(8) + 1;
}

void calculateAnswer(int first, int second) {
  if (int.parse(trainingAnswer) == first * second) {
    // print('GOOD !!!');
    setNumbers();
    topIcon = FontAwesomeIcons.thumbsUp;
    topIconColor = Colors.green;
    correctAnswers++;
    clearAnswer();
  } else {
    // print('BAD !!!');
    topIcon = FontAwesomeIcons.thumbsDown;
    topIconColor = Colors.red;
    wrongAnswers++;
    clearAnswer();
  }
}

void setAnswer(int answer) {
  if (trainingAnswer == 'ZZ') {
    trainingAnswer = answer.toString();
  } else if (int.parse(trainingAnswer) < 81) {
    trainingAnswer = trainingAnswer + answer.toString();
  }
}

void clearAnswer() {
  trainingAnswer = 'ZZ';
}

void resetGame() {
  correctAnswers = 0;
  wrongAnswers = 0;
  trainingAnswer = 'ZZ';
  topIcon = FontAwesomeIcons.smileWink;
  topIconColor = Colors.blue;
  setNumbers();
}
