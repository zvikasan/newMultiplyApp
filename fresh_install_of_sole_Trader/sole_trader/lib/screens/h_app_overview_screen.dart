import 'package:flutter/material.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'h_job_to_invoice_workflow_screen.dart';
import 'h_quoting_workflow_screen.dart';
import 'h_table_of_contents_screen.dart';

class HAppOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(
        color: LightTheme.cDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w600);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('HAppOverviewScreen'),
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
                        'Overview',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: 'soleTrader',
                          style: bodyTextStyle.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins'),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    ' app was made for freelancers and sole traders who charge for their work by the hour, need to track time on the job, and later invoice their clients.',
                                style: bodyTextStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins'))
                          ]),
                    ),
                    SizedBox(height: 10),
                    Text(
                        'It was designed to be simple and fun to use but at the same time provide all the necessary functions and more!',
                        style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.w400)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RichText(
                        text: TextSpan(
                            text: 'soleTrader',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Poppins'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' will help you with:',
                                  style: bodyTextStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins'))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style: bodyTextStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: LightTheme.cGreen)),
                              Expanded(
                                child: Text('Creating quotes for your clients.',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w400)),
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
                                child: Text('Tracking your time on jobs.',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w400)),
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
                                child: Text(
                                    'Generating invoices using data from the jobs you’ve tracked.',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RichText(
                        text: TextSpan(
                            text: 'soleTrader',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Poppins'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' is designed for two main workflows:',
                                  style: bodyTextStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins'))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => HQuotingWorkflowScreen()),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: LightTheme.cGreen)),
                                Expanded(
                                  child: Text('Quoting workflow',
                                      style: bodyTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                          color: LightTheme.cGreen)),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        HJobToInvoiceWorkflowScreen()),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: LightTheme.cGreen)),
                                Expanded(
                                  child: Text('Job-to-invoice workflow',
                                      style: bodyTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                          color: LightTheme.cGreen)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
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
                    SizedBox(height: 60),
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
