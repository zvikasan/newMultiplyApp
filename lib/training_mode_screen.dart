import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:multiplyapp/components/multiply_brain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiplyapp/components/design_elements.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/services.dart';

AudioCache audioCache;

class TrainingModeDesigned extends StatefulWidget {
  @override
  _TrainingModeDesignedState createState() => _TrainingModeDesignedState();
}

class _TrainingModeDesignedState extends State<TrainingModeDesigned> {
  @override
  void initState() {
    setNumbers();
    feedbackIcon = FontAwesomeIcons.meh;
    feedbackIconColor = Color(0XFFE6ACB4);
    correctAnswers = 0;
    audioCache = AudioCache(
        prefix: "assets/audio/",
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

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
          backgroundColor: Color(0xff874583),
          title: Text('Multiply Game'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    // setState(() {
                    //   resetGame();
                    // });
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles();
                  },
                  child: Icon(
                    Icons.refresh,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Stack(children: <Widget>[
          Align(
            alignment: Alignment(1.0, -0.75),
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
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 104.0,
              height: 102.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.0),
                color: const Color(0x26ffffff),
                border: Border.all(width: 1.0, color: const Color(0x26707070)),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(3.0),
                    width: 120.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36.0),
                      color: const Color(0xAFE3CDE3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x66212020),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '$correctAnswers',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4b366b),
                          ),
                        ),
                        Text(
                          'CORRECT',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4b366b),
                          ),
                        ),
                      ],
                    ),
                    // child:
                  ),
                  FeedBackIcon(
                    icon: feedbackIcon,
                    color: feedbackIconColor,
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    width: 120.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36.0),
                      color: const Color(0xAFE3CDE3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x66212020),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '$wrongAnswers',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4b366b),
                          ),
                        ),
                        Text(
                          'MISTAKES',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4b366b),
                          ),
                        ),
                      ],
                    ),
                    // child:
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: 324.0,
                height: 90.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36.0),
                  color: const Color(0xAFE3CDE3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x66212020),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$firstNumber x $secondNumber = $trainingAnswer',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4b366b),
                      ),
                    ),
                  ],
                ),
              ), // 8x8=?
              Container(
                padding: EdgeInsets.all(25.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: 324.0,
                height: 319.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36.0),
                  color: const Color(0xAFE3CDE3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x66212020),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        NumpadButton(
                            number: '1',
                            onPressed: () {
                              setState(() {
                                setAnswer(1);
                              });
                            }),
                        NumpadButton(
                            number: '2',
                            onPressed: () {
                              setState(() {
                                setAnswer(2);
                              });
                            }),
                        NumpadButton(
                            number: '3',
                            onPressed: () {
                              setState(() {
                                setAnswer(3);
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        NumpadButton(
                            number: '4',
                            onPressed: () {
                              setState(() {
                                setAnswer(4);
                              });
                            }),
                        NumpadButton(
                            number: '5',
                            onPressed: () {
                              setState(() {
                                setAnswer(5);
                              });
                            }),
                        NumpadButton(
                            number: '6',
                            onPressed: () {
                              setState(() {
                                setAnswer(6);
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        NumpadButton(
                            number: '7',
                            onPressed: () {
                              setState(() {
                                setAnswer(7);
                              });
                            }),
                        NumpadButton(
                            number: '8',
                            onPressed: () {
                              setState(() {
                                setAnswer(8);
                              });
                            }),
                        NumpadButton(
                            number: '9',
                            onPressed: () {
                              setState(() {
                                setAnswer(9);
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        NumpadButton(
                            number: '0',
                            onPressed: () {
                              setState(() {
                                setAnswer(0);
                              });
                            }),
                        OtherButton(
                            buttonChild: Text(
                              'GO!',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4b366b),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                calculateAnswer(firstNumber, secondNumber);
                              });
                            }),
                        OtherButton(
                            buttonChild: Icon(
                              FontAwesomeIcons.backspace,
                              textDirection: TextDirection.rtl,
                              color: Color(0xff4b366b),
                            ),
                            onPressed: () {
                              setState(() {
                                clearAnswer();
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ), // numpad
            ],
          ),
        ]),
      ),
    );
  }
}

// backgroundColor: const Color(0xffecb8b8),
class NumpadButton extends StatelessWidget {
  final String number;
  final Function onPressed;

  NumpadButton({@required this.number, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 8.0,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff4b366b),
        ),
      ),
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
