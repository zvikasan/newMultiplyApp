import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:sole_trader/screens/generate_invoice_screen.dart';
import 'package:sole_trader/screens/jobs_screen.dart';
import 'package:sole_trader/screens/my_details_screen.dart';
import 'package:sole_trader/screens/options_screen.dart';
import 'package:sole_trader/screens/privacy_policy_screen.dart';
import 'package:sole_trader/screens/quotes_screen.dart';
import 'theme_colors.dart';
import 'package:sole_trader/screens/clients_list_screen.dart';

class ThemeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemeAppBar({Key key, this.appBar, this.context}) : super(key: key);
  final BuildContext context;
  final Color backgroundColor = LightTheme.cDarkYellow;
  final Color textColor = LightTheme.cDarkBlue;
  final Color iconsColor = LightTheme.cDarkBlue;
  final AppBar appBar;

  void handleAppBarMenu(String value) {
    switch (value) {
      case 'Clients':
        {
          if (context.widget.toString() == 'ClientsListScreen') {
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientsListScreen(),
                ));
          }
        }
        break;
      case 'My Details':
        {
          if (context.widget.toString() == 'MyDetailsScreen') {
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyDetailsScreen(),
                ));
          }
        }
        break;
      case 'Invoicing':
        {
          if (context.widget.toString() == 'GenerateInvoiceScreen') {
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateInvoiceScreen(),
                ));
          }
        }
        break;
      case 'Options':
        {
          if (context.widget.toString() == 'OptionsScreen') {
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OptionsScreen(
                    context: context,
                  ),
                ));
          }
        }
        break;
      case 'Quotes':
        {
          if (context.widget.toString() == 'QuotesScreen') {
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuotesScreen(),
                ));
          }
        }
        break;
      case 'Privacy Policy':
        {
          if (context.widget.toString() == 'PrivacyPolicyScreen') {
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrivacyPolicyScreen(),
                ));
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'soleTrader',
        style: TextStyle(
          color: textColor,
          fontSize: 22.0,
          fontWeight: FontWeight.w800,
          fontFamily: 'Poppins',
          letterSpacing: 1.2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      backgroundColor: backgroundColor,
      // actions: widgets,
      centerTitle: true,
      elevation: 1,
      iconTheme: IconThemeData(color: iconsColor, size: 30),
      actions: <Widget>[
        PopupMenuButton<String>(
          color: LightTheme.cDarkYellow,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          onSelected: handleAppBarMenu,
          itemBuilder: (BuildContext context) {
            return {
              'Clients',
              'Invoicing',
              'Quotes',
              'My Details',
              'Options',
              'Privacy Policy'
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Column(
                  children: [
                    Text(
                      choice,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: LightTheme.cDarkBlue,
                      ),
                    ),
                    Divider(thickness: 1),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class ThemeBottomNavigationBar extends StatelessWidget {
  const ThemeBottomNavigationBar({
    Key key,
    this.context,
    this.clientId,
  }) : super(key: key);
  final BuildContext context;
  final int clientId;

  Widget _buildClientListEntryForDrawer(Client client) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                client.clientNickname,
                style: TextStyle(
                  color: LightTheme.cDarkBlue,
                  fontSize: 18,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => JobsScreen(
                    client: client,
                    // updateJobsMap: _updateJobsCountMap,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Client>> _clientList;
    var jobsListProvider = Provider.of<DataProvider>(context);
    _clientList = jobsListProvider.getClientList();
    return Container(
      decoration: context.widget.key.toString() ==
                  '[<\'ClientsListScreen\'>]' ||
              context.widget.key.toString() == '[<\'JobsScreen\'>]' ||
              context.widget.key.toString() ==
                  '[<\'JobsForArchivedClientsScreen\'>]' ||
              context.widget.key.toString() ==
                  '[<\'ArchivedClientsListScreen\'>]'
          ? BoxDecoration(
              color: LightTheme.cDarkYellow,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
              ),
            )
          : BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, -2.0), // shadow direction: bottom right
                )
              ],
              color: LightTheme.cDarkYellow,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              elevation: 2,
              visualDensity: VisualDensity.compact,
              child: Text(
                'Clients',
                style: TextStyle(color: LightTheme.cDarkBlue),
              ),
              onPressed: () {
                if (context.widget.key.toString() ==
                    '[<\'ClientsListScreen\'>]') {
                } else {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      backgroundColor: LightTheme.cLightYellow2,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.5,
                          maxChildSize: 0.5,
                          minChildSize: 0.25,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return FutureBuilder(
                              future: _clientList,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: 1 + snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Choose a Client',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ClientsListScreen()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 60,
                                                  child: Card(
                                                    color: LightTheme
                                                        .cDarkerYellow,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  35, 0, 0, 0),
                                                          child: Text(
                                                            'Clients List',
                                                            style: TextStyle(
                                                              color: LightTheme
                                                                  .cDarkBlue,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: LightTheme
                                                                .cBrownishGrey,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: (index % 2 == 0)
                                              ? LightTheme.cDarkYellow
                                              : LightTheme.cDarkYellow,
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color:
                                                      LightTheme.cBrownishGrey,
                                                  size: 20,
                                                ),
                                              ),
                                              _buildClientListEntryForDrawer(
                                                  snapshot.data[index - 1]),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            );
                          },
                        );
                      });
                }
              },
              color: LightTheme.cDarkYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            RaisedButton(
              elevation: 2,
              visualDensity: VisualDensity.compact,
              child: Text(
                'Invoicing',
                style: TextStyle(color: LightTheme.cDarkBlue),
              ),
              onPressed: () {
                if (context.widget.key.toString() ==
                    '[<\'GenerateInvoiceScreen\'>]') {
                } else if (context.widget.key.toString() ==
                    '[<\'JobsScreen\'>]') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateInvoiceScreen(
                          clientId: clientId,
                        ),
                      ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateInvoiceScreen(),
                      ));
                }
              },
              color: LightTheme.cDarkYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            RaisedButton(
              elevation: 2,
              visualDensity: VisualDensity.compact,
              child: Text(
                'Quotes',
                style: TextStyle(color: LightTheme.cDarkBlue),
              ),
              onPressed: () {
                if (context.widget.key.toString() == '[<\'QuotesScreen\'>]') {
                } else if (context.widget.key.toString() ==
                    '[<\'JobsScreen\'>]') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuotesScreen(
                          clientId: clientId,
                        ),
                      ));
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuotesScreen(),
                      ));
                }
              },
              color: LightTheme.cDarkYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            RaisedButton(
              elevation: 2,
              visualDensity: VisualDensity.compact,
              child: Text(
                'Options',
                style: TextStyle(color: LightTheme.cDarkBlue),
              ),
              onPressed: () {
                if (context.widget.key.toString() == '[<\'OptionsScreen\'>]') {
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OptionsScreen(
                          context: context,
                        ),
                      ));
                }
              },
              color: LightTheme.cDarkYellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}
