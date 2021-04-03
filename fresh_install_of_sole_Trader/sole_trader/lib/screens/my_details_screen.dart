import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/my_details_model.dart';
import 'package:sole_trader/screens/update_my_details_screen.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class MyDetailsScreen extends StatefulWidget {
  @override
  _MyDetailsScreenState createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  Future<MyDetails> _myDetails;
  MyDetails _myCurrentDetails;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var detailsInfo = Provider.of<DataProvider>(context);
    _myDetails = detailsInfo.getMyDetails();
    getMyDetails() async {
      _myCurrentDetails = await _myDetails;
    }

    getMyDetails();
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        context: context,
        key: Key('MyDetailsScreen'),
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        backgroundColor: LightTheme.cGreen,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        label: Text(
          'Edit My Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UpdateMyDetailsScreen(
                myDetails: _myCurrentDetails,
              ),
            ),
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            forceElevated: true,
            automaticallyImplyLeading: false,
            backgroundColor: LightTheme.cLightYellow,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                      color: LightTheme.cDarkBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 30.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: screenSize.width,
              childAspectRatio: screenSize.width / (screenSize.height - 95),
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: _myDetails,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // return (_buildMyDetailsScreen(snapshot.data));
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 40),
                            child: (Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Trading name',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 13.0,
                                      color: LightTheme.cGreen),
                                ),
                                Text(
                                  '${snapshot.data.myBillingName}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(thickness: 1),
                                Text(
                                  'Address',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 13.0,
                                      color: LightTheme.cGreen),
                                ),
                                Text(
                                  '${snapshot.data.myBillingAddress}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(thickness: 1),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 13.0,
                                      color: LightTheme.cGreen),
                                ),
                                Text(
                                  '${snapshot.data.myEmail}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(thickness: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mobile',
                                          style: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 13.0,
                                              color: LightTheme.cGreen),
                                        ),
                                        Text(
                                          '${snapshot.data.myMobile}',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: LightTheme.cDarkBlue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1),
                                Text(
                                  'Payment details',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 13.0,
                                      color: LightTheme.cGreen),
                                ),
                                Text(
                                  '${snapshot.data.myPaymentDetails}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(thickness: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tax rate',
                                          style: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 13.0,
                                              color: LightTheme.cGreen),
                                        ),
                                        Text(
                                          '${snapshot.data.myTaxRate}%',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: LightTheme.cDarkBlue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 50),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\'No GST\' Message',
                                          style: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 13.0,
                                              color: LightTheme.cGreen),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              snapshot.data.gstRequired == 0
                                                  ? 'No'
                                                  : 'Yes',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: LightTheme.cDarkBlue,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.help_outline,
                                                color: LightTheme.cGreen,
                                              ),
                                              onTap: () {
                                                Alert(
                                                  style: AlertStyle(
                                                      alertBorder:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      isCloseButton: false,
                                                      backgroundColor:
                                                          LightTheme
                                                              .cLightYellow2,
                                                      overlayColor:
                                                          Colors.black54),
                                                  context: context,
                                                  title: "For Australia",
                                                  desc:
                                                      "If 'Yes', adds message to the invoice that you are not required to register for GST",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "Got it",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      color: LightTheme.cGreen,
                                                      radius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ],
                                                ).show();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pay within',
                                          style: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 13.0,
                                              color: LightTheme.cGreen),
                                        ),
                                        Text(
                                          '${snapshot.data.myExpectedPaymentPeriod} days',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: LightTheme.cDarkBlue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 35),
                                    Column(
                                      children: [
                                        Text(
                                          'Next Invoice №',
                                          style: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 13.0,
                                              color: LightTheme.cGreen),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '№ ${snapshot.data.nextInvoiceNumber}  ',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: LightTheme.cDarkBlue,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.help_outline,
                                                color: LightTheme.cGreen,
                                              ),
                                              onTap: () {
                                                Alert(
                                                  style: AlertStyle(
                                                      alertBorder:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      isCloseButton: false,
                                                      backgroundColor:
                                                          LightTheme
                                                              .cLightYellow2,
                                                      overlayColor:
                                                          Colors.black54),
                                                  context: context,
                                                  title: "Invoice numbering",
                                                  desc:
                                                      "Each time you generate an invoice, this number will increment.",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "Got it",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      color: LightTheme.cGreen,
                                                      radius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ],
                                                ).show();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Additional info',
                                            style: TextStyle(
                                                letterSpacing: 1.2,
                                                fontSize: 13.0,
                                                color: LightTheme.cGreen),
                                          ),
                                          Text(
                                            '${snapshot.data.myAdditionalInfo}',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: LightTheme.cDarkBlue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(height: 150),
                                ),

                                // SizedBox(height: 40),
                              ],
                            )),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
