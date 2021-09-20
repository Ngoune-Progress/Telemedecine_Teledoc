import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teledoc/HealthSpecialistMenu/prescription.dart';
import 'package:teledoc/model/Order.dart';
import 'package:teledoc/model/pres.dart';

class PdfApi {
  static Future<File> generatePDF({
    required List<Prescript> order,
    required String? name,
    required ByteData imageSignature,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();
    drawGrid(order, page);
    drawSignature(name!, page, imageSignature);
    return saveFile(document);
  }

  // static Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  static drawGrid(List<Prescript> order, PdfPage page) async {
    final pageSize = page.getClientSize();
    final grid = PdfGrid();
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(34, 126, 252)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string.
    page.graphics.drawString(
        'Tele-Doc', PdfStandardFont(PdfFontFamily.helvetica, 40),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString(
        'Amount', PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Prescription Number: 2058557939\r\n\r\nDate: ' +
            format.format(DateTime.now());
    // final Size contentSize = contentFont.measureString(invoiceNumber);
    const String address =
        'Bill To: \r\n\r\nAbraham Swearegin, \r\n\r\nUnited States, California, San Mateo, \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136';
    PdfTextElement(
            text: invoiceNumber,
            font: PdfStandardFont(PdfFontFamily.helvetica, 10))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(pageSize.width - (pageSize.width + -10), 120,
                pageSize.width + 10, pageSize.height - 120));
    //Draw string.
    grid.columns.add(count: 3);

    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(34, 126, 252));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Drug Quantity';
    headerRow.cells[1].value = 'Drug Name';
    headerRow.cells[2].value = 'Drug dose';

    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);

    order.forEach((prescription) {
      final row = grid.rows.add();
      row.cells[0].value = prescription.drugNo;
      row.cells[1].value = prescription.drugName;
      row.cells[2].value = prescription.drugDose;
    });
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent2);
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    for (int i = 0; i < grid.rows.count; i++) {
      final row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final cell = row.cells[j];
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    grid.draw(
        page: page, bounds: Rect.fromLTWH(0, pageSize.height - 500, 0, 0));
  }

  static void drawSignature(
      String name, PdfPage page, ByteData imageSignature) {
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());
    final now = DateFormat.yMMMEd().format(DateTime.now());
    final signatureText = '''By Dr $name   
    Date: $now ''';
    page.graphics.drawString(
        signatureText, PdfStandardFont(PdfFontFamily.helvetica, 12),
        format: PdfStringFormat(alignment: PdfTextAlignment.justify),
        bounds:
            Rect.fromLTWH(pageSize.width - 240, pageSize.height - 100, 0, 0));
    page.graphics.drawImage(image,
        Rect.fromLTWH(pageSize.width - 90, pageSize.height - 100, 100, 40));
  }

  static Future<File> saveFile(PdfDocument document) async {
    final path = await getApplicationDocumentsDirectory();
    final fileName = await path.path +
        '/Prescription${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);
    file.writeAsBytes(document.save());
    document.dispose();
    return file;
  }
}
