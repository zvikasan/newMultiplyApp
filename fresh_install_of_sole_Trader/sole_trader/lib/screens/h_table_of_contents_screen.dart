import 'package:flutter/material.dart';
import 'package:sole_trader/screens/h_app_overview_screen.dart';
import 'package:sole_trader/screens/h_archiving_clients_screen.dart';
import 'package:sole_trader/screens/h_archiving_jobs_screen.dart';
import 'package:sole_trader/screens/h_job_to_invoice_workflow_screen.dart';
import 'package:sole_trader/screens/h_options_screen.dart';
import 'package:sole_trader/screens/h_quoting_workflow_screen.dart';
import 'package:sole_trader/screens/h_tips_and_tricks_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class HTableOfContentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(
        color: LightTheme.cGreen,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('HTableOfContentsScreen'),
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
                        'Help',
                        style: TextStyle(
                          color: LightTheme.cDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0,
                        ),
                      ),
                      Text(
                        'Table of contents',
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => HAppOverviewScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'soleTrader app overview',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => HQuotingWorkflowScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'Quoting workflow',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => HJobToInvoiceWorkflowScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'Job-to-invoice workflow',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => HArchivingJobsScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'Archiving jobs',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => HArchivingClientsScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'Archiving clients',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HOptionsScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'Options',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => HTipsAndTricksScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: LightTheme.cGreen,
                            size: 40,
                          ),
                          Text(
                            'Tips and tricks',
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
