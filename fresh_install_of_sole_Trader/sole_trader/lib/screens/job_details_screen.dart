import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/job_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  final String clientName;

  JobDetailsScreen({this.job, this.clientName});

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final _formKey = GlobalKey<FormState>(); //key to validate user's input
  bool _autoValidate = false;
  final DateFormat _dateFormatter = DateFormat('HH:mm dd MMM, yyy');
  TextEditingController _jobStartTimeController = TextEditingController();
  TextEditingController _jobEndTimeController = TextEditingController();

  DateTime _tempStartTime;
  DateTime _tempEndTime;

  String _jobName = '';
  String _jobDescription = '';
  double _jobHourlyRate;
  DateTime _jobStartTime;
  DateTime _jobEndTime;
  double _jobAddedCosts;
  String _jobNotes;
  int _jobStatus;

  Future<Client> client;

  @override
  void dispose() {
    _jobStartTimeController.dispose();
    _jobEndTimeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _jobName = widget.job.jobName;
    _jobDescription = widget.job.jobDescription;
    _jobHourlyRate = widget.job.jobHourlyRate;
    _jobStartTime = widget.job.startTime;
    _jobEndTime = widget.job.endTime;
    _jobAddedCosts = widget.job.jobAddedCosts;
    _jobNotes = widget.job.jobNotes;
    _jobStartTimeController.text = _dateFormatter.format(_jobStartTime);
    _jobEndTimeController.text = _dateFormatter.format(_jobEndTime);
    _jobStatus = widget.job.jobStatus;
    _tempStartTime = widget.job.startTime;
    _tempEndTime = widget.job.endTime;
  }

  _delete() {
    var jobsProvider = Provider.of<DataProvider>(context, listen: false);
    jobsProvider.deleteJob(widget.job.jobId);
    Navigator.pop(context);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Job job = Job(
        clientId: widget.job.clientId,
        jobName: _jobName,
        jobDescription: _jobDescription,
        jobHourlyRate: _jobHourlyRate,
        startTime: _jobStartTime,
        endTime: _jobEndTime,
        jobAddedCosts: _jobAddedCosts,
        jobNotes: _jobNotes,
        jobStatus: _jobStatus,
        isArchived: widget.job.isArchived,
      );
      if (job.isArchived == 0 || job.isArchived == null) {
        job.isArchived = 0;
      } else {
        job.isArchived = 1;
      }
      job.jobId = widget.job.jobId;
      var jobsProvider = Provider.of<DataProvider>(context, listen: false);
      jobsProvider.updateJob(job);
      Navigator.pop(context);
    } else {
      setState(() => _autoValidate = true);
    }
  }

  _archive() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Job job = Job(
        clientId: widget.job.clientId,
        jobName: _jobName,
        jobDescription: _jobDescription,
        jobHourlyRate: _jobHourlyRate,
        startTime: _jobStartTime,
        endTime: _jobEndTime,
        jobAddedCosts: _jobAddedCosts,
        jobNotes: _jobNotes,
        jobStatus: _jobStatus,
        isArchived: 1,
      );

      job.jobId = widget.job.jobId;
      var jobsProvider = Provider.of<DataProvider>(context, listen: false);
      jobsProvider.updateJob(job);
      Navigator.pop(context);
    } else {
      setState(() => _autoValidate = true);
    }
  }

  _restore() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Job job = Job(
        clientId: widget.job.clientId,
        jobName: _jobName,
        jobDescription: _jobDescription,
        jobHourlyRate: _jobHourlyRate,
        startTime: _jobStartTime,
        endTime: _jobEndTime,
        jobAddedCosts: _jobAddedCosts,
        jobNotes: _jobNotes,
        jobStatus: _jobStatus,
        isArchived: 0,
      );

      job.jobId = widget.job.jobId;
      var jobsProvider = Provider.of<DataProvider>(context, listen: false);
      jobsProvider.updateJob(job);
      Navigator.pop(context);
    } else {
      setState(() => _autoValidate = true);
    }
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
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Container(
                //width: double.infinity,
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
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
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
                                'Edit job details',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.restore,
                                size: 40,
                                color: LightTheme.cRed,
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
                                  title: "Resetting Job Clock",
                                  desc:
                                      "This will reset the duration of this job to zero!",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _jobStatus = 0;
                                          _jobStartTime = DateTime.now();
                                          _jobEndTime = DateTime.now()
                                              .add(Duration(seconds: 1));
                                          _tempEndTime = _jobEndTime;
                                          _jobStartTimeController.text =
                                              _dateFormatter
                                                  .format(_jobStartTime);
                                          _jobEndTimeController.text =
                                              _dateFormatter
                                                  .format(_jobEndTime);
                                        });
                                        _submit();
                                        // Navigator.pop(context);
                                      },
                                      color: LightTheme.cRed,
                                      radius: BorderRadius.circular(15.0),
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "No",
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
                              }),
                          Text(
                            'Reset job clock',
                            style: TextStyle(
                              fontSize: 8,
                              color: LightTheme.cBrownishGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Form(
                              key: _formKey,
                              autovalidate: _autoValidate,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      cursorColor: LightTheme.cDarkBlue,
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
                                              width: 3,
                                              color: LightTheme.cGreen),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: LightTheme.cGreen),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: LightTheme.cPalePink),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: LightTheme.cRed),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        errorStyle: TextStyle(
                                            letterSpacing: 1.2,
                                            color: LightTheme.cRed,
                                            height: 0.4),
                                      ),
                                      validator: (input) => input.trim().isEmpty
                                          ? 'Please enter a job Name'
                                          : null,
                                      onSaved: (input) => _jobName = input,
                                      initialValue: widget.job.jobName,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.newline,
                                      maxLines: 3,
                                      minLines: 2,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      cursorColor: LightTheme.cDarkBlue,
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
                                              width: 3,
                                              color: LightTheme.cGreen),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: LightTheme.cGreen),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: LightTheme.cPalePink),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: LightTheme.cRed),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        errorStyle: TextStyle(
                                            letterSpacing: 1.2,
                                            color: LightTheme.cRed,
                                            height: 0.4),
                                      ),
                                      validator: (input) => input.trim().isEmpty
                                          ? 'Please enter a job description'
                                          : null,
                                      onSaved: (input) =>
                                          _jobDescription = input,
                                      initialValue: widget.job.jobDescription,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                        cursorColor: LightTheme.cDarkBlue,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
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
                                                width: 3,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cPalePink),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: LightTheme.cRed),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorStyle: TextStyle(
                                              letterSpacing: 1.2,
                                              color: LightTheme.cRed,
                                              height: 0.4),
                                        ),
                                        validator: (input) => double.tryParse(
                                                    input) ==
                                                null
                                            ? 'Please enter valid hourly rate'
                                            : null,
                                        onSaved: (input) => _jobHourlyRate =
                                            double.parse(input),
                                        initialValue: widget.job.jobHourlyRate
                                            .toString()),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                        readOnly: true,
                                        controller: _jobStartTimeController,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: LightTheme.cDarkBlue,
                                            fontWeight: FontWeight.w600),
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext builder) {
                                                return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .copyWith()
                                                                .size
                                                                .height /
                                                            3,
                                                    child: CupertinoDatePicker(
                                                      backgroundColor:
                                                          LightTheme
                                                              .cLightYellow2,
                                                      initialDateTime:
                                                          _jobStartTime,
                                                      onDateTimeChanged:
                                                          (DateTime newDate) {
                                                        _tempStartTime =
                                                            newDate;
                                                        _jobStartTimeController
                                                                .text =
                                                            _dateFormatter
                                                                .format(
                                                                    newDate);
                                                        _jobStartTime = newDate;
                                                        if (_jobStatus == 0) {
                                                          _jobStatus = 1;
                                                        }
                                                      },
                                                      use24hFormat: true,
                                                      maximumDate: DateTime(
                                                          2100, 12, 30),
                                                      minimumYear: 2000,
                                                      maximumYear: 2100,
                                                      minuteInterval: 1,
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .dateAndTime,
                                                    ));
                                              });
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Job Start Time',
                                          labelStyle: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 18.0,
                                              color: LightTheme.cGreen),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cPalePink),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: LightTheme.cRed),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorStyle: TextStyle(
                                              letterSpacing: 1.2,
                                              color: LightTheme.cRed,
                                              height: 0.4),
                                        ),
                                        validator: (input) {
                                          if (_tempStartTime
                                              .isAfter(_jobEndTime)) {
                                            return ('Please enter valid start time');
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                        readOnly: true,
                                        controller: _jobEndTimeController,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: LightTheme.cDarkBlue,
                                            fontWeight: FontWeight.w600),
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext builder) {
                                                return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .copyWith()
                                                                .size
                                                                .height /
                                                            3,
                                                    child: CupertinoDatePicker(
                                                      backgroundColor:
                                                          LightTheme
                                                              .cLightYellow2,
                                                      initialDateTime:
                                                          _jobEndTime,
                                                      onDateTimeChanged:
                                                          (DateTime newDate) {
                                                        _tempEndTime = newDate;
                                                        _jobEndTimeController
                                                                .text =
                                                            _dateFormatter
                                                                .format(
                                                                    newDate);
                                                        _jobEndTime = newDate;
                                                        if (_jobStatus <= 1) {
                                                          _jobStatus = 2;
                                                        }
                                                      },
                                                      use24hFormat: true,
                                                      maximumDate: DateTime(
                                                          2100, 12, 30),
                                                      minimumYear: 2000,
                                                      maximumYear: 2100,
                                                      minuteInterval: 1,
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .dateAndTime,
                                                    ));
                                              });
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Job End Time',
                                          labelStyle: TextStyle(
                                              letterSpacing: 1.2,
                                              fontSize: 18.0,
                                              color: LightTheme.cGreen),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cPalePink),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: LightTheme.cRed),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorStyle: TextStyle(
                                              letterSpacing: 1.2,
                                              color: LightTheme.cRed,
                                              height: 0.4),
                                        ),
                                        validator: (input) {
                                          if (_tempEndTime
                                              .isBefore(_jobStartTime)) {
                                            return ('please enter valid end time');
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        cursorColor: LightTheme.cDarkBlue,
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
                                                width: 3,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cGreen),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: LightTheme.cPalePink),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: LightTheme.cRed),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          errorStyle: TextStyle(
                                              letterSpacing: 1.2,
                                              color: LightTheme.cRed,
                                              height: 0.4),
                                        ),
                                        validator: (input) =>
                                            double.tryParse(input) == null
                                                ? 'Please enter a valid amount'
                                                : null,
                                        onSaved: (input) => _jobAddedCosts =
                                            double.parse(input),
                                        initialValue: widget.job.jobAddedCosts
                                            .toString()),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      cursorColor: LightTheme.cDarkBlue,
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
                                              width: 3,
                                              color: LightTheme.cGreen),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: LightTheme.cGreen),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: LightTheme.cPalePink),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: LightTheme.cRed),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        errorStyle: TextStyle(
                                            letterSpacing: 1.2,
                                            color: LightTheme.cRed,
                                            height: 0.4),
                                      ),
                                      onSaved: (input) => _jobNotes = input,
                                      initialValue: widget.job.jobNotes,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: LightTheme.cLightYellow,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(-2.0, -2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 17),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        elevation: 5,
                        visualDensity: VisualDensity.compact,
                        color: LightTheme.cRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Column(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
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
                            desc:
                                "Do I really want to delete ${widget.job.jobName}?",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                      RaisedButton(
                        elevation: 5,
                        visualDensity: VisualDensity.compact,
                        color: LightTheme.cBrownishGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                widget.job.isArchived == 0
                                    ? 'Archive'
                                    : 'Restore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.0,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          if (widget.job.isArchived == 0) {
                            _archive();
                          } else {
                            _restore();
                          }
                        },
                      ),
                      RaisedButton(
                        elevation: 5,
                        visualDensity: VisualDensity.compact,
                        color: LightTheme.cGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.0,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
