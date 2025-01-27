import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// today sales date --
Future<void> generateSalesReportPdf(
    BuildContext context, List<Map<String, dynamic>> list) async {
  //  =await
  //     Provider.of<Controller>(context, listen: false).todaySalesList;
  final font = await PdfGoogleFonts.robotoCondensedRegular();
  final PdfColor whitecolor = PdfColors.white;

  final saleReportPdf = pw.Document();
  Size size = MediaQuery.of(context).size;

  saleReportPdf.addPage(
    pw.Page(
    theme: pw.ThemeData(softWrap: true),
    // pageFormat: PdfPageFormat(200, 150),
    //  theme: pw.ThemeData(softWrap: true),
    //   // pageFormat:PdfPageFormat(144, 100),
    pageFormat: PdfPageFormat.roll80,
    build: (context) {
      return pw.Column(
          // mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            
            // pw.Center(
            //   child: pw.Text(
            //     'SALES REPORT',
            //     style: pw.TextStyle(
            //       fontSize: 20,
            //       fontWeight: pw.FontWeight.bold,
            //     ),
            //   ),
            // ),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text("BILL NO",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                          font: font)),
                  pw.Text("DATE",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                          font: font)),
                  pw.Text("AMOUNT",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                          font: font))
                ]),
            pw.Divider(),
            for (var index = 0; index < list.length; index++)
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Text(
                      list[index]["sale_Num"],
                      style: pw.TextStyle(fontSize: 10, font: font),
                    ),
                    pw.Text(
                      list[index]["Date"],
                      style: pw.TextStyle(fontSize: 10, font: font),
                    ),
                    pw.Text(
                      list[index]["net_amt"].toString(),
                      style: pw.TextStyle(fontSize: 10, font: font),
                    ),
                  ]),
            pw.SizedBox(height: 20),
            pw.Divider(),
          ]);
    },
  ));
  await Printing.layoutPdf(
    format: PdfPageFormat.roll80,
    onLayout: (PdfPageFormat format) async => saleReportPdf.save(),
  );

  Future<String> savePdfToLocal(pw.Document pdf) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/sales_bill.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }
}
// import 'dart:io';
// import 'dart:typed_data'; // Import this for Uint8List
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// // Load image from assets
// Future<pw.MemoryImage> loadImageFromAssets(String path) async {
//   final ByteData data = await rootBundle.load(path);
//   final List<int> bytes = data.buffer.asUint8List();
//   final Uint8List uint8List = Uint8List.fromList(bytes);  // Convert to Uint8List
//   final image = pw.MemoryImage(uint8List); // Correct class for pdf package
//   return image;
// }

// // Today sales report generation
// Future<void> generateSalesReportPdf(
//     BuildContext context, List<Map<String, dynamic>> list) async {
//   final font = await PdfGoogleFonts.robotoCondensedRegular();
//   final PdfColor whitecolor = PdfColors.white;

//   final saleReportPdf = pw.Document();
//   Size size = MediaQuery.of(context).size;

//   // Load image from assets (example: logo.png)
//   final image = await loadImageFromAssets("asset/order.png"); // Ensure the image is in your assets folder

//   saleReportPdf.addPage(
//     pw.Page(
//       theme: pw.ThemeData(softWrap: true),
//       pageFormat: PdfPageFormat.roll80,
//       build: (context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Add the image to the top of the PDF
//             pw.Center(
//               child: pw.Image(image, width: 100, height: 100), // Adjust the size as needed
//             ),
//             pw.SizedBox(height: 20), // Space between the image and text

//             // Title and Sales Report Information
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
//               children: [
//                 pw.Text("BILL NO",
//                     style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 10,
//                         font: font)),
//                 pw.Text("DATE",
//                     style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 10,
//                         font: font)),
//                 pw.Text("AMOUNT",
//                     style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 10,
//                         font: font))
//               ],
//             ),
//             pw.Divider(),

//             // Iterate through the list and add each row of data
//             for (var index = 0; index < list.length; index++)
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
//                 children: [
//                   pw.Text(
//                     list[index]["sale_Num"],
//                     style: pw.TextStyle(fontSize: 10, font: font),
//                   ),
//                   pw.Text(
//                     list[index]["Date"],
//                     style: pw.TextStyle(fontSize: 10, font: font),
//                   ),
//                   pw.Text(
//                     list[index]["net_amt"].toString(),
//                     style: pw.TextStyle(fontSize: 10, font: font),
//                   ),
//                 ],
//               ),
//             pw.SizedBox(height: 20),
//             pw.Divider(),
//           ],
//         );
//       },
//     ),
//   );

//   // Print or save the PDF
//   await Printing.layoutPdf(
//     format: PdfPageFormat.roll80,
//     onLayout: (PdfPageFormat format) async => saleReportPdf.save(),
//   );

//   // Save PDF locally if needed
//   Future<String> savePdfToLocal(pw.Document pdf) async {
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/sales_bill.pdf';
//     final file = File(filePath);
//     await file.writeAsBytes(await pdf.save());
//     return filePath;
//   }
// }
