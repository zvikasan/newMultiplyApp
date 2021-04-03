import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/backup_reminders_model.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:sole_trader/screens/archived_clients_list_screen.dart';
import 'package:sole_trader/screens/h_table_of_contents_screen.dart';
import 'package:sole_trader/screens/privacy_policy_screen.dart';
import 'package:sole_trader/screens/terms_and_conditions_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import 'clients_list_screen.dart';
import 'my_details_screen.dart';
import 'package:flutter_share/flutter_share.dart';

class OptionsScreen extends StatefulWidget {
  final BuildContext context;

  const OptionsScreen({Key key, this.context}) : super(key: key);

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    String path;
    return Scaffold(
        bottomNavigationBar: ThemeBottomNavigationBar(
          context: context,
          key: Key('OptionsScreen'),
        ),
        backgroundColor: LightTheme.cLightYellow,
        appBar: ThemeAppBar(
          appBar: AppBar(),
          context: context,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Options',
                    style: TextStyle(
                      color: LightTheme.cDarkBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 1.5, 30, 0),
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  // crossAxisSpacing: SizeConfig.blockSizeVertical * 5,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.backup, color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'Backup',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          var databasesPath = await getDatabasesPath();
                          String path = p.join(databasesPath, 'sole_trader.db');
                          String targetPath;
                          File sourceFile = File(path);
                          List<int> content = await sourceFile.readAsBytes();
                          if (Platform.isIOS) {
                            targetPath =
                                p.join(databasesPath, 'sole_trader.db');
                          } else {
                            final targetDir =
                                await getExternalStorageDirectory();
                            targetPath =
                                p.join(targetDir.path, 'soleTraderBackup.stb');
                          }
                          File targetFile = File(targetPath);
                          await targetFile.writeAsBytes(content, flush: true);
                          Uint8List bytes = targetFile.readAsBytesSync();

                          // await Printing.sharePdf(
                          //     bytes: bytes, filename: 'soleTraderBackup.stb');

                          await FlutterShare.shareFile(
                            title: 'soleTraderBackup.stb',
                            filePath: targetPath,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restore,
                                  color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'Restore',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        onPressed: () {
                          Alert(
                            style: AlertStyle(
                                alertBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                isCloseButton: false,
                                backgroundColor: LightTheme.cLightYellow2,
                                overlayColor: Colors.black54),
                            context: context,
                            title: "Warning",
                            desc:
                                "Restoring data will ERASE all the current entries of your clients and jobs!",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Restore",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  {
                                    Navigator.pop(context);
                                    var databasesPath =
                                        await getDatabasesPath();
                                    path =
                                        p.join(databasesPath, 'sole_trader.db');
                                    DatabaseHelper.instance.closeDatabase();
                                    DatabaseHelper.instance.deleteDb();

                                    FilePickerResult result =
                                        await FilePicker.platform.pickFiles();

                                    if (result != null) {
                                      File file =
                                          File(result.files.single.path);
                                      List<int> updatedContent =
                                          await File(file.path).readAsBytes();

                                      await File(path).writeAsBytes(
                                          updatedContent,
                                          flush: true);
                                    }
                                    // File file = await FilePicker.getFile(
                                    //     type: FileType.any);
                                  }
                                  // Setting a new date for backup reminder after restoring
                                  var _backupReminderProvider =
                                      Provider.of<DataProvider>(context,
                                          listen: false);
                                  BackupReminder _backupReminder =
                                      await _backupReminderProvider
                                          .getBackupReminder();
                                  _backupReminder.lastNotifiedDate =
                                      DateTime.now();
                                  _backupReminderProvider
                                      .updateBackupReminder(_backupReminder);

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClientsListScreen()),
                                      (Route<dynamic> route) => false);
                                },
                                color: LightTheme.cRed,
                                radius: BorderRadius.circular(15.0),
                              ),
                              DialogButton(
                                child: Text(
                                  "Go Back",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: LightTheme.cGreen,
                                radius: BorderRadius.circular(15.0),
                              ),
                            ],
                          ).show();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyDetailsScreen(),
                              ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person, color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'My details',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.archive,
                                  color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'Archived clients',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArchivedClientsListScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.alarm_on,
                                  color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'Backup reminder',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        onPressed: () async {
                          int _groupValue;
                          var _backupReminderProvider =
                              Provider.of<DataProvider>(context, listen: false);
                          Future<BackupReminder> _backupReminder =
                              _backupReminderProvider.getBackupReminder();

                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              context: context,
                              backgroundColor: LightTheme.cLightYellow2,
                              isScrollControlled: false,
                              builder: (BuildContext builder) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return FutureBuilder(
                                    future: _backupReminder,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      _groupValue =
                                          snapshot.data.notificationPeriod;
                                      _onChanged(int value) {
                                        setState(() {
                                          _groupValue = value;
                                        });
                                        snapshot.data.notificationPeriod =
                                            value;
                                        snapshot.data.lastNotifiedDate =
                                            DateTime.now();
                                        _backupReminderProvider
                                            .updateBackupReminder(
                                                snapshot.data);
                                      }

                                      return Container(
                                        height: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height /
                                            3,
                                        child: Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Backup reminder duration',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          activeColor:
                                                              LightTheme.cGreen,
                                                          value: 1,
                                                          groupValue:
                                                              _groupValue,
                                                          onChanged: _onChanged,
                                                        ),
                                                        Text(
                                                          'Daily',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          activeColor:
                                                              LightTheme.cGreen,
                                                          value: 3,
                                                          groupValue:
                                                              _groupValue,
                                                          onChanged: _onChanged,
                                                        ),
                                                        Text(
                                                          'Monthly',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          activeColor:
                                                              LightTheme.cGreen,
                                                          value: 2,
                                                          groupValue:
                                                              _groupValue,
                                                          onChanged: _onChanged,
                                                        ),
                                                        Text(
                                                          'Weekly',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          activeColor:
                                                              LightTheme.cGreen,
                                                          value: 0,
                                                          groupValue:
                                                              _groupValue,
                                                          onChanged: _onChanged,
                                                        ),
                                                        Text(
                                                          'Off',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HTableOfContentsScreen(),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.live_help,
                                  color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'How to ...',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PrivacyPolicyScreen(),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, color: Colors.white, size: 60),
                              SizedBox(width: 20),
                              Text(
                                'Privacy policy',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TermsAndConditionsScreen(),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        elevation: 2,
                        color: LightTheme.cGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/fact_check-icon.png',
                                width: 60,
                              ),
                              SizedBox(width: 20),
                              Text(
                                'T & C',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
