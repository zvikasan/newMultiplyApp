import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/job_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class JobDetailsForArchivedClientsScreen extends StatefulWidget {
  final Job job;
  final String clientName;

  JobDetailsForArchivedClientsScreen({this.job, this.clientName});

  @override
  _JobDetailsForArchivedClientsScreenState createState() =>
      _JobDetailsForArchivedClientsScreenState();
}

class _JobDetailsForArchivedClientsScreenState
    extends State<JobDetailsForArchivedClientsScreen> {
  final DateFormat _dateFormatter = DateFormat('HH:mm dd MMM, yyy');

  Future<Client> client;
  String alertMsg =
      "You can't edit jobs of archived client. Restore the client to get full access to their jobs.";

  _delete() {
    var jobsProvider = Provider.of<DataProvider>(context, listen: false);
    jobsProvider.deleteJob(widget.job.jobId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var jobsListProvider = Provider.of<DataProvider>(context);
    client = jobsListProvider.getClient(widget.job.clientId);
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        context: context,
        key: Key('JobDetailsScreen'),
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        backgroundColor: LightTheme.cRed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        label: Text(
          'Delete Job',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
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
            title: "Deleting a Job",
            desc: "Do I really want to delete ${widget.job.jobName}?",
            buttons: [
              DialogButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  _delete();
                  Navigator.pop(context);
                },
                color: LightTheme.cRed,
                radius: BorderRadius.circular(15.0),
              ),
              DialogButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            'Job details',
                            style: TextStyle(
                              color: LightTheme.cDarkBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        Text(
                          widget.clientName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: LightTheme.cBrownishGrey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              onTap: () {
                                Alert(
                                  style: AlertStyle(
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      isCloseButton: false,
                                      backgroundColor: LightTheme.cLightYellow2,
                                      overlayColor: Colors.black54),
                                  context: context,
                                  title: "Edit Details",
                                  desc: alertMsg,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: LightTheme.cGreen,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                  ],
                                ).show();
                              },
                              readOnly: true,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Job Name',
                                labelStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 18.0,
                                    color: LightTheme.cGreen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              initialValue: widget.job.jobName,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              onTap: () {
                                Alert(
                                  style: AlertStyle(
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      isCloseButton: false,
                                      backgroundColor: LightTheme.cLightYellow2,
                                      overlayColor: Colors.black54),
                                  context: context,
                                  title: "Edit Details",
                                  desc: alertMsg,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: LightTheme.cGreen,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                  ],
                                ).show();
                              },
                              readOnly: true,
                              maxLines: 3,
                              minLines: 1,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Job Description',
                                labelStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 18.0,
                                    color: LightTheme.cGreen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              initialValue: widget.job.jobDescription,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                                onTap: () {
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
                                    title: "Edit Details",
                                    desc: alertMsg,
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: LightTheme.cGreen,
                                        radius: BorderRadius.circular(15.0),
                                      ),
                                    ],
                                  ).show();
                                },
                                readOnly: true,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: LightTheme.cDarkBlue,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  prefix: Text(
                                    '\$',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: LightTheme.cDarkBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  isDense: true,
                                  labelText: 'Hourly rate for this job',
                                  labelStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 18.0,
                                      color: LightTheme.cGreen),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cGreen),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cGreen),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                initialValue:
                                    widget.job.jobHourlyRate.toString()),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              onTap: () {
                                Alert(
                                  style: AlertStyle(
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      isCloseButton: false,
                                      backgroundColor: LightTheme.cLightYellow2,
                                      overlayColor: Colors.black54),
                                  context: context,
                                  title: "Edit Details",
                                  desc: alertMsg,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: LightTheme.cGreen,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                  ],
                                ).show();
                              },
                              readOnly: true,
                              initialValue:
                                  _dateFormatter.format(widget.job.startTime),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Job Start Time',
                                labelStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 18.0,
                                    color: LightTheme.cGreen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              onTap: () {
                                Alert(
                                  style: AlertStyle(
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      isCloseButton: false,
                                      backgroundColor: LightTheme.cLightYellow2,
                                      overlayColor: Colors.black54),
                                  context: context,
                                  title: "Edit Details",
                                  desc: alertMsg,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: LightTheme.cGreen,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                  ],
                                ).show();
                              },
                              readOnly: true,
                              initialValue:
                                  _dateFormatter.format(widget.job.endTime),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Job End Time',
                                labelStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 18.0,
                                    color: LightTheme.cGreen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              onTap: () {
                                Alert(
                                  style: AlertStyle(
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      isCloseButton: false,
                                      backgroundColor: LightTheme.cLightYellow2,
                                      overlayColor: Colors.black54),
                                  context: context,
                                  title: "Edit Details",
                                  desc: alertMsg,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: LightTheme.cGreen,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                  ],
                                ).show();
                              },
                              readOnly: true,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                prefix: Text(
                                  '\$',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                ),
                                isDense: true,
                                labelText: 'Added costs',
                                labelStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 18.0,
                                    color: LightTheme.cGreen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              initialValue: widget.job.jobAddedCosts.toString(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              onTap: () {
                                Alert(
                                  style: AlertStyle(
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      isCloseButton: false,
                                      backgroundColor: LightTheme.cLightYellow2,
                                      overlayColor: Colors.black54),
                                  context: context,
                                  title: "Edit Details",
                                  desc: alertMsg,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: LightTheme.cGreen,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                  ],
                                ).show();
                              },
                              readOnly: true,
                              maxLines: 4,
                              minLines: 1,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: LightTheme.cDarkBlue,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Job Notes',
                                labelStyle: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 18.0,
                                    color: LightTheme.cGreen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: LightTheme.cGreen),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              initialValue: widget.job.jobNotes,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      )),
                      SizedBox(height: 30),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
