import 'dart:math';
import 'package:flutter/material.dart';
import 'package:multiplyapp/components/design_elements.dart';
import 'feedback_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiplyapp/training_mode_designed_screen.dart';

int firstNumber;
int secondNumber;
int correctAnswers = 0;
int wrongAnswers = 0;

void setNumbers() {
  firstNumber = Random().nextInt(9) + 1;
  secondNumber = Random().nextInt(9) + 1;
}

void calculateAnswer(int first, int second) {
  if (int.parse(trainingAnswer) == first * second) {
    // print('GOOD !!!');
    setNumbers();
    feedbackIcon = FontAwesomeIcons.smile;
    feedbackIconColor = Color(0XFFE6ACB4);
    correctAnswers++;
    clearAnswer();
  } else {
    // print('BAD !!!');
    feedbackIcon = FontAwesomeIcons.sadCry;
    feedbackIconColor = Color(0XFFE6ACB4);
    wrongAnswers++;
    clearAnswer();
  }
}

void setAnswer(int answer) {
  if (trainingAnswer == '?') {
    trainingAnswer = answer.toString();
  } else if (int.parse(trainingAnswer) < 81) {
    trainingAnswer = trainingAnswer + answer.toString();
  }
}

void clearAnswer() {
  trainingAnswer = '?';
}

void resetGame() {
  correctAnswers = 0;
  wrongAnswers = 0;
  trainingAnswer = '?';
  feedbackIcon = FontAwesomeIcons.meh;
  feedbackIconColor = Color(0XFFE6ACB4);
  setNumbers();
}
