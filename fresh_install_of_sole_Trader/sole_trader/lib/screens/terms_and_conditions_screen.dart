import 'package:flutter/material.dart';
import 'package:sole_trader/screens/privacy_policy_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
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
        key: Key('TermsAndConditionsScreen'),
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
                        'Terms & Conditions',
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
                    Row(
                      children: [
                        Text(
                          'Terms of Service',
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
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'These terms govern your use of the software application',
                                style: bodyTextStyleSmall,
                                children: [
                                  TextSpan(
                                    text: ' soleTrader ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                      text:
                                          '("the App") for mobile devices.\nPlease read Terms of Service carefully. By using the soleTrader app you are agreeing to these terms. Be sure to occasionally check back for updates. If you have any questions or concerns about our Terms of Service, feel free to contact us at any time at terms@soletraderapp.com.'),
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
                        Text(
                          'Limited License to Use',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Subject to your compliance with these Terms, you are granted a limited, nonexclusive, non-transferable, non-sublicensable license to use the App. Except as expressly permitted in these Terms or under applicable law, you may not: (a) copy, modify, or create derivative works based on the App; (b) distribute, transfer, sublicense, lease, lend, or rent the App to any third party; (c) reverse engineer, decompile, or disassemble the App; or (d) make the functionality of the App available to multiple users through any means. All rights in and to the soleTrader App are reserved.',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Billing',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'You may purchase a Paid Subscription in advance on a monthly basis or some other recurring interval disclosed to you prior to your purchase, or Unlimited Access giving you full access to the App features without time limit.\n We may change the price for the Paid Subscriptions, including recurring subscription fees, and for the Unlimited Access, and will communicate any price changes to you in advance. Price changes will take effect at the start of the next subscription period following the date of the price change. Subject to the applicable law, you accept the new price by continuing to use the App after the price change takes effect. If you do not agree with a price change, you have the right to reject the change by unsubscribing from the Paid Subscription prior to the price change going into effect.',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Limitation of Liability',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'The App is provided "as is", and we can\'t guarantee it will be safe and secure or will work perfectly all the time. TO THE EXTENT PERMITTED BY LAW, WE ALSO DISCLAIM ALL WARRANTIES, WHETHER EXPRESS OR IMPLIED, INCLUDING THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT.\nOur responsibility for the App (also called "liability") is limited as much as the law will allow. If there is an issue with the App, we can\'t know what all the possible impacts might be. You agree that we won\'t be responsible ("liable") for any lost profits, revenues, information, or data, or consequential, special, indirect, exemplary, punitive, or incidental damages arising out of or related to these Terms, even if we know they are possible.\nTO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE SOLETRADER APP ENTITIES SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES, OR ANY LOSS OF PROFITS OR REVENUES, WHETHER INCURRED DIRECTLY OR INDIRECTLY, OR ANY LOSS OF DATA, USE, GOODWILL, OR OTHER INTANGIBLE LOSSES, RESULTING FROM YOUR ACCESS TO OR USE OF OR INABILITY TO ACCESS OR USE THE APP. IN NO EVENT SHALL THE AGGREGATE LIABILITY OF THE SOLETRADER APP ENTITIES EXCEED THE GREATER OF TWENTY AUSTRALIAN DOLLARS (AUD \$20.00). THE LIMITATIONS OF THIS SUBSECTION SHALL APPLY TO ANY THEORY OF LIABILITY, WHETHER BASED ON WARRANTY, CONTRACT, STATUTE, TORT (INCLUDING NEGLIGENCE) OR OTHERWISE, AND WHETHER OR NOT THE SOLETRADER ENTITIES HAVE BEEN INFORMED OF THE POSSIBILITY OF ANY SUCH DAMAGE, AND EVEN IF A REMEDY SET FORTH HEREIN IS FOUND TO HAVE FAILED OF ITS ESSENTIAL PURPOSE',
                            style: bodyTextStyleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Governing Law / Jurisdiction',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Unless otherwise required by a mandatory law of a member state of the European Union or any other jurisdiction, the Agreements (and any non-contractual disputes/claims arising out of or in connection with them) are subject to the laws of the State of Victoria, Australia, without regard to choice or conflicts of law principles.',
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
                            builder: (_) => PrivacyPolicyScreen(),
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
                            'Privacy Policy',
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
