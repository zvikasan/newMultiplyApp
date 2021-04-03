import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'package:sole_trader/models/job_model.dart';
import 'package:sole_trader/models/quote_model.dart';
import 'package:sole_trader/screens/add_quote_entry_screen.dart';
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';
import 'package:intl/intl.dart';
import 'package:sole_trader/models/client_model.dart';
import 'package:sole_trader/models/my_details_model.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../database_helper.dart';
import 'pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class QuoteEntriesScreen extends StatefulWidget {
  final String clientNickname;
  final int clientId;
  final double clientHourlyRate;
  final int quoteId;
  final int quoteNumber;
  final DateTime quoteDate;
  final DateTime quoteValidUntil;
  QuoteEntriesScreen(
      {this.clientNickname,
      this.quoteId,
      this.quoteNumber,
      this.quoteDate,
      this.quoteValidUntil,
      this.clientId,
      this.clientHourlyRate});
  @override
  _QuoteEntriesScreenState createState() => _QuoteEntriesScreenState();
}

class _QuoteEntriesScreenState extends State<QuoteEntriesScreen> {
  Future<List<QuoteEntry>> _quoteEntryList;
  TextEditingController _quoteDateController = TextEditingController();
  TextEditingController _validUntilController = TextEditingController();
  TextEditingController _quoteNumberController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd MMM, yyy');
  DateTime _quoteDate;
  DateTime _validUntilDate;
  int _quoteNumber;
  bool _tapped = false; // needed to disable second tap on undo

  // Additional code for generating PDF ------------------------------
  pw.Document quoteToPrint = pw.Document();
  static const _baseColor = PdfColors.blue800;
  static const _accentColor = PdfColors.black;
  static const _darkColor = PdfColors.blueGrey;
  static const _lightColor = PdfColors.white;
  PdfColor get _baseTextColor =>
      _baseColor.luminance < 0.5 ? _lightColor : _darkColor;
  final DateFormat _dateFormatterQuoteDate = DateFormat('dd MMM, yyy');
  Client _client;
  List<QuoteEntry> _quoteEntryList2;
  List<FormattedQuoteEntry> formattedQuoteEntryList;
  MyDetails _myDetails = MyDetails();
  String gstText;

  bool _withAddedCosts = false;
  bool _withNotes = false;
  double col0, col1, col2, col3, col4, col5;
  pw.Alignment cell3, cell4, cell5;

  _updateFormattedQuoteEntryList(Quote quote) async {
    _myDetails = await DatabaseHelper.instance.getMyDetails();
    _quoteEntryList2 =
        await DatabaseHelper.instance.getQuoteEntryList(widget.quoteId);

    QuotePdf quoteData = QuotePdf(
      quoteEntries: _quoteEntryList2,
    );
    formattedQuoteEntryList = quoteData.formattedQuoteEntriesList();
    if (_myDetails.gstRequired == 0) {
      gstText = '';
    } else {
      gstText =
          '${_myDetails.myBillingName} is not required to register for GST';
    }
    setState(() {
      _withAddedCosts = false;
      _withNotes = false;
      for (QuoteEntry quoteEntry in _quoteEntryList2) {
        if (quoteEntry.addedCosts > 0.1) {
          _withAddedCosts = true;
        }
        if (quoteEntry.notes != null && quoteEntry.notes != '') {
          _withNotes = true;
        }
      }

      if (_withAddedCosts == true && _withNotes == true) {
        col0 = 25;
        col1 = 13;
        col2 = 13;
        col3 = 13;
        col4 = 24;
        col5 = 12;

        cell3 = pw.Alignment.centerLeft;
        cell4 = pw.Alignment.centerLeft;
        cell5 = pw.Alignment.centerRight;
      } else if (_withAddedCosts == false && _withNotes == false) {
        col0 = 55;
        col1 = 15;
        col2 = 15;
        col3 = 15;
        col4 = 0;
        col5 = 0;

        cell3 = pw.Alignment.centerRight;
        cell4 = pw.Alignment.centerLeft;
        cell5 = pw.Alignment.centerRight;
      } else if (_withAddedCosts == true && _withNotes == false) {
        col0 = 40;
        col1 = 15;
        col2 = 15;
        col3 = 15;
        col4 = 15;
        col5 = 0;

        cell3 = pw.Alignment.centerLeft;
        cell4 = pw.Alignment.centerRight;
        cell5 = pw.Alignment.centerRight;
      } else if (_withAddedCosts == false && _withNotes == true) {
        col0 = 30;
        col1 = 13;
        col2 = 13;
        col3 = 30;
        col4 = 14;
        col5 = 0;

        cell3 = pw.Alignment.centerLeft;
        cell4 = pw.Alignment.centerRight;
        cell5 = pw.Alignment.centerRight;
      }
    });
  }

  double _calculateSubTotal() {
    double subtotal = 0;
    String subtotalString;
    formattedQuoteEntryList.forEach((element) {
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
                      'QUOTE',
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
                      height: 60,
                      child: pw.DefaultTextStyle(
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                        child: pw.GridView(
                          crossAxisCount: 2,
                          children: [
                            pw.Text('Quote #'),
                            pw.Text(_quoteNumber != null
                                ? _quoteNumber.toString()
                                : widget.quoteNumber.toString()),
                            pw.Text('Date:'),
                            pw.Text(
                                '${_dateFormatterQuoteDate.format(_quoteDate)}'),
                            pw.Text('Valid until:'),
                            pw.Text(
                                '${_dateFormatterQuoteDate.format(_validUntilDate)}'),
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
                  ),
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
                  'Quote for:',
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
                        pw.TextSpan(
                          text: _client.clientAddress,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        )
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
              // pw.SizedBox(height: 5),
              // pw.SizedBox(height: 10),
              // pw.Text(
              //   'Thank you for your business',
              //   style: pw.TextStyle(
              //     color: _darkColor,
              //     fontWeight: pw.FontWeight.bold,
              //   ),
              // ),
              // pw.SizedBox(height: 10),
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
    if (_withNotes == false && _withAddedCosts == false) {
      tableHeaders = [
        '  Job Description ',
        'Hourly Rate   ',
        'Estimated Duration  ',
        'Amount ',
      ];
    } else if (_withNotes == false && _withAddedCosts == true) {
      tableHeaders = [
        '  Job Description ',
        'Hourly Rate   ',
        'Estimated Duration  ',
        'Added costs ',
        'Amount ',
      ];
    } else if (_withNotes == true && _withAddedCosts == false) {
      tableHeaders = [
        '  Job Description ',
        'Hourly Rate   ',
        'Estimated Duration  ',
        'Notes ',
        'Amount ',
      ];
    } else {
      tableHeaders = [
        '  Job Description ',
        'Hourly Rate   ',
        'Estimated Duration  ',
        'Added costs ',
        'Notes ',
        'Amount ',
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
      // headerAlignment: pw.Alignment.centerRight,

      // cellHeight: 0,
      cellPadding: pw.EdgeInsets.fromLTRB(5, 10, 5, 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: cell3,
        4: cell4,
        5: cell5,
      },
      columnWidths: {
        0: pw.FlexColumnWidth(col0),
        1: pw.FlexColumnWidth(col1),
        2: pw.FlexColumnWidth(col2),
        3: pw.FlexColumnWidth(col3),
        4: pw.FlexColumnWidth(col4),
        5: pw.FlexColumnWidth(col5),
      },
      headerAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: cell3,
        4: cell4,
        5: cell5,
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
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        formattedQuoteEntryList.length,
        (row) => List<String>.generate(
          tableHeaders
              .length, //the next logic eliminates unused columns when job notes or added costs are not used
          (col) {
            if (_withAddedCosts == true && _withNotes == true) {
              return formattedQuoteEntryList[row].getIndex(col);
            } else if (_withAddedCosts == false && _withNotes == false) {
              return formattedQuoteEntryList[row]
                  .getIndex(col <= 2 ? col : col + 2);
            } else if (_withAddedCosts == true && _withNotes == false) {
              return formattedQuoteEntryList[row]
                  .getIndex(col <= 3 ? col : col + 1);
            } else {
              return formattedQuoteEntryList[row]
                  .getIndex(col <= 2 ? col : col + 1);
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List> generatePdfQuote() async {
    final pdfQuote = pw.Document();

    final font1 = await rootBundle.load('assets/fonts/roboto1.ttf');
    final font2 = await rootBundle.load('assets/fonts/roboto2.ttf');
    final font3 = await rootBundle.load('assets/fonts/roboto3.ttf');

    pdfQuote.addPage(
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

    quoteToPrint = pdfQuote;
    return pdfQuote.save();
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/pdfQuote.pdf");
    file.writeAsBytes(await generatePdfQuote());
  }

// -----------------------------------------------------------------

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _quoteDate = widget.quoteDate;
    _quoteNumber = widget.quoteNumber;
    _validUntilDate = widget.quoteValidUntil;
    _quoteDateController.text = _dateFormatter.format(_quoteDate);
    _validUntilController.text = _dateFormatter.format(_validUntilDate);
    _quoteNumberController.text = widget.quoteNumber.toString();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _quoteDateController.dispose();
    _validUntilController.dispose();
    _quoteNumberController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget _buildQuoteEntryForList(QuoteEntry quoteEntry) {
    double _estimatedTotal;
    _estimatedTotal = quoteEntry.hourlyRate * quoteEntry.estimatedDuration;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddQuoteEntryScreen(
              quoteEntry: quoteEntry,
              quoteId: widget.quoteId,
              clientNickname: widget.clientNickname,
              clientHourlyRate: widget.clientHourlyRate,
              quoteNumber: _quoteNumber,
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
              children: [
                Expanded(
                  flex: 70,
                  child: Column(
                    //main left column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        child: Row(
                          //job description
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                '${quoteEntry.description}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        //estimated duration
                        children: [
                          Expanded(
                            child: Text(
                              'Duration: ${quoteEntry.estimatedDuration}h',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: LightTheme.cGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: RaisedButton(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  color: LightTheme.cGreen,
                                  visualDensity: VisualDensity.compact,
                                  child: Text(
                                    'Add as job',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Job newJob = Job(
                                      jobName: 'New job',
                                      jobDescription: quoteEntry.description,
                                      jobHourlyRate: quoteEntry.hourlyRate,
                                      jobStatus: 0,
                                      jobAddedCosts: quoteEntry.addedCosts,
                                      clientId: widget.clientId,
                                      isArchived: 0,
                                      jobNotes: quoteEntry.notes,
                                      startTime: DateTime.now(),
                                      endTime: DateTime.now(),
                                    );
                                    await DatabaseHelper.instance
                                        .addJob(newJob);
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
                                      title: "Job Added",
                                      desc:
                                          "Go to ${widget.clientNickname} to view it",
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
                                          radius: BorderRadius.circular(15.0),
                                        ),
                                      ],
                                    ).show();
                                  }
                                  // jobProvider.addJob(newJob);
                                  ),
                            ),
                          ),
                        ],
                      )
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
                                '\$${quoteEntry.hourlyRate}',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                          'estimated cost',
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
                                '\$${_estimatedTotal.toStringAsFixed(2)}',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'added costs',
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
                                '\$${quoteEntry.addedCosts}',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ), // hourly rate
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
    var screenSize = MediaQuery.of(context).size;
    var quoteProvider = Provider.of<DataProvider>(context);
    _quoteEntryList = quoteProvider.getQuoteEntryList(widget.quoteId);
    return Scaffold(
      bottomNavigationBar: ThemeBottomNavigationBar(
        key: Key('QuoteEntriesScreen'),
        context: context,
      ),
      backgroundColor: LightTheme.cLightYellow,
      appBar: ThemeAppBar(
        appBar: AppBar(),
        context: context,
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), //auto hide for on-screen keyboard
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
                              'Quote',
                              style: TextStyle(
                                color: LightTheme.cDarkBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          Text(
                            'For ${widget.clientNickname}',
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
                        controller: _quoteNumberController,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        cursorColor: LightTheme.cDarkBlue,
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
                        validator: (input) => int.tryParse(input) == null ||
                                int.tryParse(input) == 0
                            ? ''
                            : null,
                        onChanged: (input) {
                          _quoteNumber = int.parse(input);
                          Quote tempQuote = Quote.withId(
                            quoteNumber: _quoteNumber,
                            quoteId: widget.quoteId,
                            clientId: widget.clientId,
                            date: _quoteDate,
                            validUntil: _validUntilDate,
                          );
                          quoteProvider.updateQuote(tempQuote);
                        },
                        //initialValue: _quoteNumber.toString(),
                      ),
                    ),
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
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: (Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 60) / 2,
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
                                          initialDateTime: _quoteDate,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            _quoteDateController.text =
                                                _dateFormatter.format(newDate);
                                            setState(() {
                                              _quoteDate = newDate;
                                            });
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              Quote tempQuote = Quote.withId(
                                                quoteNumber: _quoteNumber,
                                                quoteId: widget.quoteId,
                                                clientId: widget.clientId,
                                                date: _quoteDate,
                                                validUntil: _validUntilDate,
                                              );
                                              quoteProvider
                                                  .updateQuote(tempQuote);
                                            }
                                          },
                                          maximumDate: DateTime(2100, 12, 30),
                                          minimumYear: 2000,
                                          maximumYear: 2100,
                                          mode: CupertinoDatePickerMode.date,
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
                              if (_quoteDate.isAfter(_validUntilDate)) {
                                return ('Please choose valid dates');
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width - 60) / 2,
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
                                          initialDateTime: _validUntilDate,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            _validUntilController.text =
                                                _dateFormatter.format(newDate);
                                            setState(() {
                                              _validUntilDate = newDate;
                                            });
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              Quote tempQuote = Quote.withId(
                                                quoteNumber: _quoteNumber,
                                                quoteId: widget.quoteId,
                                                clientId: widget.clientId,
                                                date: _quoteDate,
                                                validUntil: _validUntilDate,
                                              );
                                              quoteProvider
                                                  .updateQuote(tempQuote);
                                            }
                                          },
                                          maximumDate: DateTime(2100, 12, 30),
                                          minimumYear: 2000,
                                          maximumYear: 2100,
                                          mode: CupertinoDatePickerMode.date,
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
                              if (_validUntilDate.isBefore(_quoteDate)) {
                                return ('Please choose valid dates');
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(height: 2),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                    future: _quoteEntryList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          itemCount: 1 + snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return SizedBox.shrink();
                            }
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: LightTheme.cRed,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Delete entry',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 10),
                                        child: Icon(
                                          Icons.delete,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onDismissed: (direction) {
                                _tapped = false;
                                var quotesProvider = Provider.of<DataProvider>(
                                    context,
                                    listen: false);
                                quotesProvider
                                    .deleteQuoteEntry(snapshot.data[index - 1]);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: LightTheme.cLightYellow2,
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Entry deleted',
                                          style: TextStyle(
                                            color: LightTheme.cDarkBlue,
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            if (_tapped == false) {
                                              quotesProvider
                                                  .restoreQuoteEntry();
                                              _tapped = true;
                                            }
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  color: LightTheme.cLightGreen,
                                  child: _buildQuoteEntryForList(
                                      snapshot.data[index - 1]),
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
                          title: "Deleting a Quote",
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Do I really want to delete this quote?'),
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
                                quoteProvider.deleteQuote(widget.quoteId);
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
                            Icon(
                              Icons.description,
                              size: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        Quote _quote;
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _client =
                              await quoteProvider.getClient(widget.clientId);
                          _quote = await quoteProvider
                              .getQuote(widget.quoteId, widget.clientId)
                              .whenComplete(() async {
                            await _updateFormattedQuoteEntryList(_quote);

                            await savePdf();
                            Directory documentDirectory =
                                await getApplicationDocumentsDirectory();
                            String documentPath = documentDirectory.path;
                            String fullPath = '$documentPath/pdfQuote.pdf';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfPreviewScreen(
                                  isInvoice: false,
                                  path: fullPath,
                                  pdf: quoteToPrint,
                                ),
                              ),
                            );
                          });
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
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              'Job',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                //fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddQuoteEntryScreen(
                              quoteId: widget.quoteId,
                              clientNickname: widget.clientNickname,
                              clientHourlyRate: widget.clientHourlyRate,
                              quoteNumber: _quoteNumber,
                              // updateJobsMap: _updateJobsCountMap,
                            ),
                          ),
                        );
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
