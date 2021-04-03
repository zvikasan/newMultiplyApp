import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'add_client_screen.dart';
import 'jobs_for_archived_client_screen.dart';

class ArchivedClientsListScreen extends StatefulWidget {
  @override
  _ArchivedClientsListScreenState createState() =>
      _ArchivedClientsListScreenState();
}

class _ArchivedClientsListScreenState extends State<ArchivedClientsListScreen> {
  Future<List<Client>> _archivedClientList;
  Future<Map<int, int>> _jobsCountMap;

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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddClientScreen(
                                      client: client,
                                      showArchived: true,
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
                    builder: (context) => JobsForArchivedClientsScreen(
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

  @override
  Widget build(BuildContext context) {
    var archivedClientListProvider = Provider.of<DataProvider>(context);
    _archivedClientList = archivedClientListProvider.getArchivedClientList();
    _jobsCountMap =
        archivedClientListProvider.getJobsCountForArchivedClientsMap();
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('ArchivedClientsListScreen'),
        context: context,
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      body: FutureBuilder(
          future: _archivedClientList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
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
                          'Archived Clients',
                          style: TextStyle(
                            color: LightTheme.cDarkBlue,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          snapshot.data.length != 1
                              ? 'Currently I have ${snapshot.data.length} archived clients!'
                              : 'Currently I have ${snapshot.data.length} archived client!',
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
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: (index % 2 == 0)
                                  ? LightTheme.cLighterGrey
                                  : LightTheme.cLighterGrey,
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
