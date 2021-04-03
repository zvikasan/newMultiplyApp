import 'package:flutter/material.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/job_model.dart';
import 'package:flutter/services.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class AddJobScreen extends StatefulWidget {
  final int clientId;
  final String clientName;
  final double clientHourlyRate;

  AddJobScreen({
    this.clientId,
    this.clientHourlyRate,
    this.clientName,
  });

  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _jobName = '';
  String _jobDescription = '';
  String _jobNotes = '';
  double _jobHourlyRate;
  int _jobStatus = 0;
  double _jobAddedCosts = 0;
  int _isArchived = 0;

  Future<Client> client;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Job job = Job(
        clientId: widget.clientId,
        jobName: _jobName,
        jobDescription: _jobDescription,
        jobHourlyRate: _jobHourlyRate,
        jobStatus: _jobStatus,
        jobAddedCosts: _jobAddedCosts,
        jobNotes: _jobNotes,
        isArchived: _isArchived,
      );
      var jobsProvider = Provider.of<DataProvider>(context, listen: false);
      jobsProvider.addJob(job);
      Navigator.pop(context);
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var jobsListProvider = Provider.of<DataProvider>(context);
    client = jobsListProvider.getClient(widget.clientId);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('AddJobScreen'),
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
        label: Text(
          'Add Job',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: _submit,
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'New Job',
                        style: TextStyle(
                          color: LightTheme.cDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 30.0,
                        ),
                      ),
                      Text(
                        'Client: ${widget.clientName}',
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                  height: 80,
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
                                      hintText:
                                          'Short name to be used within the app',
                                      hintStyle: TextStyle(fontSize: 15),
                                      labelText: 'Job Name',
                                      labelStyle: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 18.0,
                                          color: LightTheme.cGreen),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: LightTheme.cGreen),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: LightTheme.cGreen),
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
                                    // initialValue: 'Job 1',
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Container(
                                    height: 100,
                                    child: TextFormField(
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
                                        hintText: 'Will appear on the invoice',
                                        hintStyle: TextStyle(fontSize: 15),
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
                                      // initialValue: 'Very hard work',
                                    ),
                                  ),
                                ),
                                //SizedBox(height: 20),
                                Container(
                                  height: 80,
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
                                      validator: (input) =>
                                          double.tryParse(input) == null
                                              ? 'Please enter valid hourly rate'
                                              : null,
                                      onSaved: (input) =>
                                          _jobHourlyRate = double.parse(input),
                                      initialValue:
                                          widget.clientHourlyRate.toString()),
                                ),
                                Container(
                                  height: 80,
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
                                      validator: (input) =>
                                          double.tryParse(input) == null
                                              ? 'Please enter a valid amount'
                                              : null,
                                      onSaved: (input) =>
                                          _jobAddedCosts = double.parse(input),
                                      initialValue: '0'),
                                ),
                                Container(
                                  height: 80,
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    cursorColor: LightTheme.cDarkBlue,
                                    maxLines: 3,
                                    minLines: 1,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: LightTheme.cDarkBlue,
                                        fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Will appear on the invoice',
                                      hintStyle: TextStyle(fontSize: 15),
                                      labelText: 'Job Notes',
                                      labelStyle: TextStyle(
                                          letterSpacing: 1.2,
                                          fontSize: 18.0,
                                          color: LightTheme.cGreen),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: LightTheme.cGreen),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: LightTheme.cGreen),
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
                                    initialValue: '',
                                  ),
                                ),
                                Container(height: 55),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
