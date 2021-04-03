import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/models/my_details_model.dart';
import 'package:sole_trader/screens/clients_list_screen.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    var jobsProvider = Provider.of<DataProvider>(context, listen: false);
    MyDetails _myDetails;
    _myDetails = await jobsProvider.getMyDetails();
    _myDetails.myBillingName = 'John Doe';
    jobsProvider.updateMyDetails(_myDetails);
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => ClientsListScreen()),
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ClientsListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0, color: LightTheme.cDarkBlue);
    const titleStyle = TextStyle(
      fontSize: 22,
      color: LightTheme.cDarkBlue,
      fontWeight: FontWeight.w700,
    );
    const pageDecoration = PageDecoration(
      pageColor: LightTheme.cLightYellow,
      titleTextStyle: TextStyle(
        fontSize: 22,
        color: LightTheme.cDarkBlue,
        fontWeight: FontWeight.w700,
      ),
      titlePadding: EdgeInsets.fromLTRB(10, 00, 10, 10),
    );

    const page1Decoration = PageDecoration(
      boxDecoration: BoxDecoration(
        color: LightTheme.cLightYellow,
        image: DecorationImage(
            image: AssetImage('assets/images/sole-trader-logo-transparent.png'),
            fit: BoxFit.scaleDown),
      ),
    );

    return Scaffold(
      backgroundColor: LightTheme.cLightYellow,
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              decoration: page1Decoration,
              titleWidget: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Welcome to soleTrader!',
                      style: titleStyle,
                    ),
                  ),
                ],
              ),
              bodyWidget: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        //   child: Image.asset(
                        //     'assets/images/sole-trader-logo.png',
                        //     height: 50,
                        //   ),
                        // ),
                        Expanded(
                          child: RichText(
                            maxLines: 4,
                            text: TextSpan(
                              text: 'soleTrader',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  color: LightTheme.cDarkBlue),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      ' was created to make life of freelancers and sole traders just like yourself easier.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: LightTheme.cDarkBlue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: new BoxDecoration(
                              color: LightTheme.cGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'First, it will help you create and send quotes to your potential clients.',
                            style: bodyStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: new BoxDecoration(
                              color: LightTheme.cGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Then, it will help you track hours spent working for your clients.',
                            style: bodyStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: new BoxDecoration(
                              color: LightTheme.cGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'And finally, it will make invoicing to be as easy as a button tap!',
                            style: bodyStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Check out this short intro to get you started.',
                            style: bodyStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
            ),
            PageViewModel(
              decoration: pageDecoration,
              title: "Add your first client",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/add-client.gif',
                    height: MediaQuery.of(context).size.height / 1.4,
                  ),
                ],
              ),
            ),
            PageViewModel(
              decoration: pageDecoration,
              title: "Add new job",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/add-job.gif',
                    height: MediaQuery.of(context).size.height / 1.4,
                  ),
                ],
              ),
            ),
            PageViewModel(
              decoration: pageDecoration,
              title: "Do the work",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/job-in-progress.gif',
                    height: MediaQuery.of(context).size.height / 1.4,
                  ),
                ],
              ),
            ),
            PageViewModel(
              decoration: pageDecoration,
              title: "Generate and send invoice",
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/generate-invoice.gif',
                    height: MediaQuery.of(context).size.height / 1.4,
                  ),
                ],
              ),
            ),
            PageViewModel(
              decoration: pageDecoration,
              titleWidget: Column(
                children: [
                  Text(
                    'But first, update your details',
                    style: titleStyle,
                  ),
                ],
              ),
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/my-details.gif',
                    height: MediaQuery.of(context).size.height / 1.4,
                  ),
                ],
              ),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: LightTheme.cGreen,
            activeColor: LightTheme.cGreen,
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
