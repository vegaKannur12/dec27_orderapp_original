import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> generateReturnBillPdf(Map<String, dynamic> printReturnData,
    String payment_mode, String iscancelled, BuildContext context) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.robotoCondensedRegular();
  // double totout = bal + printSalesData["master"]["net_amt"];
  Size size = MediaQuery.of(context).size;

  pdf.addPage(
    pw.Page(
      // pageTheme: pw.PageTheme(),
      theme: pw.ThemeData(softWrap: true),
      // pageFormat:PdfPageFormat(144, 100),
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'ESTIMATE',
                style: pw.TextStyle(
                    fontSize: 10, fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),
            pw.Center(
              child: pw.Text('CREDIT',
                  style: pw.TextStyle(fontSize: 10, font: font)),
            ),
            pw.SizedBox(height: 10), // Bill Header Information
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Bill No: ${printReturnData["master"]["Ret_Num"]}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9, font: font),
                ),
                pw.Text(
                  'Date: ${printReturnData["master"]["Date"]}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9, font: font),
                ),
              ],
            ),
            pw.FittedBox(
              child: pw.Text(
                'To: ${printReturnData["master"]["cus_name"]}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),

            pw.Divider(),
            // Table Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Expanded(
                    flex: 2,
                    child: pw.Text('Item',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                            fontSize: 10),
                        overflow: pw.TextOverflow.clip)),
                pw.Expanded(
                  child:
                      // pw.SizedBox(
                      //     width: 30,
                      //     child:
                      pw.Text('Qty',
                          textAlign: pw.TextAlign.end,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: font,
                              fontSize: 10)),
                ),
                // pw.SizedBox(width: 10),
                // pw.SizedBox(
                //     width: 50,
                //     child:
                pw.Expanded(
                  child: pw.Text('Price',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          fontSize: 10)),
                ),
                // pw.SizedBox(width: 10),
                // pw.SizedBox(
                //     width: 50,
                //     child:
                pw.Expanded(
                  child: pw.Text('Total',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          fontSize: 10)),
                )
              ],
            ),
            pw.Divider(),
            // Table Content
            ...printReturnData["detail"].map<pw.Widget>((item) {
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text(item["item"],
                          overflow: pw.TextOverflow.clip,
                          style: pw.TextStyle(font: font, fontSize: 9))),
                  //  pw.SizedBox(
                  //   width: 30,
                  //   child:
                  pw.Expanded(
                      child: pw.Text(
                          item["qty"] == 0
                              ? item["qty_damage"].abs().toStringAsFixed(2)
                              : item["qty"].abs().toStringAsFixed(2),
                          textAlign: pw.TextAlign.end,
                          style: pw.TextStyle(font: font, fontSize: 9))),
                  // pw.SizedBox(width: 10),
                  pw.Expanded(
                    child:
                        //  pw.SizedBox(
                        //   width: 50,
                        //   child:
                        pw.Text(item["rate"].abs().toStringAsFixed(2),
                            textAlign: pw.TextAlign.end,
                            style: pw.TextStyle(font: font, fontSize: 9)),
                  ),
                  // pw.SizedBox(width: 10),
                  pw.Expanded(
                    child:
                        //  pw.SizedBox(
                        //   width: 50,
                        //   child:
                        pw.Text(item["net_amt"].abs().toStringAsFixed(2),
                            textAlign: pw.TextAlign.end,
                            style: pw.TextStyle(font: font, fontSize: 9)),
                  ),
                ],
              );
            }).toList(),
            pw.Divider(),
            // Total Amount Row
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        font: font)),
                pw.Text(
                    printReturnData["master"]["net_amt"]
                        .abs()
                        .toStringAsFixed(2),
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        font: font)),
              ],
            ),
            pw.SizedBox(height: 10),
            // Salesman and Outstanding Balance
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('SALESMAN',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(
                    printReturnData["staff"][0]["sname"]
                        .toString()
                        .toUpperCase(),
                    style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            // pw.Text(
            //     'Outstanding (Prvs. bal: $bal): ${totout.toStringAsFixed(2)}',
            //     style: pw.TextStyle(font: font, fontSize: 8)),

            pw.SizedBox(height: 60),
          ],
        );
      },
    ),
  );

  // Display the PDF document using `printing` package
  await Printing.layoutPdf(
    format: PdfPageFormat.roll57,
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
  //   // Save PDF to local storage
  // final filePath = await savePdfToLocal(pdf);
  // // Share the PDF
  // await sharePdfToWhatsApp(filePath, "5666663344");
}

Future<String> savePdfToLocal(pw.Document pdf) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/sales_bill.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return filePath;
}

Future<void> sharePdfToWhatsApp(String filePath, String phoneNumber) async {
  final uri = Uri.parse(
      'whatsapp://send?phone=$phoneNumber&text=Here is the sales bill.');
  if (await canLaunchUrl(uri)) {
    // WhatsApp opens with a pre-filled message
    // await launchUrl(uri);
    sharePdfWithSharePlus(filePath);
    // To attach a file, users need to manually pick it from their gallery or file system
  } else {
    throw 'Could not launch WhatsApp';
  }
}

Future<void> sharePdfWithSharePlus(String filePath) async {
  // await Share.shareFiles([filePath], text: 'Here is the sales bill.');
  await Share.shareXFiles([XFile(filePath)], text: 'Here is the sales bill.');
}
