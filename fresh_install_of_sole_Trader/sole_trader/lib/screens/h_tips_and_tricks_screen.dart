import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

import 'h_table_of_contents_screen.dart';

class HTipsAndTricksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(
        color: LightTheme.cDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins');
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('HTipsAndTricksScreen'),
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
                        'Tips and Tricks',
                        style: TextStyle(
                          color: LightTheme.cDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'In order to make using the app easier and more enjoyable we’ve included bits and pieces that might not be obvious at first glance, but once you know them, you can’t live without them!',
                        style: bodyTextStyle,
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'On Jobs screen',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: LightTheme.cGreen)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(
                                  text:
                                      'Sliding the job from left to right will duplicate it. This will create a new job with all the same details so you’ll have to just tap on the'),
                              TextSpan(
                                  text: ' Clock in ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextSpan(text: 'button to start working.'),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/duplicate-job-tip.jpg',
                        width: 300,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: LightTheme.cGreen)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(
                                  text:
                                      'You may already know that sliding the job from right to left will archive it. But if you have the option'),
                              TextSpan(
                                  text: ' \'Include archived jobs\' ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text:
                                      'checked, sliding archived jobs from right to left will delete them completely.'),
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
                          Text('• ',
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: LightTheme.cGreen)),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'If you tap on '),
                                WidgetSpan(
                                    child: Image.asset(
                                  'assets/images/invoicing-button.png',
                                  width: 60,
                                )),
                                TextSpan(text: ' or '),
                                WidgetSpan(
                                    child: Image.asset(
                                  'assets/images/quotes-button.png',
                                  width: 60,
                                )),
                                TextSpan(
                                    text:
                                        'buttons at the bottom menu when you are on'),
                                TextSpan(
                                  text: ' Jobs ',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text:
                                        'screen for a certain client, you will have that client already selected when arriving at'),
                                TextSpan(
                                    text: ' Invoicing ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: ' or ',
                                ),
                                TextSpan(
                                    text: ' Quotes ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: 'screens.',
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
                          Text('• ',
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: LightTheme.cGreen)),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'If you accidentally tapped on'),
                                TextSpan(
                                  text: ' Clock in ',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(text: 'or'),
                                TextSpan(
                                    text: ' Clock out ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text:
                                      ' buttons of a job but didn\’t intend to, you can tap on the job to open',
                                ),
                                TextSpan(
                                    text: ' Job details ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: 'screen, and there tap on',
                                ),
                                TextSpan(
                                    text: ' Reset job clock ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: 'button.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Image.asset(
                        'assets/images/reset-job-clock.jpg',
                        width: 300,
                      ),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info,
                            color: LightTheme.cGreen,
                            size: 35,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Even after completing a job, you can always edit all of the job details including start/end times.',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'On Clients screen',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: LightTheme.cGreen)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(text: 'Tapping on the '),
                              WidgetSpan(
                                child: Icon(
                                  CupertinoIcons.news_solid,
                                  color: LightTheme.cGreen,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      ' button of a client, it will take you to the'),
                              TextSpan(
                                  text: ' Generate invoice ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text:
                                      'screen with that client already selected.'),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Image.asset(
                        'assets/images/clients-screen-invoice-tap.jpg',
                        width: 300,
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'On Quote screen',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ',
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: LightTheme.cGreen)),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Each job entry has a button '),
                                TextSpan(
                                    text: ' Add as job ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text:
                                        '- tapping on it will create a new job for that client. The new job will have the same description, hourly rate, added costs, and notes, as the job entry in your quote.'),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/add-as-job-button.jpg',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ',
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: LightTheme.cGreen)),
                          Expanded(
                            child: Text(
                              'Sliding job entry from right to left will delete it with a brief chance to undo.',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/delete-job-entry-dismissible.jpg',
                        width: 300,
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
