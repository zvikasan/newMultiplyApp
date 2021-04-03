import 'package:flutter/material.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

import 'h_table_of_contents_screen.dart';

class HArchivingJobsScreen extends StatelessWidget {
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
        key: Key('HArchivingJobsScreen'),
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
                        'Archiving jobs',
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
                    SizedBox(height: 20),
                    Text(
                      'Over time you may have (and we hope you do!) very good clients, for whom you do a lot of jobs. As a result, your jobs list for these clients will grow long. To keep job lists manageable you have the option to archive old jobs so you don’t have to see them all the time.',
                      style: bodyTextStyle,
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            'Archiving a job',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'On',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' Jobs',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          ' screen slide the required job from right to left and it will disappear from the list.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/archive-job-slide.jpg',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'To view archived jobs - tap on the checkbox located at the bottom left of the screen and titled',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' \'include archived jobs\'.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            'Restoring a job',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800),
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
                            '1. ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'Tap on the checkbox located at the bottom left of the ',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: 'Jobs ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'screen and titled'),
                                  TextSpan(
                                    text: ' \' include archived jobs \'.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
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
                            '2. ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Tap on the ',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: 'Restore Job ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          'button located on the archived job.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/include-archived-jobs-restore.jpg',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: LightTheme.cGreen),
                        SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(
                                text:
                                    'Keep in mind that archiving a job is different than archiving a client. When you archive a client, all their jobs will be archived as well, but when you only archive a job, the client stays active. You just don’t see archived jobs in the jobs list.',
                              ),
                            ]),
                          ),
                        ),
                      ],
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
