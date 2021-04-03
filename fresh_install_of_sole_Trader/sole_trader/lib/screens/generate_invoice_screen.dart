import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/database_helper.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/job_model.dart';
import 'package:sole_trader/models/my_details_model.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sole_trader/models/invoice_model.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class GenerateInvoiceScreen extends StatefulWidget {
  final Client client;
  final int clientId;
  GenerateInvoiceScreen({this.client, this.clientId});
  @override
  _GenerateInvoiceScreenState createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {
  pw.Document invoiceToPrint = pw.Document();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _includeClientAddress = true;

  PdfImage _logo;
  static const _baseColor = PdfColors.blue800;
  static const _accentColor = PdfColors.black;
  static const _darkColor = PdfColors.blueGrey;
  static const _lightColor = PdfColors.white;
  PdfColor get _baseTextColor =>
      _baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('dd MMM, yyy');
  final DateFormat _dateFormatterInvoiceDate = DateFormat('dd MMM, yyy');
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  List<Client> _clientList = [];
  List<String> _clientNamesList = [];
  Client _client;
  String _clientName;
  List<Job> _jobList;
  List<JobInvoice> formattedJobsList;
  MyDetails _myDetails = MyDetails();

  bool _taxInvoice = false;
  String gstText;

  bool _withAddedCosts = false;
  bool _withJobNotes = false;

  double col0, col1, col2, col3, col4, col5, col6;
  pw.Alignment cell4, cell5, cell6;
  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fromDateController.text = _dateFormatter.format(DateTime.now());
    _toDateController.text = _dateFormatter.format(DateTime.now());
    _getClientList();
  }

  _getClientList() async {
    _clientList = await DatabaseHelper.instance.getClientList();
    _clientList.forEach((element) {
      _clientNamesList.add(element.clientNickname.toString());
    });
    setState(() {
      if (widget.client == null && widget.clientId == null) {
        _client = _clientList[0];
        _clientName = _client.clientNickname;
        _updateJobList(_client);
      } else if (widget.client == null && widget.clientId != null) {
        for (Client client in _clientList) {
          if (widget.clientId == client.clientId) {
            _client = client;
            _clientName = client.clientNickname;
          }
        }
        _updateJobList(_client);
      } else {
        _client = widget.client;
        _clientName = _client.clientNickname;
        _updateJobList(_client);
      }
    });
  }

  _updateJobList(Client client) async {
    _myDetails = await DatabaseHelper.instance.getMyDetails();
    _jobList = await DatabaseHelper.instance
        .getJobRangeListFinishedJobsOnly(client.clientId, _fromDate, _toDate);
    Invoice invoiceData = Invoice(
      jobs: _jobList,
    );
    formattedJobsList = invoiceData.formattedJobsList();
    if (_myDetails.gstRequired == 0) {
      gstText = '';
    } else {
      gstText =
          '${_myDetails.myBillingName} is not required to register for GST';
    }
    setState(() {
      for (Job job in _jobList) {
        if (job.jobAddedCosts > 0.1) {
          _withAddedCosts = true;
        }
        if (job.jobNotes != null && job.jobNotes != '') {
          _withJobNotes = true;
        }
      }

      if (_withAddedCosts == true && _withJobNotes == true) {
        col0 = 9;
        col1 = 26;
        col2 = 10;
        col3 = 10;
        col4 = 10;
        col5 = 25;
        col6 = 10;
        cell4 = pw.Alignment.center;
        cell5 = pw.Alignment.centerLeft;
        cell6 = pw.Alignment.centerRight;
      } else if (_withAddedCosts == false && _withJobNotes == false) {
        col0 = 15;
        col1 = 40;
        col2 = 15;
        col3 = 15;
        col4 = 15;
        col5 = 0;
        col6 = 0;
        cell4 = pw.Alignment.centerRight;
        cell5 = pw.Alignment.centerLeft;
        cell6 = pw.Alignment.centerRight;
      } else if (_withAddedCosts == true && _withJobNotes == false) {
        col0 = 15;
        col1 = 26;
        col2 = 15;
        col3 = 14;
        col4 = 15;
        col5 = 15;
        col6 = 0;
        cell4 = pw.Alignment.center;
        cell5 = pw.Alignment.centerRight;
        cell6 = pw.Alignment.centerRight;
      } else if (_withAddedCosts == false && _withJobNotes == true) {
        col0 = 15;
        col1 = 30;
        col2 = 10;
        col3 = 10;
        col4 = 25;
        col5 = 10;
        col6 = 0;
        cell4 = pw.Alignment.centerLeft;
        cell5 = pw.Alignment.centerRight;
        cell6 = pw.Alignment.centerRight;
      }
    });
  }

  double _calculateSubTotal() {
    double subtotal = 0;
    String subtotalString;
    formattedJobsList.forEach((element) {
      subtotal = subtotal + element.totalCharge;
    });
    subtotalString = subtotal.toStringAsFixed(2);
    subtotal = double.parse(subtotalString);
    return subtotal;
  }

  double _calculateTotal() {
    double total = 0;
    double subtotal = 0;
    String totalString;
    subtotal = _calculateSubTotal();
    if (_myDetails.gstRequired == 0) {
      total = subtotal * (1 + (_myDetails.myTaxRate / 100));
    } else {
      total = subtotal;
    }
    totalString = total.toStringAsFixed(2);
    total = double.parse(totalString);
    return total;
  }

  double _taxRate() {
    double taxRate = 0;
    if (_myDetails.gstRequired == 0) {
      taxRate = _myDetails.myTaxRate;
    } else {
      taxRate = 0;
    }
    return taxRate;
  } // if GST not required then outputs 0

  String _gstNotRequiredText() {
    String gstNotRequired;
    if (_myDetails.gstRequired == 1) {
      gstNotRequired =
          '* ${_myDetails.myBillingName} is not required to register for GST';
    } else {
      gstNotRequired = '';
    }
    return gstNotRequired;
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      _taxInvoice ? 'TAX INVOICE' : 'INVOICE',
                      style: pw.TextStyle(
                        color: _baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  pw.Container(
                      decoration: pw.BoxDecoration(
                        borderRadius: 10,
                        color: PdfColors.blueGrey,
                      ),
                      padding: const pw.EdgeInsets.only(
                          left: 40, top: 10, bottom: 10, right: 20),
                      alignment: pw.Alignment.centerLeft,
                      height: 50,
                      child: pw.DefaultTextStyle(
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                        child: pw.GridView(
                          crossAxisCount: 2,
                          children: [
                            pw.Text('Invoice #'),
                            pw.Text(_myDetails.nextInvoiceNumber.toString()),
                            pw.Text('Date:'),
                            pw.Text(
                                '${_dateFormatterInvoiceDate.format(DateTime.now())}'),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    // child: _logo != null ? pw.Image(_logo) : pw.PdfLogo(),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              bottom: 0,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [
                      _baseColor,
                      PdfColors.white,
                      PdfColors.white,
                      _baseColor
                    ],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              top: pageFormat.marginTop + 72,
              left: 0,
              right: 0,
              child: pw.Container(
                height: 3,
                color: _baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            // height: 70,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.SizedBox(height: 10),
                pw.Text(
                  '${_myDetails.myBillingName}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: _baseColor,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    text: _myDetails.myBillingAddress,
                    style: pw.TextStyle(
                      color: _baseColor,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
                pw.Divider(
                  color: PdfColors.white,
                  thickness: 1,
                ),
                pw.Text(
                  'Mobile: ${_myDetails.myMobile}',
                  style: pw.TextStyle(
                    color: _baseColor,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.Text(
                  'Email: ${_myDetails.myEmail}',
                  style: pw.TextStyle(
                    color: _baseColor,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.Divider(thickness: 0.5, color: _baseColor),
                pw.Text(
                  '${_myDetails.myAdditionalInfo}',
                  style: pw.TextStyle(
                    color: _baseColor,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.SizedBox(height: 5),
              ],
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: _client.clientBillingName,
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                        const pw.TextSpan(
                          text: '\n\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        _includeClientAddress == true
                            ? pw.TextSpan(
                                text: _client.clientAddress,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                ),
                              )
                            : pw.TextSpan(),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Please pay within ${_myDetails.myExpectedPaymentPeriod} business days',
                style: pw.TextStyle(
                  color: _darkColor,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.SizedBox(height: 10),
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: _baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                _myDetails.myPaymentDetails,
                style: const pw.TextStyle(
                  fontSize: 13,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                '${_gstNotRequiredText()}',
                style: const pw.TextStyle(
                  fontSize: 13,
                  lineSpacing: 5,
                  color: _baseColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(' \$${_calculateSubTotal()}'),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${_taxRate()}%'),
                  ],
                ),
                pw.Divider(color: _accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: _baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: _baseColor,
                              fontSize: 20)),
                      pw.Text(' \$${_calculateTotal()}',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: _baseColor,
                              fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    List tableHeaders;
    if (_withJobNotes == false && _withAddedCosts == false) {
      tableHeaders = [
        'Date',
        'Job Description ',
        'Duration',
        'Rate',
        'Amount',
      ];
    } else if (_withJobNotes == false && _withAddedCosts == true) {
      tableHeaders = [
        'Date',
        'Job Description ',
        'Duration',
        'Rate',
        'Added Costs',
        'Amount',
      ];
    } else if (_withJobNotes == true && _withAddedCosts == false) {
      tableHeaders = [
        'Date',
        'Job Description ',
        'Duration',
        'Rate',
        'Notes',
        'Amount',
      ];
    } else {
      tableHeaders = [
        'Date',
        'Job Description ',
        'Duration',
        'Rate',
        'Added Costs',
        'Notes',
        'Amount',
      ];
    }

    return pw.Table.fromTextArray(
      headerPadding: pw.EdgeInsets.fromLTRB(0, 10, 10, 10),
      border: null,
      // cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 2,
        color: _baseColor,
      ),
      headerHeight: 40,
      // headerAlignment: pw.Alignment.topRight,

      // cellHeight: 0,
      cellPadding: pw.EdgeInsets.fromLTRB(5, 10, 5, 10),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: cell4,
        5: cell5,
        6: cell6,
      },
      columnWidths: {
        0: pw.FlexColumnWidth(col0),
        1: pw.FlexColumnWidth(col1),
        2: pw.FlexColumnWidth(col2),
        3: pw.FlexColumnWidth(col3),
        4: pw.FlexColumnWidth(col4),
        5: pw.FlexColumnWidth(col5),
        6: pw.FlexColumnWidth(col6),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 9,
      ),
      // rowDecoration: pw.BoxDecoration(
      //   border: pw.BoxBorder(
      //     bottom: true,
      //     color: _accentColor,
      //     width: .5,
      //   ),
      // ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        formattedJobsList.length,
        (row) => List<String>.generate(
          tableHeaders
              .length, //the next logic eliminates unused columns when job notes or added costs are not used
          (col) {
            if (_withAddedCosts == true && _withJobNotes == true) {
              return formattedJobsList[row].getIndex(col);
            } else if (_withAddedCosts == false && _withJobNotes == false) {
              return formattedJobsList[row].getIndex(col <= 3 ? col : col + 2);
            } else if (_withAddedCosts == true && _withJobNotes == false) {
              return formattedJobsList[row].getIndex(col <= 4 ? col : col + 1);
            } else {
              return formattedJobsList[row].getIndex(col <= 3 ? col : col + 1);
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List> generatePdfInvoice() async {
    final pdfInvoice = pw.Document();

    final font1 = await rootBundle.load('assets/fonts/roboto1.ttf');
    final font2 = await rootBundle.load('assets/fonts/roboto2.ttf');
    final font3 = await rootBundle.load('assets/fonts/roboto3.ttf');

    pdfInvoice.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.a4,
          font1 != null ? pw.Font.ttf(font1) : null,
          font2 != null ? pw.Font.ttf(font2) : null,
          font3 != null ? pw.Font.ttf(font3) : null,
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );

    invoiceToPrint = pdfInvoice;
    return pdfInvoice.save();
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/pdfInvoice.pdf");
    file.writeAsBytes(await generatePdfInvoice());
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('GenerateInvoiceScreen'),
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
          'Generate Invoice',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            await savePdf();
            Directory documentDirectory =
                await getApplicationDocumentsDirectory();
            String documentPath = documentDirectory.path;
            String fullPath = '$documentPath/pdfInvoice.pdf';
            _myDetails.nextInvoiceNumber = _myDetails.nextInvoiceNumber + 1;
            await DatabaseHelper.instance.updateMyDetails(_myDetails);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfPreviewScreen(
                  path: fullPath,
                  pdf: invoiceToPrint,
                  isInvoice: true,
                ),
              ),
            );
          } else {
            setState(() => _autoValidate = true);
          }
        },
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
                        'Generate Invoice',
                        style: TextStyle(
                          color: LightTheme.cDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Text(
                      'Client: $_clientName',
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
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
                                iconEnabledColor:
                                    Theme.of(context).primaryColor,
                                items:
                                    _clientNamesList.map((String clientName) {
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
                                validator: (input) => _clientName == null
                                    ? 'Please select a client'
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    _clientName = value;
                                    _clientList.forEach((element) {
                                      if (element.clientNickname ==
                                          _clientName) {
                                        _client = element;
                                      }
                                      _updateJobList(_client);
                                    });
                                  });
                                },
                                value: _clientName,
                              ),
                            ),
                            Container(
                              height: 80,
                              child: TextFormField(
                                readOnly: true,
                                controller: _fromDateController,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: LightTheme.cDarkBlue,
                                    fontWeight: FontWeight.w600),
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height /
                                                3,
                                            child: CupertinoDatePicker(
                                              backgroundColor:
                                                  LightTheme.cLightYellow2,
                                              initialDateTime: _fromDate,
                                              onDateTimeChanged:
                                                  (DateTime newDate) {
                                                _fromDateController.text =
                                                    _dateFormatter
                                                        .format(newDate);
                                                _fromDate = newDate;
                                                _updateJobList(_client);
                                              },
                                              maximumDate:
                                                  DateTime(2100, 12, 30),
                                              minimumYear: 2000,
                                              maximumYear: 2100,
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ));
                                      });
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'From date',
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
                                validator: (input) {
                                  if (_fromDate.isAfter(_toDate)) {
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
                                controller: _toDateController,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: LightTheme.cDarkBlue,
                                    fontWeight: FontWeight.w600),
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height /
                                                3,
                                            child: CupertinoDatePicker(
                                              backgroundColor:
                                                  LightTheme.cLightYellow2,
                                              initialDateTime: _toDate,
                                              onDateTimeChanged:
                                                  (DateTime newDate) {
                                                _toDateController.text =
                                                    _dateFormatter
                                                        .format(newDate);
                                                _toDate = newDate;
                                                _updateJobList(_client);
                                              },
                                              maximumDate:
                                                  DateTime(2100, 12, 30),
                                              minimumYear: 2000,
                                              maximumYear: 2100,
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ));
                                      });
                                },
                                validator: (input) {
                                  if (_fromDate.isAfter(_toDate)) {
                                    return ('Please choose valid dates');
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'To Date',
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
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taxInvoice = !_taxInvoice;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    onChanged: (value) {
                                      setState(() {
                                        _taxInvoice = value;
                                      });
                                    },
                                    visualDensity: VisualDensity.compact,
                                    activeColor: LightTheme.cGreen,
                                    checkColor: Colors.white,
                                    value: _taxInvoice,
                                  ),
                                  Text(
                                    'Tax Invoice',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: LightTheme.cDarkBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _includeClientAddress =
                                      !_includeClientAddress;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    onChanged: (value) {
                                      setState(() {
                                        _includeClientAddress = value;
                                      });
                                    },
                                    visualDensity: VisualDensity.compact,
                                    activeColor: LightTheme.cGreen,
                                    checkColor: Colors.white,
                                    value: _includeClientAddress,
                                  ),
                                  Text(
                                    'Include client\'s address',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: LightTheme.cDarkBlue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
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
                                    title: "Archived & Unfinished Jobs",
                                    desc:
                                        "If you want invoice to include archived jobs, restore them first. Unfinished jobs must be finished to be included in invoice (clock-in / clock out)",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Got it",
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
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.report,
                                          color: LightTheme.cRed,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Invoice will not include archived & unfinished jobs',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: LightTheme.cDarkBlue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: Icon(Icons.help,
                                              color: LightTheme.cGreen),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 55),
                          ],
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
    );
  }
}
