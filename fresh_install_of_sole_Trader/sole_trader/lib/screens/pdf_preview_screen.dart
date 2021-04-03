import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sole_trader/theme/theme_appbar.dart';
import 'package:sole_trader/theme/theme_colors.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String path;
  final pw.Document pdf;
  final bool isInvoice;
  PdfPreviewScreen({this.path, this.pdf, this.isInvoice});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text(
          'soleTrader',
          style: TextStyle(
            color: LightTheme.cDarkBlue,
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            fontFamily: 'Poppins',
            letterSpacing: 1.2,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: LightTheme.cDarkYellow,
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: LightTheme.cDarkBlue, size: 30),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => pdf.save());
                },
                child: Icon(
                  Icons.print,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await Printing.sharePdf(
                      bytes: pdf.save(),
                      filename:
                          isInvoice == true ? 'invoice.pdf' : 'quote.pdf');
                },
                child: Icon(
                  Icons.share,
                  size: 26.0,
                ),
              )),
        ],
      ),
      path: path,
    );
  }
}
