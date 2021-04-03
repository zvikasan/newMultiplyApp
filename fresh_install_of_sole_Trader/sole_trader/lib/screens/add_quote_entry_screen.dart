import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:sole_trader/models/quote_model.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class AddQuoteEntryScreen extends StatefulWidget {
  final int quoteId;
  final String clientNickname;
  final double clientHourlyRate;
  final QuoteEntry quoteEntry;
  final int quoteNumber;

  const AddQuoteEntryScreen(
      {Key key,
      this.quoteId,
      this.clientNickname,
      this.quoteEntry,
      this.quoteNumber,
      this.clientHourlyRate})
      : super(key: key);

  @override
  _AddQuoteEntryScreenState createState() => _AddQuoteEntryScreenState();
}

class _AddQuoteEntryScreenState extends State<AddQuoteEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  QuoteEntry _quoteEntry;
  int _jobQuoteId;
  String _jobDescription;
  String _jobNotes;
  double _jobHourlyRate;
  double _jobEstimatedDuration;
  double _jobAddedCosts;

  @override
  void initState() {
    super.initState();
    if (widget.quoteEntry != null) {
      _quoteEntry = widget.quoteEntry;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  _submit() {
    var quoteProvider = Provider.of<DataProvider>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      QuoteEntry quoteEntry = QuoteEntry.withId(
        quoteId: widget.quoteId,
        description: _jobDescription,
        hourlyRate: _jobHourlyRate,
        estimatedDuration: _jobEstimatedDuration,
        addedCosts: _jobAddedCosts,
        notes: _jobNotes,
      );
      if (widget.quoteEntry == null) {
        quoteProvider.addQuoteEntry(quoteEntry);
      } else {
        quoteEntry.quoteEntryId = widget.quoteEntry.quoteEntryId;
        quoteProvider.updateQuoteEntry(quoteEntry);
      }
      Navigator.pop(context);
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('AddQuoteEntryScreen'),
        context: context,
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      floatingActionButton: widget.quoteEntry == null
          ? FloatingActionButton.extended(
              elevation: 5,
              backgroundColor: LightTheme.cGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              label: Text(
                'Add Job',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  fontSize: 18,
                  //fontWeight: FontWeight.w800,
                ),
              ),
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: _submit,
            )
          : null,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              widget.quoteEntry == null
                                  ? 'New Job'
                                  : 'Update Job',
                              style: TextStyle(
                                color: LightTheme.cDarkBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Text(
                            'Quote for ${widget.clientNickname}',
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
                    Container(
                      width: 90,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: LightTheme.cDarkBlue,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'No.',
                          labelStyle: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: 18.0,
                              color: LightTheme.cGreen),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: LightTheme.cGreen),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: LightTheme.cGreen),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: LightTheme.cPalePink),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: LightTheme.cRed),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          errorStyle: TextStyle(
                              letterSpacing: 1.2,
                              color: LightTheme.cRed,
                              height: 0.0),
                        ),
                        initialValue: widget.quoteNumber.toString(),
                        //initialValue: _quoteNumber.toString(),
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
                    children: [
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  labelText: 'Job description',
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
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cPalePink),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: LightTheme.cRed),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      color: LightTheme.cRed,
                                      height: 0.4),
                                ),
                                validator: (input) => input.trim().isEmpty
                                    ? 'Please enter a job description'
                                    : null,
                                onSaved: (input) => _jobDescription = input,
                                initialValue: widget.quoteEntry != null
                                    ? widget.quoteEntry.description
                                    : null,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: TextFormField(
                                cursorColor: LightTheme.cDarkBlue,
                                keyboardType: TextInputType.numberWithOptions(
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
                                        width: 3, color: LightTheme.cGreen),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cGreen),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cPalePink),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: LightTheme.cRed),
                                    borderRadius: BorderRadius.circular(20.0),
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
                                initialValue: widget.quoteEntry != null
                                    ? widget.quoteEntry.hourlyRate.toString()
                                    : widget.clientHourlyRate.toString(),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: TextFormField(
                                cursorColor: LightTheme.cDarkBlue,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: LightTheme.cDarkBlue,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  suffix: Text(
                                    'hours',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: LightTheme.cDarkBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  isDense: true,
                                  labelText: 'Estimated job duration',
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
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cPalePink),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: LightTheme.cRed),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      color: LightTheme.cRed,
                                      height: 0.4),
                                ),
                                validator: (input) =>
                                    double.tryParse(input) == null
                                        ? 'Please enter valid estimation'
                                        : null,
                                onSaved: (input) =>
                                    _jobEstimatedDuration = double.parse(input),
                                initialValue: widget.quoteEntry != null
                                    ? widget.quoteEntry.estimatedDuration
                                        .toString()
                                    : '0',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: TextFormField(
                                cursorColor: LightTheme.cDarkBlue,
                                keyboardType: TextInputType.numberWithOptions(
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
                                  labelText: 'Added costs',
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
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cPalePink),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: LightTheme.cRed),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      color: LightTheme.cRed,
                                      height: 0.4),
                                ),
                                validator: (input) =>
                                    double.tryParse(input) == null
                                        ? 'Please enter valid amount'
                                        : null,
                                onSaved: (input) =>
                                    _jobAddedCosts = double.parse(input),
                                initialValue: widget.quoteEntry != null
                                    ? widget.quoteEntry.addedCosts.toString()
                                    : '0',
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
                                  labelText: 'Job notes',
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
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: LightTheme.cPalePink),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: LightTheme.cRed),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      color: LightTheme.cRed,
                                      height: 0.4),
                                ),
                                onSaved: (input) => _jobNotes = input,
                                initialValue: widget.quoteEntry != null
                                    ? widget.quoteEntry.notes
                                    : null,
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            widget.quoteEntry != null
                ? Container(
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
                          offset: Offset(
                              -2.0, -2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 17),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
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
                                title: "Deleting Entry",
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        'Do I really want to delete this job entry?'),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      var quoteProvider =
                                          Provider.of<DataProvider>(context,
                                              listen: false);
                                      quoteProvider
                                          .deleteQuoteEntry(widget.quoteEntry);
                                      Navigator.pop(context);
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
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
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
