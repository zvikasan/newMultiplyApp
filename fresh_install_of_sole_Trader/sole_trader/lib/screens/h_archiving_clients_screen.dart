import 'package:flutter/material.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

import 'h_table_of_contents_screen.dart';

class HArchivingClientsScreen extends StatelessWidget {
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
        key: Key('HArchivingClientsScreen'),
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
                        'Archiving clients',
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
                    RichText(
                      text: TextSpan(
                          text:
                              'Over time you may (and we hope you will!) accumulate a long list of clients. \nYou may not have an active relationship with some of these clients, but still want to keep their records for future reference. Therefore you have the option to',
                          style: bodyTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: ' archive ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: 'those clients.'),
                          ]),
                    ),
                    Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Archiving a client',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
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
                                text: 'On',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' My Clients ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'screen, tap on the'),
                                  TextSpan(
                                    text: ' Settings ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          'icon of the client you want to archive.'),
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
                        'assets/images/my-clients-screen-settings-tap.jpg',
                        width: 300,
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
                                text: 'On',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' Update client details ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'screen, tap on the'),
                                  TextSpan(
                                    text: ' Archive ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'button. '),
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
                        'assets/images/archive-client.jpg',
                        width: 300,
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
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: Text(
                              'That’s it! This client is archived and won\'t be visible in the clients list',
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Viewing archived clients',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
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
                                text: 'Go to the',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' Options ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'screen and tap on the'),
                                  TextSpan(
                                    text: ' Archived clients ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'button.'),
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
                        'assets/images/archived-clients-button.jpg',
                        width: 300,
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
                                text: 'On the',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' Archived clients ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          'screen you\'ll see list of all the clients you’ve archived. Tap on any of them to see their jobs.'),
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
                        'assets/images/archived-clients-list.jpg',
                        width: 300,
                      ),
                    ),
                    Divider(thickness: 1),
                    Row(
                      children: [
                        Text(
                          'Restoring archived clients',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
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
                                text: 'On',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' Archived Clients ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'screen, tap on the'),
                                  TextSpan(
                                    text: ' Settings ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          'icon of the client you want to restore.'),
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
                        'assets/images/archived-clients-list-settings-icon-tap.jpg',
                        width: 300,
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
                                text: 'On',
                                style: bodyTextStyle,
                                children: [
                                  TextSpan(
                                    text: ' Client Settings ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'screen, tap on the'),
                                  TextSpan(
                                    text: ' Restore ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'button.'),
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
                        'assets/images/restore-archived-client.jpg',
                        width: 300,
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
