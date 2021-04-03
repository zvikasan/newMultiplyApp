import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sole_trader/screens/h_archiving_clients_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

import 'h_table_of_contents_screen.dart';

class HOptionsScreen extends StatelessWidget {
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
        key: Key('HOptionsScreen'),
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
                        'Options Screen',
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
                      child: RichText(
                        text: TextSpan(
                            text:
                                'To get to the options screen, either tap on the ',
                            style: bodyTextStyle,
                            children: [
                              WidgetSpan(
                                child: Image.asset(
                                  'assets/images/options-button.png',
                                  width: 60,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      ' button at the bottom right of any screen or choose'),
                              TextSpan(
                                text: ' Options ',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: 'from the top drop-down menu.'),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/options-top-drop-down-menu.jpg',
                        width: 300,
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Options Screen buttons',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              Icons.backup,
                              color: LightTheme.cGreen,
                              size: 40,
                            ),
                          ),
                          Text(
                            'Backup',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'Creates backup of all your app data. This will create a file that you should keep safe (preferably in the cloud).',
                        style: bodyTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: RichText(
                        text: TextSpan(
                            text: 'In case you accidentally delete the',
                            style: bodyTextStyle,
                            children: [
                              TextSpan(
                                  text: ' soleTrader ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text:
                                      'app, or something happens to your device, having a backup will allow you to restore all your data when you re-install the app.'),
                            ]),
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: LightTheme.cRed,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(
                                text:
                                    'It is very important to make regular backups of your data.',
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              Icons.restore,
                              color: LightTheme.cGreen,
                              size: 40,
                            ),
                          ),
                          Text(
                            'Restore',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                'Tap on it to choose a previously created backup file and restore all your data.',
                            style: bodyTextStyle,
                            children: []),
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: LightTheme.cRed,
                          size: 40,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(style: bodyTextStyle, children: [
                              TextSpan(
                                text:
                                    'Restoring from previous backup will overwrite all your currently existing data within the app. So for example, if you just created a new client and added new jobs, restoring from a backup file that you made beforehand, will erase the new client and new jobs.',
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              Icons.alarm_on,
                              color: LightTheme.cGreen,
                              size: 40,
                            ),
                          ),
                          Text(
                            'Backup reminder',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'Sets the reminder period to backup your data, or turn it off. By default it is set to weekly.',
                        style: bodyTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              Icons.person,
                              color: LightTheme.cGreen,
                              size: 40,
                            ),
                          ),
                          Text(
                            'My details',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'This is where you enter your business details, which will be displayed on quotes and invoices.',
                        style: bodyTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              Icons.archive,
                              color: LightTheme.cGreen,
                              size: 40,
                            ),
                          ),
                          Text(
                            'Archived clients',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                    text:
                                        'Here you can view the clients you archived. See'),
                                TextSpan(
                                    text: ' Archiving clients ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HArchivingClientsScreen(),
                                            ));
                                      },
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: LightTheme.cGreen)),
                                TextSpan(
                                    text: 'section for detailed explanation.'),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Divider(thickness: 1),
                    ),
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
