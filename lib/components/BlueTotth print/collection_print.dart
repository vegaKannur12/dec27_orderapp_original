import 'package:flutter/material.dart';
import 'package:number_to_indian_words/number_to_indian_words.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sqlorder24/controller/controller.dart';
import 'package:sqlorder24/db_helper.dart';

Future<void> generateCollectionPdf(BuildContext context, String? cidd) async {

  
  final font = await PdfGoogleFonts.robotoCondensedRegular();
  final font1 = await PdfGoogleFonts.robotoBlack();

  final PdfColor whitecolor = PdfColors.white;
  List<Map<String, dynamic>> Collection_Print_Dat = [];

  print('cid--------------- $cidd');
  Collection_Print_Dat.clear();

  var res = await OrderAppDB.instance
      .Get_Collection_details("collectionTable.rec_row_num='${cidd}'");
  print("res colection====$res");
  if (res != null) {
    for (var menu in res) {
      Collection_Print_Dat.add(menu);
    }
  }

  print("mydata for collection111111111 ----${res}");
  print("mydata for collection ----${Collection_Print_Dat}");

  if (Collection_Print_Dat.isNotEmpty) {
/////print amount in words/////////
    double netAmount =
        double.parse(Collection_Print_Dat[0]["rec_amount"].toString());
    String netAmountInWords =
        NumToWords.convertNumberToIndianWords(netAmount.toInt());

    Size size = MediaQuery.of(context).size;
    final colllectionPdf = pw.Document();

    colllectionPdf.addPage(pw.Page(
      build: (context) {
        return pw.Column(children: [
          pw.Center(
              child: pw.Text(
                  Collection_Print_Dat[0]["rec_mode"] == '-2'
                      ? "CASH RECEIPT"
                      : "CHEQUE RECEIPT",
                  style: pw.TextStyle(fontSize: 22, font: font1))),
          pw.Divider(),
          
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Text("DATE   : "),
            pw.Text(Collection_Print_Dat[0]["rec_date"])
          ]),
          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Text("ID         : "),
            pw.Text(Collection_Print_Dat[0]["id"].toString()),
          ]),
          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Text("SERIES    : "),
            pw.Text(Collection_Print_Dat[0]["rec_series"])
          ]),

          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Text("CUSTOMER  : "),
            pw.Text(Collection_Print_Dat[0]["hname"])
          ]),
          // pw.Divider(),
          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Text("FOR RUPEES RS   : "),
            pw.Text(Collection_Print_Dat[0]["rec_amount"].toString())
          ]),
          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Text("AMOUNT IN WORDS  : "),
            pw.Text(netAmountInWords)
          ]),
          // pw.Divider(),

          // pw.Divider(),

          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Text("NARATION   : "),
            pw.Text(Collection_Print_Dat[0]["rec_note"])
          ]),
          //  pw.Divider(),

          pw.SizedBox(height: 20),
          pw.Divider()
        ]);
      },
    ));
    await Printing.layoutPdf(
      format: PdfPageFormat.roll80,
      onLayout: (PdfPageFormat format) async => colllectionPdf.save(),
    );
  } else {
    print('Collection_Print_Dat is empty');
    return; // Or throw an error if necessary
  }
}
