import 'package:imin_printer/column_maker.dart';
import 'package:imin_printer/enums.dart';
import 'package:imin_printer/imin_printer.dart';

class IminPrintClass {
  final iminPrinter = IminPrinter();
  Future<void> printReport(
      List<Map<String, dynamic>> reportData, String type) async {
    print("reportData---imin-$type--${reportData}");

    // await printLogoImage();
    // await printText("Flutter is awesome");
    // await printHeader(printSalesData, payment_mode);
    if (type == "sales") 
    {
      await saleReportPrint(reportData);
    }
    else if (type == "collection") 
    {
      // await collectionReportPrint(reportData);
    }   
    else if (type == "sale order") 
    {
      // await orderReportPrint(reportData);
    }
    
    // await SunmiPrinter.line();
    // await printTotal(printSalesData);
    // await SunmiPrinter.lineWrap(3);
    // await SunmiPrinter.submitTransactionPrint();
    // await SunmiPrinter.cut();
    // await closePrinter();
  }

  saleReportPrint(List<Map<String, dynamic>> result) async {
    double sum = 0.0;
    await iminPrinter.printColumnsText(cols: [
      ColumnMaker(
          text: 'Bill No',
          width: 100,
          fontSize: 26,
          align: IminPrintAlign.left),
      ColumnMaker(
          text: 'Date', width: 180, fontSize: 26, align: IminPrintAlign.left),
      ColumnMaker(
          text: 'Amount', width: 100, fontSize: 26, align: IminPrintAlign.left),
    ]);
    await iminPrinter.printAndLineFeed();
    for (int i = 0; i < result.length; i++) {
      sum = sum + result[i]["net_amt"];
      await iminPrinter.printColumnsText(cols: [
        ColumnMaker(
          // text:"jhdjsdjhdjsdjdhhhhhhhhhhhhhhhhh",
          text: result[i]["sale_Num"],
          width: 100,
          align: IminPrintAlign.left,
        ),
        ColumnMaker(
          // text:"jhdjsdjhdjsdjdhhhhhhhhhhhhhhhhh",
          text: result[i]["Date"],
          width: 180,
          align: IminPrintAlign.left,
        ),
        ColumnMaker(
          //  text: "345622.00",
          text: result[i]["net_amt"].toStringAsFixed(2),
          width: 100,
          align: IminPrintAlign.right,
        ),
      ]);
      // await SunmiPrinter.lineWrap(1);
    }
    await iminPrinter.printAndFeedPaper(70);
  }
}
