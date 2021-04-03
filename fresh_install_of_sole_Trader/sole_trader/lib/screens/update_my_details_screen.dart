import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/my_details_model.dart';
import 'package:flutter/services.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class UpdateMyDetailsScreen extends StatefulWidget {
  final MyDetails myDetails;
  UpdateMyDetailsScreen({this.myDetails});

  @override
  _UpdateMyDetailsScreenState createState() => _UpdateMyDetailsScreenState();
}

class _UpdateMyDetailsScreenState extends State<UpdateMyDetailsScreen> {
  final _formKey = GlobalKey<FormState>(); //key to validate user's input
  bool _autoValidate = false;

  String _myBillingName;
  String _myBillingAddress;
  String _myPaymentDetails;
  String _myAdditionalInfo;
  int _myExpectedPaymentPeriod;
  int _noGstMessageRequired;
  String _myMobile;
  String _myEmail;
  double _myTaxRate;
  int _nextInvoiceNumber;

  @override
  void initState() {
    super.initState();
    _myBillingName = widget.myDetails.myBillingName;
    _myBillingAddress = widget.myDetails.myBillingAddress;
    _myPaymentDetails = widget.myDetails.myPaymentDetails;
    _myAdditionalInfo = widget.myDetails.myAdditionalInfo;
    _myExpectedPaymentPeriod = widget.myDetails.myExpectedPaymentPeriod;
    _noGstMessageRequired = widget.myDetails.gstRequired;
    _myMobile = widget.myDetails.myMobile;
    _myEmail = widget.myDetails.myEmail;
    _myTaxRate = widget.myDetails.myTaxRate;
    _nextInvoiceNumber = widget.myDetails.nextInvoiceNumber;
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      MyDetails myDetails = MyDetails(
        myBillingName: _myBillingName,
        myBillingAddress: _myBillingAddress,
        myPaymentDetails: _myPaymentDetails,
        myAdditionalInfo: _myAdditionalInfo,
        myExpectedPaymentPeriod: _myExpectedPaymentPeriod,
        gstRequired: _noGstMessageRequired,
        myMobile: _myMobile,
        myEmail: _myEmail,
        myTaxRate: _myTaxRate,
        nextInvoiceNumber: _nextInvoiceNumber,
      );
      var updateDetails = Provider.of<DataProvider>(context, listen: false);
      updateDetails.updateMyDetails(myDetails);
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
        context: context,
        key: Key('UpdateMyDetailsScreen'),
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
          'Update my details',
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
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          'Edit my details',
                          style: TextStyle(
                            color: LightTheme.cDarkBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 30.0,
                          ),
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
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  maxLines: 3,
                                  minLines: 1,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Trading Name',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                      ? 'Please enter your billing name'
                                      : null,
                                  onSaved: (input) => _myBillingName = input,
                                  initialValue: _myBillingName,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 4,
                                  minLines: 1,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Address',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                      ? 'Please enter your billing address'
                                      : null,
                                  onSaved: (input) => _myBillingAddress = input,
                                  initialValue: _myBillingAddress,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  maxLines: 3,
                                  minLines: 1,
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Email',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                      ? 'Please enter your email number'
                                      : null,
                                  onSaved: (input) => _myEmail = input,
                                  initialValue: _myEmail,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  maxLines: 3,
                                  minLines: 1,
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Mobile',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                      ? 'Please enter your mobile number'
                                      : null,
                                  onSaved: (input) => _myMobile = input,
                                  initialValue: _myMobile,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 3,
                                  minLines: 1,
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Payment details',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                      ? 'Please enter your payment details'
                                      : null,
                                  onSaved: (input) => _myPaymentDetails = input,
                                  initialValue: _myPaymentDetails,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  textInputAction: TextInputAction.newline,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorColor: LightTheme.cDarkBlue,
                                  maxLines: 5,
                                  minLines: 2,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText:
                                        'Other info to put on your invoices such as your ABN or EIN',
                                    hintStyle: TextStyle(fontSize: 15),
                                    labelText: 'Additional info',
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
                                  onSaved: (input) => _myAdditionalInfo = input,
                                  initialValue: _myAdditionalInfo,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    suffix: Text('days'),
                                    isDense: true,
                                    labelText: 'Expected payment period',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                  validator: (input) => int.tryParse(input) ==
                                          null
                                      ? 'Please enter valid expected payment period in days'
                                      : null,
                                  onSaved: (input) => _myExpectedPaymentPeriod =
                                      int.parse(input),
                                  initialValue:
                                      _myExpectedPaymentPeriod.toString(),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  cursorColor: LightTheme.cDarkBlue,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: LightTheme.cDarkBlue,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    suffix: Text('%'),
                                    isDense: true,
                                    labelText: 'Tax rate',
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
                                          width: 2,
                                          color: LightTheme.cPalePink),
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
                                  validator: (input) {
                                    if (double.tryParse(input) == null) {
                                      return ('Please enter valid tax rate');
                                    } else if (double.tryParse(input) > 0 &&
                                        _noGstMessageRequired == 1) {
                                      return ('Please uncheck \'GST Not Required\' first');
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (input) =>
                                      _myTaxRate = double.parse(input),
                                  initialValue: _myTaxRate == null
                                      ? '10'
                                      : _myTaxRate.toString(),
                                  onChanged: (input) =>
                                      _myTaxRate = double.parse(input),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        cursorColor: LightTheme.cDarkBlue,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: LightTheme.cDarkBlue,
                                            fontWeight: FontWeight.w600),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Next invoice number',
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
                                            int.tryParse(input) == null
                                                ? 'Please enter valid number'
                                                : null,
                                        onSaved: (input) => _nextInvoiceNumber =
                                            int.parse(input),
                                        initialValue:
                                            _nextInvoiceNumber.toString(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.help_outline,
                                      color: LightTheme.cGreen,
                                      size: 40,
                                    ),
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
                                        title: "Invoice numbering",
                                        desc:
                                            "Each time you generate an invoice, this number will increment. You can set the starting number here.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Got it",
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
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      onChanged: (value) {
                                        if (value == true && _myTaxRate > 1) {
                                          Alert(
                                            style: AlertStyle(
                                                alertBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                isCloseButton: false,
                                                backgroundColor:
                                                    LightTheme.cLightYellow2,
                                                overlayColor: Colors.black54),
                                            context: context,
                                            title: "For Australia",
                                            desc:
                                                "Please set your Tax rate to zero first",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Got it",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                color: LightTheme.cGreen,
                                                radius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ],
                                          ).show();
                                        } else {
                                          setState(() {
                                            _noGstMessageRequired =
                                                value ? 1 : 0;
                                          });
                                        }
                                      },
                                      activeColor: LightTheme.cGreen,
                                      checkColor: Colors.white,
                                      value: _noGstMessageRequired == 1
                                          ? true
                                          : false,
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: LightTheme.cDarkBlue,
                                                fontWeight: FontWeight.w600),
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Add \'GST Not required\' message to invoices and quotes.  ',
                                              ),
                                              TextSpan(
                                                  text: 'What is this?',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Alert(
                                                            style: AlertStyle(
                                                                alertBorder:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                ),
                                                                isCloseButton:
                                                                    false,
                                                                backgroundColor:
                                                                    LightTheme
                                                                        .cLightYellow2,
                                                                overlayColor:
                                                                    Colors
                                                                        .black54),
                                                            context: context,
                                                            title:
                                                                "For Australia",
                                                            desc:
                                                                "If checked, adds message to the invoice that you are not required to register for GST",
                                                            buttons: [
                                                              DialogButton(
                                                                child: Text(
                                                                  "Got it",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                color:
                                                                    LightTheme
                                                                        .cGreen,
                                                                radius: BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                              ),
                                                            ],
                                                          ).show();
                                                        },
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color:
                                                          LightTheme.cGreen)),
                                            ]),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Text(
                                    //     'Add \'GST Not required\' message to invoices',
                                    //     style: TextStyle(
                                    //         fontSize: 18.0,
                                    //         color: LightTheme.cDarkBlue,
                                    //         fontWeight: FontWeight.w600),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 70),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
