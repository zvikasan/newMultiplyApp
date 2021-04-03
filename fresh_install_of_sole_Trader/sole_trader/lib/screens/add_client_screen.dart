import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/screens/clients_list_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

import 'options_screen.dart';

class AddClientScreen extends StatefulWidget {
  final Client client;
  final bool comingFromJobs;
  final bool showArchived;
  AddClientScreen({this.client, this.comingFromJobs, this.showArchived});

  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _clientNickname = '';
  String _clientBillingName = '';
  String _clientAddress = '';
  double _clientHourlyRate;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _clientNickname = widget.client.clientNickname;
      _clientBillingName = widget.client.clientBillingName;
      _clientAddress = widget.client.clientAddress;
      _clientHourlyRate = widget.client.clientHourlyRate;
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Client client = Client(
          clientNickname: _clientNickname,
          clientBillingName: _clientBillingName,
          clientAddress: _clientAddress,
          clientHourlyRate: _clientHourlyRate);
      if (widget.client == null) {
        client.isArchived = 0;
        var clientsProvider = Provider.of<DataProvider>(context, listen: false);
        clientsProvider.addClient(client);
      } else {
        client.isArchived = widget.client.isArchived;
        client.clientId = widget.client.clientId;
        var clientsProvider = Provider.of<DataProvider>(context, listen: false);
        clientsProvider.updateClient(client);
      }
      Navigator.pop(context);
    } else {
      setState(() => _autoValidate = true);
    }
  }

  _archive() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Client client = Client(
          clientNickname: _clientNickname,
          clientBillingName: _clientBillingName,
          clientAddress: _clientAddress,
          clientHourlyRate: _clientHourlyRate,
          isArchived: 1);

      client.clientId = widget.client.clientId;
      var clientsProvider = Provider.of<DataProvider>(context, listen: false);
      clientsProvider.updateClient(client);
      clientsProvider.archiveAllJobsForClient(client.clientId);
      // Navigator.pop(context);
      // if (widget.comingFromJobs == true) {
      //   Navigator.pop(context);
      // }
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ClientsListScreen(),
        ),
      );
    }
  }

  _restore() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Client client = Client(
          clientNickname: _clientNickname,
          clientBillingName: _clientBillingName,
          clientAddress: _clientAddress,
          clientHourlyRate: _clientHourlyRate,
          isArchived: 0);

      client.clientId = widget.client.clientId;
      var clientsProvider = Provider.of<DataProvider>(context, listen: false);
      clientsProvider.updateClient(client);
      clientsProvider.restoreAllJobsForClient(client.clientId);
      Navigator.pop(context);
      if (widget.comingFromJobs == true) {
        Navigator.pop(context);
      }
    }
  }

  _delete() async {
    var clientsProvider = Provider.of<DataProvider>(context, listen: false);
    await clientsProvider.deleteAllQuotesForClient(widget.client.clientId);
    await clientsProvider.deleteClient(widget.client.clientId);

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ClientsListScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: ThemeBottomNavigationBar(
          key: Key('AddClientScreen'),
          context: context,
        ),
        backgroundColor: LightTheme.cLightYellow,
        appBar: ThemeAppBar(
          appBar: AppBar(),
          context: context,
        ),
        floatingActionButton: widget.client == null
            ? FloatingActionButton.extended(
                elevation: 5,
                backgroundColor: LightTheme.cGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                label: Text(
                  'Add Client',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    fontSize: 18,
                    //fontWeight: FontWeight.w800,
                  ),
                ),
                icon: widget.client == null
                    ? Icon(
                        Icons.add,
                        size: 30,
                      )
                    : null,
                onPressed: _submit,
              )
            : null,
        body: GestureDetector(
            onTap: () => FocusScope.of(context)
                .unfocus(), //auto hide for on-screen keyboard
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            widget.client == null
                                ? 'Add new client'
                                : 'Update client details',
                            style: TextStyle(
                              color: LightTheme.cDarkBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        widget.showArchived == true
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  'Client ${widget.client.clientNickname} is archived',
                                  style: TextStyle(
                                    color: LightTheme.cBrownishGrey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
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
                                        hintText:
                                            'Short name to be used within the app',
                                        hintStyle: TextStyle(fontSize: 12),
                                        labelText: 'Client\'s name',
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
                                          ? 'Please enter client\'s name'
                                          : null,
                                      onSaved: (input) =>
                                          _clientNickname = input,
                                      initialValue: _clientNickname,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                      maxLines: 4,
                                      minLines: 3,
                                      textInputAction: TextInputAction.newline,
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
                                            'Client\'s billing name will appear on the invoice',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                        labelText:
                                            'Client\'s full billing name',
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
                                          ? 'Please enter Client\'s billing name'
                                          : null,
                                      onSaved: (input) =>
                                          _clientBillingName = input,
                                      initialValue: _clientBillingName,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
                                      maxLines: 4,
                                      minLines: 3,
                                      textInputAction: TextInputAction.newline,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      cursorColor: LightTheme.cDarkBlue,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: LightTheme.cDarkBlue,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Client\'s address',
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
                                      onSaved: (input) =>
                                          _clientAddress = input,
                                      initialValue: _clientAddress,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextFormField(
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
                                        hintText:
                                            'Can be changed later per job',
                                        hintStyle: TextStyle(fontSize: 12),
                                        labelText:
                                            'Hourly rate to charge this client',
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
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (input) =>
                                          double.tryParse(input) == null
                                              ? 'Please enter valid hourly rate'
                                              : null,
                                      onSaved: (input) => _clientHourlyRate =
                                          double.parse(input),
                                      initialValue: _clientHourlyRate != null
                                          ? _clientHourlyRate.toString()
                                          : '',
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                widget.client != null
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 0),
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        isCloseButton: false,
                                        backgroundColor:
                                            LightTheme.cLightYellow2,
                                        overlayColor: Colors.black54),
                                    context: context,
                                    title: "Deleting a Client",
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            'Do I really want to delete ${widget.client.clientNickname}?'),
                                        Text(
                                          'All clients\' jobs will be deleted as well.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
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
                                        widget.client.isArchived == 0 ||
                                                widget.client.isArchived == null
                                            ? 'Archive'
                                            : 'Restore',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  if (widget.client.isArchived == 0 ||
                                      widget.client.isArchived == null) {
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
                      )
                    : SizedBox.shrink(),
              ],
            )));
  }
}
