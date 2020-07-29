import 'dart:math';
<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
>>>>>>> organizingTrainingScreen
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiplyapp/components/design_elements.dart';
import 'package:multiplyapp/training_mode_screen.dart';

int firstNumber;
int secondNumber;
int correctAnswers = 0;
int wrongAnswers = 0;
String trainingAnswer = '?';

void setNumbers() {
  firstNumber = Random().nextInt(9) + 1;
  secondNumber = Random().nextInt(9) + 1;
}

void calculateAnswer(int first, int second) {
  if (int.parse(trainingAnswer) == first * second) {
    // print('GOOD !!!');
    audioCache.play('good.mp3');
    setNumbers();
    feedbackIcon = FontAwesomeIcons.smile;
    correctAnswers++;
    clearAnswer();
  } else {
    // print('BAD !!!');
    audioCache.play('cat.mp3');
    feedbackIcon = FontAwesomeIcons.sadCry;
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
  setNumbers();
}
