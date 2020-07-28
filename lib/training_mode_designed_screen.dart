import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrainingModeDesigned extends StatefulWidget {
  @override
  _TrainingModeDesignedState createState() => _TrainingModeDesignedState();
}

class _TrainingModeDesignedState extends State<TrainingModeDesigned> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff6B2875), Color(0xffECB8B8)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Multiply Game'),
        ),
        body: Stack(children: <Widget>[
          Align(
            alignment: Alignment(1.0, -0.85),
            child: Container(
              width: 146.0,
              height: 107.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  bottomLeft: Radius.circular(36.0),
                ),
                color: const Color(0x26ffffff),
                border: Border.all(width: 1.0, color: const Color(0x26707070)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 73.0,
              height: 109.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36.0),
                ),
                color: const Color(0x26ffffff),
                border: Border.all(width: 1.0, color: const Color(0x26707070)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 59.0,
              height: 159.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(36.0),
                  bottomRight: Radius.circular(36.0),
                ),
                color: const Color(0x26ffffff),
                border: Border.all(width: 1.0, color: const Color(0x26707070)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-1, 0.25),
            child: Container(
              width: 188.0,
              height: 122.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(36.0),
                  bottomRight: Radius.circular(36.0),
                ),
                color: const Color(0x26ffffff),
                border: Border.all(width: 1.0, color: const Color(0x26707070)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// backgroundColor: const Color(0xffecb8b8),
