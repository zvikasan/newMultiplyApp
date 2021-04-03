import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sole_trader/screens/update_my_details_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'h_table_of_contents_screen.dart';
import 'my_details_screen.dart';

class HQuotingWorkflowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(
        fontFamily: 'Poppins',
        color: LightTheme.cDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w400);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('HQuotingWorkflowScreen'),
        context: context,
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      body: Column(
        children: [
          Container(
            width: screenSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              color: LightTheme.cLightYellow,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Quoting',
                        style: TextStyle(
                          color: LightTheme.cDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0,
                        ),
                      ),
                      Text(
                        'Workflow',
                        style: TextStyle(
                          color: LightTheme.cBrownishGrey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: 'Quoting workflow',
                          style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    ', as its name implies, is used to create quotes.',
                                style: bodyTextStyle),
                          ]),
                    ),
                    Divider(thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. ',
                          style: bodyTextStyle.copyWith(
                            color: LightTheme.cGreen,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(text: 'Tap on the '),
                              WidgetSpan(
                                child: Image.asset(
                                  'assets/images/quotes-button.png',
                                  width: 60,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' button at the bottom of the screen (you can also get there from the top drop-down menu).',
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            'Choose a client or create a new one',
                            style: bodyTextStyle,
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '3. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Tap on the '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/add-quote-button.jpg',
                                    width: 60,
                                  ),
                                ),
                                TextSpan(
                                  text: ' button',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Choose quote date (by default it will be the current date).',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Choose date at which quote will expire (by default it will be a month from current date).',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Set quote number (you’ll be able to change It later as well).',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Tap on the '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/add-quote-button.jpg',
                                    width: 60,
                                  ),
                                ),
                                TextSpan(
                                  text: ' button.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'New empty quote will be created.',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '4. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            'Now you need to add job entries to the new quote. Tap on the quote to get to the job entries screen.',
                            style: bodyTextStyle,
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/tap-on-quote.jpg',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'On the job entries screen, in addition to adding job entries you are able to change:',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Quote number',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Quote date',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Quote valid until date',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                    text:
                                        'To add new job entry to your quote tap on the '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/add-job-button.jpg',
                                    width: 60,
                                  ),
                                ),
                                TextSpan(
                                  text: ' button.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Fill in the New Job form.',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Column(
                        children: [
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline,
                                  color: LightTheme.cGreen),
                              SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text:
                                      TextSpan(style: bodyTextStyle, children: [
                                    TextSpan(
                                      text:
                                          'Hourly rate is prepopulated from the client’s hourly rate, but you can change it here.',
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Tap on the '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/add-job-2-button.jpg',
                                    width: 80,
                                  ),
                                ),
                                TextSpan(
                                  text: ' button.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'Add as many job entries as needed.',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '5. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Tap on the '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/generate-quote-button.jpg',
                                    width: 40,
                                  ),
                                ),
                                TextSpan(
                                  text: ' button to generate the quote.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'The quote will include:',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right,
                              color: LightTheme.cGreen, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                  text:
                                      'All the information you entered previously.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right,
                              color: LightTheme.cGreen, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                  text: 'Automatically calculated totals.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right,
                              color: LightTheme.cGreen, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                  text:
                                      'Tax will be added to quote if you selected the tax option when filling in your personal details (you can always change this on ',
                                ),
                                TextSpan(
                                    text: 'My Details',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyDetailsScreen(),
                                            ));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        color: LightTheme.cGreen)),
                                TextSpan(text: ' screen).'),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'On the top right of the screen you’ll have two buttons:',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 20, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.print,
                            color: LightTheme.cDarkBlue,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                  text: 'Print the quote.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.share,
                            color: LightTheme.cDarkBlue,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                  text:
                                      'Share the quote: email it to your client or save to the cloud.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'That’s it! Now tap on the back button (on the top left of the screen) to go back to the job entries screen.',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HTableOfContentsScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_left,
                            color: LightTheme.cGreen,
                          ),
                          Text(
                            'Table of contents',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: LightTheme.cGreen,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
