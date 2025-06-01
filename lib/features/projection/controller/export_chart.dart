import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Your app color converted to PdfColor
final PdfColor pdfAppColor = PdfColor.fromInt(0xff171616);

Future<void> exportChartAsPDF(GlobalKey chartKey, String phase) async {
  try {
    RenderRepaintBoundary boundary =
    chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final pdf = pw.Document();
    final imageProvider = pw.MemoryImage(pngBytes);

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: pdfAppColor),
          ),
        ),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Your Investments by $phase',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.white, // Set text color to white for visibility
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Image(imageProvider),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    print("PDF export failed: $e");
  }
}
