import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:sole_trader/models/quote_model.dart';
import 'package:sole_trader/screens/clients_list_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../database_helper.dart';
import 'add_client_screen.dart';
import 'quote_entries_screen.dart';

class QuotesScreen extends StatefulWidget {
  final int clientId;
  QuotesScreen({this.clientId});
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final DateFormat _dateFormatterDateOnly = DateFormat('dd MMM');
  String _clientNickname;
  List<Client> _clientList = [];
  List<String> _clientNamesList = [];
  Future<List<Quote>> _quoteList;
  int _clientId;
  int _quoteNumber;
  double _clientHourlyRate;
  TextEditingController _quoteDateController = TextEditingController();
  TextEditingController _validUntilController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd MMM, yyy');
  DateTime _quoteDate = DateTime.now();
  DateTime _validUntilDate = DateTime.now().add(Duration(days: 30));

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _quoteDateController.text = _dateFormatter.format(DateTime.now());
    _validUntilController.text =
        _dateFormatter.format(DateTime.now().add(Duration(days: 30)));
    _getClientList();
  }

  void dispose() {
    _quoteDateController.dispose();
    _validUntilController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  _getClientList() async {
    _clientList = await DatabaseHelper.instance.getClientList();
    _clientList.forEach((element) {
      _clientNamesList.add(element.clientNickname.toString());
    });

    setState(() {
      if (widget.clientId == null) {
        _clientNickname = _clientList[0].clientNickname;
        _clientId = _clientList[0].clientId;
        _clientHourlyRate = _clientList[0].clientHourlyRate;
        _updateQuoteList(_clientList[0].clientId);
      } else {
        for (Client client in _clientList) {
          if (widget.clientId == client.clientId) {
            _clientNickname = client.clientNickname;
            _clientId = client.clientId;
            _clientHourlyRate = client.clientHourlyRate;
            _clientHourlyRate = client.clientHourlyRate;
            _updateQuoteList(client.clientId);
          }
        }
      }
    });
  }

  _updateQuoteList(int clientId) {
    var quoteProvider = Provider.of<DataProvider>(context, listen: false);
    _quoteList = quoteProvider.getQuoteList(clientId);
  }

  Future<double> _calculateTotalEstimatedCost(Quote quote) async {
    List<QuoteEntry> _quoteEntryList;
    double _quoteEstimatedCost = 0;
    _quoteEntryList =
        await DatabaseHelper.instance.getQuoteEntryList(quote.quoteId);
    for (QuoteEntry quoteEntry in _quoteEntryList) {
      _quoteEstimatedCost =
          _quoteEstimatedCost + quoteEntry.calculateEstimatedCost(quoteEntry);
    }
    return _quoteEstimatedCost;
  }

  _buildQuoteForList(Quote quote) {
    Future<double> _totalEstimatedCost = _calculateTotalEstimatedCost(quote);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Quote date: ${_dateFormatterDateOnly.format(quote.date)}',
              style: TextStyle(
                fontSize: 15.0,
                color: LightTheme.cDarkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Valid until: ${_dateFormatterDateOnly.format(quote.validUntil)}',
              style: TextStyle(
                fontSize: 15.0,
                color: LightTheme.cDarkBlue,
              ),
            ),
            trailing: SizedBox(
              width: 70,
              //width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'estimate',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                  FutureBuilder(
                      future: _totalEstimatedCost,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Text(
                          '\$${snapshot.data}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                ],
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuoteEntriesScreen(
                  clientNickname: _clientNickname,
                  clientId: _clientId,
                  clientHourlyRate: _clientHourlyRate,
                  quoteId: quote.quoteId,
                  quoteNumber: quote.quoteNumber,
                  quoteDate: quote.date,
                  quoteValidUntil: quote.validUntil,
                  // updateJobsMap: _updateJobsCountMap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var quoteProvider = Provider.of<DataProvider>(context);
    _quoteList = quoteProvider.getQuoteList(_clientId);
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('QuotesScreen'),
        context: context,
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'Quotes',
                        style: TextStyle(
                          color: LightTheme.cDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Text(
                      'Client: $_clientNickname',
                      maxLines: 3,
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
            SizedBox(height: 2),
            Container(
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
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 25),
                  Container(
                    height: 80,
                    child: DropdownButtonFormField(
                      dropdownColor: LightTheme.cLightYellow2,
                      isExpanded: true,
                      isDense: true,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: LightTheme.cGreen,
                      ),
                      iconSize: 22.0,
                      iconEnabledColor: Theme.of(context).primaryColor,
                      items: _clientNamesList.map((String clientName) {
                        return DropdownMenuItem(
                          value: clientName,
                          child: Text(
                            clientName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: LightTheme.cDarkBlue,
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Poppins',
                          color: LightTheme.cDarkBlue),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Choose a client',
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
                      ),
                      onChanged: (value) {
                        setState(() {
                          _clientNickname = value;
                          for (Client client in _clientList) {
                            if (client.clientNickname == _clientNickname) {
                              _clientId = client.clientId;
                              _clientHourlyRate = client.clientHourlyRate;
                              _updateQuoteList(client.clientId);
                            }
                          }
                        });
                      },
                      value: _clientNickname,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                    future: _quoteList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                                color: LightTheme.cLightGreen,
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
                                    _buildQuoteForList(
                                        snapshot.data[index - 1]),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
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
                      color: LightTheme.cGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: Text(
                          'New Client',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientsListScreen(),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddClientScreen(),
                          ),
                        );
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
                        child: Text(
                          'Add Quote',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            context: context,
                            backgroundColor: LightTheme.cLightYellow2,
                            builder: (BuildContext builder) {
                              return StatefulBuilder(builder:
                                  (BuildContext context1,
                                      StateSetter setState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 30, 20, 0),
                                  child: Form(
                                    key: _formKey,
                                    autovalidate: _autoValidate,
                                    child: (Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _quoteDateController,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: LightTheme.cDarkBlue,
                                                fontWeight: FontWeight.w600),
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height /
                                                            3,
                                                        child:
                                                            CupertinoDatePicker(
                                                          backgroundColor:
                                                              LightTheme
                                                                  .cLightYellow2,
                                                          initialDateTime:
                                                              _quoteDate,
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newDate) {
                                                            _quoteDateController
                                                                    .text =
                                                                _dateFormatter
                                                                    .format(
                                                                        newDate);
                                                            _quoteDate =
                                                                newDate;
                                                          },
                                                          maximumDate: DateTime(
                                                              2100, 12, 30),
                                                          minimumYear: 2000,
                                                          maximumYear: 2100,
                                                          mode:
                                                              CupertinoDatePickerMode
                                                                  .date,
                                                        ));
                                                  });
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelText: 'Quote date',
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
                                                    color:
                                                        LightTheme.cPalePink),
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
                                              if (_quoteDate
                                                  .isAfter(_validUntilDate)) {
                                                return ('Please choose valid dates');
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: 80,
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _validUntilController,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: LightTheme.cDarkBlue,
                                                fontWeight: FontWeight.w600),
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height /
                                                            3,
                                                        child:
                                                            CupertinoDatePicker(
                                                          backgroundColor:
                                                              LightTheme
                                                                  .cLightYellow2,
                                                          initialDateTime:
                                                              _validUntilDate,
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newDate) {
                                                            _validUntilController
                                                                    .text =
                                                                _dateFormatter
                                                                    .format(
                                                                        newDate);
                                                            _validUntilDate =
                                                                newDate;
                                                          },
                                                          maximumDate: DateTime(
                                                              2100, 12, 30),
                                                          minimumYear: 2000,
                                                          maximumYear: 2100,
                                                          mode:
                                                              CupertinoDatePickerMode
                                                                  .date,
                                                        ));
                                                  });
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelText: 'Quote valid until',
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
                                                    color:
                                                        LightTheme.cPalePink),
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
                                              if (_validUntilDate
                                                  .isBefore(_quoteDate)) {
                                                return ('Please choose valid dates');
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            cursorColor: LightTheme.cDarkBlue,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: LightTheme.cDarkBlue,
                                                fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelText: 'Quote number',
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
                                                    color:
                                                        LightTheme.cPalePink),
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
                                            validator: (input) => int.tryParse(
                                                            input) ==
                                                        null ||
                                                    int.tryParse(input) == 0
                                                ? 'Please enter valid number'
                                                : null,
                                            onSaved: (input) =>
                                                _quoteNumber = int.parse(input),
                                            initialValue: 1.toString(),
                                          ),
                                        ),
                                        RaisedButton(
                                          elevation: 5,
                                          visualDensity: VisualDensity.compact,
                                          color: LightTheme.cGreen,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 8.0),
                                            child: Text(
                                              'Add Quote',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.1,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              var quotesProvider =
                                                  Provider.of<DataProvider>(
                                                      context,
                                                      listen: false);
                                              Quote newQuote = Quote(
                                                clientId: _clientId,
                                                date: _quoteDate,
                                                validUntil: _validUntilDate,
                                                quoteNumber: _quoteNumber,
                                              );

                                              quotesProvider.addQuote(newQuote);
                                              Navigator.pop(context1);
                                              Alert(
                                                style: AlertStyle(
                                                    alertBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    isCloseButton: false,
                                                    backgroundColor: LightTheme
                                                        .cLightYellow2,
                                                    overlayColor:
                                                        Colors.black54),
                                                context: context,
                                                title: "Adding Quote",
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Tap on newly created quote to add job entries',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    color: LightTheme.cGreen,
                                                    radius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ],
                                              ).show();
                                            } else {
                                              setState(
                                                  () => _autoValidate = true);
                                            }
                                          },
                                        ),
                                      ],
                                    )),
                                  ),
                                );
                              });
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
