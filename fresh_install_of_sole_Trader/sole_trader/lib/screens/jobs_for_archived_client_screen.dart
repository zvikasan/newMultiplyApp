import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/screens/add_job_screen.dart';
import 'package:sole_trader/models/job_model.dart';
import 'package:intl/intl.dart';
import 'package:duration/duration.dart';
import 'package:sole_trader/screens/job_details_for_archived_clients_screen.dart';
import 'add_client_screen.dart';
import 'job_details_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';

class JobsForArchivedClientsScreen extends StatefulWidget {
  final Client client;

  const JobsForArchivedClientsScreen({Key key, @required this.client})
      : super(key: key);
  @override
  _JobsForArchivedClientsScreenState createState() =>
      _JobsForArchivedClientsScreenState();
}

class _JobsForArchivedClientsScreenState
    extends State<JobsForArchivedClientsScreen> {
  Future<List<Job>> _jobList;
  Future<Client> archivedClient;
  final DateFormat _dateFormatterLeft = DateFormat('HH:mm');
  final DateFormat _dateFormatterRight = DateFormat('HH:mm dd MMM');
  final DateFormat _dateFormatterDateOnly = DateFormat('dd MMM');

  Widget _buildJob(Job job) {
    Duration _jobDuration;
    Duration _24h = Duration(hours: 24);
    String _jobDurationDisplay() {
      String output;
      if (job.jobStatus == 0) {
        output = '';
      } else if (job.jobStatus == 2) {
        output =
            '${_dateFormatterDateOnly.format(job.endTime)} | ${printDuration(job.endTime.difference(job.startTime), abbreviated: true, tersity: DurationTersity.minute)}';
      } else {
        output = '${_dateFormatterRight.format(job.startTime)}';
      }
      _jobDuration = job.endTime.difference(job.startTime);
      return output;
    }

    _jobDurationDisplay();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailsForArchivedClientsScreen(
              job: job,
              clientName: widget.client.clientNickname,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 0, 10),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.arrow_forward_ios,
                color: LightTheme.cBrownishGrey,
                size: 20,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Column(
                    //main left column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Row(
                        // title
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.jobName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: LightTheme.cDarkBlue,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ), //title
                        ],
                      ),
                      Row(
                        // job description and warning icon
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${job.jobDescription}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ), // job description
                        ],
                      ),
                      Row(
                        //job duration display
                        children: [
                          Expanded(
                            child: Text(
                              _jobDurationDisplay(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: LightTheme.cBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: RaisedButton(
                                onPressed: () {
                                  Alert(
                                    style: AlertStyle(
                                        alertBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        isCloseButton: false,
                                        backgroundColor:
                                            LightTheme.cLightYellow2,
                                        overlayColor: Colors.black54),
                                    context: context,
                                    title: "Restoring a Job",
                                    desc:
                                        "You can't restore a job of archived client. Restore the client to get full access to their jobs.",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Got it",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
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
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                color: LightTheme.cLightGrey,
                                visualDensity: VisualDensity.compact,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'Archived',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _jobDuration > _24h
                              ? IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Alert(
                                      style: AlertStyle(
                                          alertBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          isCloseButton: false,
                                          backgroundColor:
                                              LightTheme.cLightYellow2,
                                          overlayColor: Colors.black54),
                                      context: context,
                                      title: "Long Job Duration",
                                      desc:
                                          "Your Job duration is over 24h! Are you such a hard worker?",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "I Know, right !?",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: LightTheme.cGreen,
                                          radius: BorderRadius.circular(15.0),
                                        ),
                                      ],
                                    ).show();
                                  },
                                  icon: Icon(
                                    Icons.error_outline,
                                    color: LightTheme.cRed,
                                  ),
                                )
                              : IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            JobDetailsForArchivedClientsScreen(
                                          job: job,
                                          clientName:
                                              widget.client.clientNickname,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.error_outline,
                                      color: Color(0x00000000)),
                                ),
                        ],
                      ), //datetime duration
                    ],
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 28, 0),
                    child: Column(
                      //trailing column
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'hourly rate',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                '\$ ${job.jobHourlyRate}',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'total cost',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ), // hourly rate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                '\$ ${job.calculateJobEarnings(job).toString()}',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ), // total cost
                        Text(
                          'added costs',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ), // hourly rate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                '\$ ${job.jobAddedCosts}',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ), // additional costs
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var jobsListProvider = Provider.of<DataProvider>(context);
    _jobList = jobsListProvider.getJobListWithArchived(widget.client.clientId);
    archivedClient = jobsListProvider.getArchivedClient(widget.client.clientId);
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('JobsForArchivedClientsScreen'),
        context: context,
        clientId: widget.client.clientId,
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder(
            future: _jobList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
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
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Archived Jobs',
                                style: TextStyle(
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30.0,
                                ),
                              ),
                              FutureBuilder(
                                  future: archivedClient,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Text(
                                        snapshot.data.clientNickname,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: LightTheme.cBrownishGrey,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              Client newClient = await archivedClient;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddClientScreen(
                                            client: newClient,
                                            comingFromJobs: true,
                                            showArchived: true,
                                          )));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.settings_solid,
                                  size: 40,
                                  color: LightTheme.cGreen,
                                ),
                                Text(
                                  'Client Details',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: LightTheme.cDarkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        itemCount: 1 + snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return SizedBox.shrink();
                          }
                          return Dismissible(
                            // direction: DismissDirection.endToStart,
                            key: UniqueKey(),
                            background: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      snapshot.data[index - 1].isArchived == 1
                                          ? LightTheme.cRed
                                          : LightTheme.cBrownishGrey,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Delete Job',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              var jobsProvider = Provider.of<DataProvider>(
                                  context,
                                  listen: false);
                              jobsProvider
                                  .deleteJobWithUndo(snapshot.data[index - 1]);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: LightTheme.cLightYellow2,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${snapshot.data[index - 1].jobName} deleted',
                                        style: TextStyle(
                                          color: LightTheme.cDarkBlue,
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          jobsProvider.restoreJob();
                                        },
                                        child: Text(
                                          'Undo',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: LightTheme.cDarkBlue,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      )
                                    ],
                                  )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 3),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: (index % 2 == 0)
                                    ? LightTheme.cLighterGrey
                                    : LightTheme.cLighterGrey,
                                child: _buildJob(snapshot.data[index - 1]),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
