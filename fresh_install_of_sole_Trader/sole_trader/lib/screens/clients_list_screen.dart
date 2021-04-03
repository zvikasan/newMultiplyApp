import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:sole_trader/models/backup_reminders_model.dart';
import 'package:sole_trader/screens/generate_invoice_screen.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import '../database_helper.dart';
import 'add_client_screen.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/screens/jobs_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'generate_invoice_screen.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sole_trader/components.dart';

class ClientsListScreen extends StatefulWidget {
  @override
  _ClientsListScreenState createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  Future<List<Client>> _clientList;
  Future<Map<int, int>> _jobsCountMap;
  BackupReminder backupReminder;
  // for purchases --------------
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;
  bool _userIsPro = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(
        "XDNEiOgbdtFlYZNwxqJWAiSGuChXzWNQ"); //here is my public API key
    Purchases.addAttributionData({}, PurchasesAttributionNetwork.facebook);
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    Offerings offerings = await Purchases.getOfferings();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _userIsPro =
          _purchaserInfo.entitlements.active.containsKey("unlimited_access");
      _offerings = offerings;
    });
  }
  // ^ for purchases ^ -----------------------------

  Widget _buildClientEntry(Client client) {
    String jobJobs;
    return FutureBuilder(
      future: _jobsCountMap,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data[client.clientId] == 1) {
          jobJobs = 'Job';
        } else {
          jobJobs = 'Jobs';
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  client.clientNickname,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: LightTheme.cDarkBlue,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                subtitle: Text(
                  snapshot.data[client.clientId] != null
                      ? 'Hourly Rate: \$${client.clientHourlyRate} • ${snapshot.data[client.clientId]} $jobJobs'
                      : 'Hourly Rate: \$${client.clientHourlyRate}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: LightTheme.cDarkBlue,
                  ),
                ),
                trailing: SizedBox(
                  width: 60.0,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GenerateInvoiceScreen(
                              client: client,
                            ),
                          ),
                        ),
                        child: Icon(
                          CupertinoIcons.news_solid,
                          size: 30,
                          color: LightTheme.cGreen,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddClientScreen(
                                      client: client,
                                    ))),
                        child: Icon(
                          CupertinoIcons.settings_solid,
                          size: 30,
                          color: LightTheme.cGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobsScreen(
                      client: client,
                      // updateJobsMap: _updateJobsCountMap,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _checkBackupReminder() async {
    Duration _reminderDuration;
    var backupReminderProvider = Provider.of<DataProvider>(context);
    backupReminder = await backupReminderProvider.getBackupReminder();
    if (backupReminder.notificationPeriod == 0) {
      _reminderDuration = null;
    } else if (backupReminder.notificationPeriod == 1) {
      _reminderDuration = Duration(days: 1);
    } else if (backupReminder.notificationPeriod == 2) {
      _reminderDuration = Duration(days: 7);
    } else if (backupReminder.notificationPeriod == 3) {
      _reminderDuration = Duration(days: 30);
    }
    if (_reminderDuration != null) {
      if (DateTime.now().difference(backupReminder.lastNotifiedDate) >
          _reminderDuration) {
        _showAlert(context);

        backupReminder.lastNotifiedDate = DateTime.now();
        backupReminderProvider.updateBackupReminder(backupReminder);
      }
    }
  }

  void _showAlert(BuildContext context) {
    Alert(
      style: AlertStyle(
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          isCloseButton: false,
          backgroundColor: LightTheme.cLightYellow2,
          overlayColor: Colors.black54),
      context: context,
      title: "Backup Reminder",
      desc:
          "Please remember to backup your data regularly.\n You can turn off this reminder in Options.",
      buttons: [
        DialogButton(
          child: Text(
            "Backup",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            var databasesPath = await getDatabasesPath();
            String path = p.join(databasesPath, 'sole_trader.db');
            String targetPath;
            File sourceFile = File(path);
            List<int> content = await sourceFile.readAsBytes();
            if (Platform.isIOS) {
              targetPath = p.join(databasesPath, 'sole_trader.db');
            } else {
              final targetDir = await getExternalStorageDirectory();
              targetPath = p.join(targetDir.path, 'soleTraderBackup.stb');
            }
            File targetFile = File(targetPath);
            await targetFile.writeAsBytes(content, flush: true);
            Uint8List bytes = targetFile.readAsBytesSync();

            await Printing.sharePdf(
                bytes: bytes, filename: 'soleTraderBackup.stb');
          },
          color: LightTheme.cGreen,
          radius: BorderRadius.circular(15.0),
        ),
        DialogButton(
          child: Text(
            "Not now",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: LightTheme.cRed,
          radius: BorderRadius.circular(15.0),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    var clientsListProvider = Provider.of<DataProvider>(context);
    _clientList = clientsListProvider.getClientList();
    _jobsCountMap = clientsListProvider.getJobsCountMap();
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('ClientsListScreen'),
        context: context,
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
        icon: Icon(
          Icons.add,
          size: 30,
        ),
        label: Text(
          'Add Client',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: () async {
          List<Client> _currentFullClientList =
              await DatabaseHelper.instance.getFullClientList();
          if (_userIsPro || _currentFullClientList.length < 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddClientScreen(),
              ),
            );
          } else {
            Alert(
              style: AlertStyle(
                  alertBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  isCloseButton: false,
                  backgroundColor: LightTheme.cLightYellow2,
                  overlayColor: Colors.black54),
              context: context,
              title: "Client Limit Exceeded",
              desc:
                  "You've exceeded the trial limit. Please consider purchasing the full version of soleTrader",
              buttons: [
                DialogButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: LightTheme.cGreen,
                  radius: BorderRadius.circular(15.0),
                ),
                DialogButton(
                  child: Text(
                    "Purchase",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    return UpsellScreen(
                      offerings: _offerings,
                    );
                  },
                  color: LightTheme.cGreen,
                  radius: BorderRadius.circular(15.0),
                ),
              ],
            ).show();
          }
        },
      ),
      body: FutureBuilder(
          future: _clientList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              _checkBackupReminder();
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      color: LightTheme.cLightYellow,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'My Clients',
                          style: TextStyle(
                            color: LightTheme.cDarkBlue,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          snapshot.data.length != 1
                              ? 'Currently I have ${snapshot.data.length} clients!'
                              : 'Currently I have ${snapshot.data.length} client!',
                          style: TextStyle(
                            color: LightTheme.cBrownishGrey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        //SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Expanded(
                    child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                        itemCount: 1 + snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 3),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: (index % 2 == 0)
                                  ? LightTheme.cLightGreen
                                  : LightTheme.cLightGreen,
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: LightTheme.cBrownishGrey,
                                      size: 20,
                                    ),
                                  ),
                                  _buildClientEntry(snapshot.data[index - 1]),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: LightTheme.cDarkYellow,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              -2.0, -2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
