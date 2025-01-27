import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:number_to_indian_words/number_to_indian_words.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> generateSalesBillPdf(
    Map<String, dynamic> printSalesData,
    List<Map<String, dynamic>> taxableData,
    String payment_mode,
    String iscancelled,
    double bal,
    BuildContext context) async {
  final pdf = pw.Document();
  // final font = await PdfGoogleFonts.robotoFlexRegular();

  final font = await PdfGoogleFonts.robotoCondensedRegular();
  final font1 = await PdfGoogleFonts.robotoBlack();

  double totout = bal + printSalesData["master"]["net_amt"];
  Size size = MediaQuery.of(context).size;

  double netAmount =
      double.parse(printSalesData["master"]["net_amt"].toStringAsFixed(2));
  String netAmountInWords =
      NumToWords.convertNumberToIndianWords(netAmount.toInt());

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
                'GST INVOICE',
                style: pw.TextStyle(
                    fontSize: 10, fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Text('${printSalesData["company"][0]["cnme"]}',
                  style: pw.TextStyle(fontSize: 15, font: font1)),
            ),

            pw.Center(
              child: pw.Text('${printSalesData["company"][0]["ad1"]}',
                  style: pw.TextStyle(fontSize: 10, font: font1)),
            ),
            pw.Center(
              child: pw.Text('${printSalesData["company"][0]["ad2"]}',
                  style: pw.TextStyle(fontSize: 10, font: font1)),
            ),

            pw.Center(
              child: pw.Text('GSTIN : ${printSalesData["company"][0]["gst"]}',
                  style: pw.TextStyle(fontSize: 10, font: font)),
            ),

            pw.Center(
              child: pw.Text(
                  '$payment_mode' == '-3' ? "Credit Bill" : "CashBill",
                  style: pw.TextStyle(fontSize: 10, font: font)),
            ),

            pw.Divider(),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Bill No: ${printSalesData["master"]["sale_Num"]}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9, font: font),
                ),
                pw.Text(
                  'Date: ${printSalesData["master"]["Date"]}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9, font: font),
                ),
              ],
            ),

            pw.Divider(),
            pw.FittedBox(
              child: pw.Text(
                'To:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),

            pw.FittedBox(
              child: pw.Text(
                '     ${printSalesData["master"]["cus_name"]}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),

            //  pw.Container(
            //   child: pw.Text(
            //     '  ${printSalesData["master"]["address"]}          . ',
            //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
            //   ),
            // ),

            pw.FittedBox(
              child: pw.Text(
                '  ${printSalesData["master"]["address"]}          . ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),

            pw.FittedBox(
              child: pw.Text(
                '    ${printSalesData["master"]["address"]},',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),

            pw.FittedBox(
              child: pw.Text(
                'GSTIN: ${printSalesData["master"]["gstin"]}',
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
                            font: font1,
                            fontSize: 10),
                        overflow: pw.TextOverflow.clip)),

                pw.Expanded(
                  child: pw.Text('Tax%',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font1,
                          fontSize: 10)),
                ),

                pw.Expanded(
                  child:
                      // pw.SizedBox(
                      //     width: 30,
                      //     child:
                      pw.Text('Qty',
                          textAlign: pw.TextAlign.end,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: font1,
                              fontSize: 10)),
                ),
                // pw.SizedBox(width: 10),
                // pw.SizedBox(
                //     width: 50,
                //     child:
                pw.Expanded(
                  child: pw.Text('Tax Inc. Price',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font1,
                          fontSize: 8)),
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
                          font: font1,
                          fontSize: 10)),
                )
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text("HSN",
                        style: pw.TextStyle(fontSize: 8, font: font)),
                  ),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Expanded(
                    child: pw.Text("URATE",
                        // textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: 8, font: font)),
                  ),
                  //  pw.SizedBox(
                  //   width: 5,
                  // ),
                  pw.Expanded(
                    child: pw.Text("NETRATE",
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: 8, font: font)),
                  ),

                  pw.Expanded(
                    child: pw.Text("CGST",
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: 8, font: font)),
                  ),
                  pw.Expanded(
                    child: pw.Text("SGST",
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(fontSize: 8, font: font)),
                  ),
                ]),

            pw.Divider(),
            // Table Content
            ...printSalesData["detail"].map<pw.Widget>((item) {
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Expanded(
                      child: pw.Column(children: [
                    pw.Row(children: [
                      pw.Expanded(
                          flex: 2,
                          child: pw.Text(item["item"],
                              overflow: pw.TextOverflow.clip,
                              style: pw.TextStyle(font: font, fontSize: 10))),
                      //  pw.SizedBox(
                      //   width: 30,
                      //   child:

                      pw.Expanded(
                          child: pw.Text(item["tax_per"].toStringAsFixed(2),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(font: font, fontSize: 8))),
                      // pw.SizedBox(width: 10),

                      pw.Expanded(
                          child: pw.Text(item["qty"].toStringAsFixed(2),
                              textAlign: pw.TextAlign.end,
                              style: pw.TextStyle(font: font, fontSize: 8))),
                      // pw.SizedBox(width: 10),
                      pw.Expanded(
                        child:
                            //  pw.SizedBox(
                            //   width: 50,
                            //   child:
                            pw.Text(item["rate"].toStringAsFixed(2),
                                textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(font: font, fontSize: 8)),
                      ),
                      // pw.SizedBox(width: 10),
                      pw.Expanded(
                        child:
                            //  pw.SizedBox(
                            //   width: 50,
                            //   child:
                            pw.Text(item["net_amt"].toStringAsFixed(2),
                                textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(font: font, fontSize: 8)),
                      ),
                    ]),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // pw.Text(
                          //   item["unit_rate"].toStringAsFixed(2) +
                          //       '       NET:' +
                          //       item["gross"].toStringAsFixed(2) +
                          //       '       CGST:' +
                          //       item["cgst_amt"].toStringAsFixed(2) +
                          //       '       SGST:' +
                          //       item["sgst_amt"].toStringAsFixed(2) +
                          //       ' ',
                          //   style: pw.TextStyle(
                          //       fontWeight: pw.FontWeight.bold,
                          //       fontSize: 7,
                          //       font: font),
                          // ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(item["hsn"].toString(),
                                style: pw.TextStyle(fontSize: 8)),
                          ),
                          pw.Expanded(
                            child: pw.Text(item["unit_rate"].toStringAsFixed(2),
                                // textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.SizedBox(width: 2),

                          pw.Expanded(
                            child: pw.Text(item["gross"].toStringAsFixed(2),
                                textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.SizedBox(width: 2),

                          pw.Expanded(
                            child: pw.Text(item["cgst_amt"].toStringAsFixed(2),
                                textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.SizedBox(width: 2),
                          pw.Expanded(
                            child: pw.Text(item["sgst_amt"].toStringAsFixed(2),
                                textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                        ]),
                    pw.Row(
                        // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '........................................................................................................................................................',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 5,
                                font: font),
                          )
                        ]),
                    pw.SizedBox(height: 5),
                  ]))
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
                pw.Text(printSalesData["master"]["net_amt"].toStringAsFixed(2),
                    // pw.Text(netAmountInWords,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        font: font)),
              ],
            ),
            pw.SizedBox(height: 10),

            pw.Divider(),

            //TAX TOTAL ROW
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('TAX%',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                            fontSize: 8),
                        overflow: pw.TextOverflow.clip)),
                pw.Expanded(
                  child: pw.Text('TAXBLE AMT',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          fontSize: 8)),
                ),
                pw.Expanded(
                  child: pw.Text('CGST',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          fontSize: 8)),
                ),
                pw.Expanded(
                  child: pw.Text('SGST',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          fontSize: 8)),
                ),
              ],
            ),

            pw.Row(
                // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '........................................................................................................................................................',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 5,
                        font: font),
                  )
                ]),

            // TAX TOTAL LOOP

            // Table Content
            ...taxableData.map<pw.Widget>((item1) {
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Expanded(
                      flex: 1,
                      child: pw.Text(item1["tper"].toString(),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: font,
                              fontSize: 8),
                          overflow: pw.TextOverflow.clip)),
                  pw.Expanded(
                    child: pw.Text(item1["taxable"].toStringAsFixed(2),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                            fontSize: 8)),
                  ),
                  pw.Expanded(
                    child: pw.Text(item1["cgst"].toStringAsFixed(2),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                            fontSize: 8)),
                  ),
                  pw.Expanded(
                    child: pw.Text(item1["sgst"].toStringAsFixed(2),
                        textAlign: pw.TextAlign.end,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: font,
                            fontSize: 8)),
                  ),

                  // pw.Text(item1["tper"].toString()),
                  // pw.Text(item1["taxable"].toStringAsFixed(2)),
                  // pw.Text(item1["cgst"].toStringAsFixed(2)),
                  // pw.Text(item1["sgst"].toStringAsFixed(2)),
                  // pw.Text(item1["tax"].toStringAsFixed(2)),
                ],
              );
            }).toList(),

            pw.Row(
                // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '........................................................................................................................................................',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 5,
                        font: font),
                  )
                ]),

            pw.SizedBox(height: 5),
            // Salesman and Outstanding Balance
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('SALESMAN :',
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(
                    printSalesData["staff"][0]["sname"]
                        .toString()
                        .toUpperCase(),
                    style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            pw.Text(
                'Outstanding (Prvs. bal: $bal): ${totout.toStringAsFixed(2)}',
                style: pw.TextStyle(font: font, fontSize: 8)),

            pw.SizedBox(height: 100),

            pw.Text('.', style: pw.TextStyle(font: font, fontSize: 8)),
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
  final filePath = await savePdfToLocal(pdf);
  // // Share the PDF
  // await sharePdfToWhatsApp(filePath, "5666663344");

  await sharePdfWithSharePlus(filePath);
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
