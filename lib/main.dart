import 'package:flutter/material.dart';
import 'package:multiplyapp/expert_mode_screen.dart';
import 'package:multiplyapp/training_mode_screen.dart';
import 'package:multiplyapp/training_mode_designed_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiply Game',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: Text('Expert Mode'),
            color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ExpertModePage();
              }));
            },
          ),
          SizedBox(height: 10.0),
          FlatButton(
              child: Text('Training Mode'),
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TrainingModeDesigned();
                  // return TrainingModePage();
                }));
              }),
        ],
      ),
    );
  }
}
