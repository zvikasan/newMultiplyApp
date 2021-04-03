import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sole_trader/screens/h_tips_and_tricks_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

import 'h_table_of_contents_screen.dart';
import 'my_details_screen.dart';

class HJobToInvoiceWorkflowScreen extends StatelessWidget {
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
        key: Key('HJobsInvoiceWorkflowScreen'),
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
                        'Job-to-invoice',
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
                          text: 'Job-to-invoice workflow',
                          style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    ' is used to track time spent on jobs for clients so that you’ll be able to easily generate and send invoices when required.',
                                style: bodyTextStyle),
                          ]),
                    ),
                    Divider(thickness: 1),
                    Text('Part I - doing the work',
                        style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 10),
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
                              TextSpan(text: 'On '),
                              TextSpan(
                                  text: 'My Clients ',
                                  style: bodyTextStyle.copyWith(
                                      fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text:
                                      'screen tap on the client you’ll be working for next (or add a new client first).'),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/my-clients-screen.jpg',
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
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'On '),
                                TextSpan(
                                    text: 'Jobs ',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w700)),
                                TextSpan(text: 'screen tap on '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/plus-new-job-button.png',
                                    width: 60,
                                  ),
                                ),
                                TextSpan(text: 'button and fill the '),
                                TextSpan(
                                    text: 'New Job ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(text: 'form. Tap on '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/add-job-3-button.jpg',
                                    width: 60,
                                  ),
                                ),
                                TextSpan(text: ' button when finished.'),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: LightTheme.cGreen),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                  text:
                                      'The hourly rate is prepopulated from the client’s hourly rate, but you can change it here.',
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
                          Text(
                            '3. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                    text:
                                        'When starting to work on the job, tap on the '),
                                TextSpan(
                                    text: 'Clock in ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(text: 'button.'),
                                WidgetSpan(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Image.asset(
                                      'assets/images/tap-on-clock-in-button.jpg',
                                      width: 300,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        'Once tapped, the button will change to '),
                                TextSpan(
                                    text: 'Clock out',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text: '. Tap on it when finished working.'),
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
                          Text(
                            '4. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: Text('Add more jobs as needed.',
                                style: bodyTextStyle),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Part II - Invoicing the client',
                        style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.w800)),
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
                                TextSpan(
                                    text:
                                        'When it is time to invoice your client, tap on the '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/invoicing-button.png',
                                    width: 60,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        ' button at the bottom of the screen.'),
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
                          Text(
                            '6. ',
                            style: bodyTextStyle.copyWith(
                                color: LightTheme.cGreen),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                    text:
                                        'Choose the client to generate invoice for (check out '),
                                TextSpan(
                                    text: 'Tips and tricks',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HTipsAndTricksScreen(),
                                            ));
                                      },
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: LightTheme.cGreen)),
                                TextSpan(
                                    text:
                                        ' section for some more info on that).'),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/choose-client-for-invoice.jpg',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '7. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: Text(
                                'Select date range that invoice will cover.',
                                style: bodyTextStyle),
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
                            '8. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Choose whether it is a '),
                                TextSpan(
                                    text: 'Tax Invoice',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(text: ' or not.'),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: LightTheme.cGreen),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(
                                    text:
                                        'This will only change the invoice title from '),
                                TextSpan(
                                    text: 'Invoice',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(text: ' to '),
                                TextSpan(
                                    text: 'Tax Invoice ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(text: '. '),
                                TextSpan(
                                  text:
                                      'Tax percentage will be either added to invoice or not according to your settings in ',
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
                                TextSpan(text: ' screen.'),
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
                          Text(
                            '9. ',
                            style: bodyTextStyle.copyWith(
                              color: LightTheme.cGreen,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(style: bodyTextStyle, children: [
                                TextSpan(text: 'Tap on '),
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/images/generate-invoice-button.jpg',
                                    width: 100,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' button. Invoice will be shown on screen. It will include all completed jobs for the selected client within selected date range.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/tax-invoice-sample.jpg',
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10. ',
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
                      padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
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
                                  text: 'Print the invoice',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
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
                                      'Share the invoice: email it to your client or save to the cloud.',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'That’s it! Now tap on the back button (on the top left of the screen) to go back to the invoicing screen.',
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
