import 'package:flutter/material.dart';
import 'package:sole_trader/screens/terms_and_conditions_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(
        color: LightTheme.cDarkBlue,
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins');
    const bodyTextStyleSmall = TextStyle(
        color: LightTheme.cDarkBlue,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins');
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('PrivacyPolicyScreen'),
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
                        'Privacy Policy',
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'This privacy policy governs your use of the software application',
                                style: bodyTextStyleSmall,
                                children: [
                                  TextSpan(
                                    text: ' soleTrader ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          '("Application") for mobile devices. This privacy policy was last updated on September 15, 2020. Our privacy policy may change from time to time for any reason. If we make any material changes to our policies, we will place  prominent notice on our website or application. If you have any questions or concerns about our privacy policies, feel free to contact us at any time at privacy@soletraderapp.com.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'What information does the Application obtain and how is it used?',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'All the personal information that you enter within the app is stored locally on your device. You also have the option to create backup of the Application data, which can be stored either locally on your mobile device, sent as file via email, or in any cloud storage options available to you.\nWe don\'t have any access to your personal data at any point in time.',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'How do you handle location data?',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'The Application does not use or collect any data related to your geographic location.',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Do you share personal information?',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'As we don\'t have any access to your personal information, we do not share it with anyone.',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Do you use vendors or analytics providers?',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'We don\'t use any third party vendors or analytic providers except the anonymous analytic data available from the app store.',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TermsAndConditionsScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                          ),
                          Text(
                            'Terms and Conditions',
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
