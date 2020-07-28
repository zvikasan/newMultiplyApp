import 'package:flutter/material.dart';
import 'package:multiplyapp/components/feedback_icon.dart';
import 'package:multiplyapp/components/number_button.dart';
import 'package:multiplyapp/components/multiply_brain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrainingModePage extends StatefulWidget {
  @override
  _TrainingModePageState createState() => _TrainingModePageState();
}

class _TrainingModePageState extends State<TrainingModePage> {
  @override
  void initState() {
    setNumbers();
    topIcon = FontAwesomeIcons.smileWink;
    topIconColor = Colors.blue;
    correctAnswers = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Multiply Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnswersCount(
                answerColor: Colors.red,
                whatAnswer: Text(
                  '$wrongAnswers',
                  style: TextStyle(
                    fontSize: 50.0,
                  ),
                ),
                correctIncorrect: Text(
                  'Incorrect',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              FeedbackIcon(
                icon: topIcon,
                color: topIconColor,
              ),
              AnswersCount(
                answerColor: Colors.green,
                whatAnswer: Text(
                  '$correctAnswers',
                  style: TextStyle(
                    fontSize: 50.0,
                  ),
                ),
                correctIncorrect: Text(
                  'Correct',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$firstNumber x $secondNumber = ?',
                  style: TextStyle(
                    fontSize: 50.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.lightGreen,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(3, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 150.0,
                  height: 70.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$trainingAnswer',
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberButton(
                  buttonNumber: '1',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(1);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: '2',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(2);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: '3',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(3);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberButton(
                  buttonNumber: '4',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(4);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: '5',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(5);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: '6',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(6);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberButton(
                  buttonNumber: '7',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(7);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: '8',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(8);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: '9',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(9);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberButton(
                  buttonNumber: '0',
                  buttonPressed: () {
                    setState(() {
                      setAnswer(0);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: 'GO',
                  buttonPressed: () {
                    setState(() {
                      calculateAnswer(firstNumber, secondNumber);
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: 'Clr',
                  buttonPressed: () {
                    setState(() {
                      clearAnswer();
                    });
                  },
                ),
                NumberButton(
                  buttonNumber: 'RES',
                  buttonPressed: () {
                    setState(() {
                      resetGame();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
