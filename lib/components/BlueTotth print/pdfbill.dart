import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateSalesBillPdf(Map<String, dynamic> printSalesData,
    String payment_mode, String iscancelled, double bal) async {
  final pdf = pw.Document();
  double totout = bal + printSalesData["master"]["net_amt"];

  pdf.addPage(
    pw.Page(
      // pageTheme: pw.PageTheme(),
      // theme: pw.ThemeData(),
      // pageFormat:PdfPageFormat(144, 100),
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'ESTIMATE',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Center(
              child: pw.Text('CREDIT', style: pw.TextStyle(fontSize: 10)),
            ),
            pw.SizedBox(height: 10),
            // Bill Header Information
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Bill No: ${printSalesData["master"]["sale_Num"]}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Date: ${printSalesData["master"]["Date"]}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Text(
              'To: ${printSalesData["master"]["cus_name"]}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            // Table Header
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Expanded(
                    child: pw.Text('Item',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                        overflow: pw.TextOverflow.clip)),
                pw.Expanded(
                  child:
                      // pw.SizedBox(
                      //     width: 30,
                      //     child:
                      pw.Text('Qty',textAlign: pw.TextAlign.end,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                // pw.SizedBox(width: 10),
                // pw.SizedBox(
                //     width: 50,
                //     child:
                pw.Expanded(
                  child: pw.Text('Price',textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                // pw.SizedBox(width: 10),
                // pw.SizedBox(
                //     width: 50,
                //     child:
                pw.Expanded(
                  child: pw.Text('Total',textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                )
              ],
            ),
            pw.Divider(),
            // Table Content
            ...printSalesData["detail"].map<pw.Widget>((item) {
              return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Expanded(
                      child: pw.Text(item["item"],
                          overflow: pw.TextOverflow.clip)),
                  //  pw.SizedBox(
                  //   width: 30,
                  //   child:
                  pw.Expanded(child: pw.Text(item["qty"].toStringAsFixed(2),textAlign: pw.TextAlign.end,)),
                  // pw.SizedBox(width: 10),
                  pw.Expanded(
                    child:
                        //  pw.SizedBox(
                        //   width: 50,
                        //   child:
                        pw.Text(item["rate"].toStringAsFixed(2),textAlign: pw.TextAlign.end,),
                  ),
                  // pw.SizedBox(width: 10),
                  pw.Expanded(
                      child:
                          //  pw.SizedBox(
                          //   width: 50,
                          //   child:
                          pw.Text(item["net_amt"].toStringAsFixed(2),textAlign: pw.TextAlign.end,),),
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
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text(printSalesData["master"]["net_amt"].toStringAsFixed(2),
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ],
            ),
            pw.SizedBox(height: 10),
            // Salesman and Outstanding Balance
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('SALESMAN'),
                pw.Text(printSalesData["staff"][0]["sname"]
                    .toString()
                    .toUpperCase()),
              ],
            ),
            pw.Text(
                'Outstanding (Prvs. bal: $bal): ${totout.toStringAsFixed(2)}'),
          ],
        );
      },
    ),
  );

  // Display the PDF document using `printing` package
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
