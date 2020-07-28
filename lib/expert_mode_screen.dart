import 'package:flutter/material.dart';

class ExpertModePage extends StatefulWidget {
  @override
  _ExpertModePageState createState() => _ExpertModePageState();
}

class _ExpertModePageState extends State<ExpertModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Text('Multiply Game'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Multiplication Table widget
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 15.0,
              ),
              color: Colors.green.shade200,
              child: Text('Game area'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Text('5 x 5 = ?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('0'),
                    Text('1'),
                    Text('2'),
                    Text('3'),
                    Text('4'),
                    Text('5'),
                    Text('6'),
                    Text('7'),
                    Text('8'),
                    Text('9'),
                    Text('<'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
