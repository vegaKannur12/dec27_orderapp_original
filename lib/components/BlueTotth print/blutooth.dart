// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
// // import 'package:marsproducts/components/customSnackbar.dart';

// class BluePrint {
//   Future<void> printRecee(Map<String, dynamic> printSalesData,
//       String payment_mode, String iscancelled, double bal) async {
//     print("value.printSalesData----${bal}");
//     String? isConnected = await BluetoothThermalPrinter.connectionStatus;
//     if (isConnected == "true")   
//     {
//       List<int> bytes =
//           await salesBill(printSalesData, payment_mode, iscancelled, bal);
//       final result = await BluetoothThermalPrinter.writeBytes(bytes);
//       // final result = await BluetoothThermalPrinter.writeBytes(bytes);
//       // var list = Uint8List.fromList(utf8.encode(bytes[0].toString()));
//       // final result =
//       //     await BluetoothThermalPrinter.writeText(list[0].toString());
//       print("Print success $result");
//       await BluetoothThermalPrinter.disconnect();
//     } 
//     else 
//     {
//       print("not connected----");
//       //  CustomSnackbar snackbar = CustomSnackbar();
//       //     snackbar.showSnackbar(context, "Printer not Connected", "");
//     }
//   }

//   Future<List<int>> salesBill(Map<String, dynamic> printSalesData,
//       String payment_mode, String iscancelled, double bal) async {
//     print("entered sales bill");
//     List<int> bytes = [];
//     CapabilityProfile profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm80, profile);
//     bytes += generator.text(
//         printSalesData["company"][0]["cnme"].toString().toUpperCase(),
//         styles: PosStyles(
//             align: PosAlign.center,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//             codeTable: 'CP1252'),
//         linesAfter: 1);

//     if (printSalesData["company"][0]["ad1"] != null &&
//         printSalesData["company"][0]["ad1"].isNotEmpty) {
//       bytes += generator.text(printSalesData["company"][0]["ad1"].toUpperCase(),
//           styles: PosStyles(align: PosAlign.center));
//     }

//     if (printSalesData["company"][0]["ad2"] != null &&
//         printSalesData["company"][0]["ad2"].isNotEmpty) {
//       bytes += generator.text(printSalesData["company"][0]["ad2"].toUpperCase(),
//           styles: PosStyles(align: PosAlign.center));
//     }
//     bytes += generator.feed(1);
//     // if (printSalesData["company"][0]["mob"] != null &&
//     //     printSalesData["company"][0]["mob"].isNotEmpty) {
//     //   bytes += generator.text(
//     //       'PHONE : "${printSalesData["company"][0]["mob"]}"',
//     //       styles: PosStyles(align: PosAlign.center));
//     // }

//     bytes += generator.row([
//       PosColumn(
//           text: 'Bill No : ${printSalesData["master"]["sale_Num"]}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.left, bold: true)),
//       PosColumn(
//           text: 'Date : ${printSalesData["master"]["Date"]}',
//           width: 6,
//           styles: PosStyles(align: PosAlign.right, bold: true)),
//     ]);

//     bytes += generator.row([
//       PosColumn(
//           text: 'To : ${printSalesData["master"]["cus_name"]}',
//           width: 12,
//           styles: PosStyles(align: PosAlign.left, bold: true)),
//     ]);
//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//           text: 'Item',
//           width: 4,
//           styles: PosStyles(align: PosAlign.left, bold: true)),
//       PosColumn(
//           text: 'Qty',
//           width: 2,
//           styles: PosStyles(align: PosAlign.right, bold: true)),
//       PosColumn(
//           text: 'Price',
//           width: 3,
//           styles: PosStyles(align: PosAlign.right, bold: true)),
//       PosColumn(
//           text: 'Total',
//           width: 3,
//           styles: PosStyles(align: PosAlign.right, bold: true)),
//     ]);
//     bytes += generator.hr();
//     for (int i = 0; i < printSalesData["detail"].length; i++) {
//       bytes += generator.row([
//         PosColumn(
//             text: printSalesData["detail"][i]["item"],
//             width: 4,
//             styles: PosStyles(align: PosAlign.left, bold: true)),
//         PosColumn(
//             text: printSalesData["detail"][i]["qty"].toStringAsFixed(2),
//             width: 2,
//             styles: PosStyles(align: PosAlign.right, bold: true)),
//         PosColumn(
//             text: printSalesData["detail"][i]["rate"].toStringAsFixed(2),
//             width: 3,
//             styles: PosStyles(align: PosAlign.right, bold: true)),
//         PosColumn(
//             text: printSalesData["detail"][i]["net_amt"].toStringAsFixed(2),
//             width: 3,
//             styles: PosStyles(align: PosAlign.right, bold: true)),
//       ]);
//     }
//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//           text: 'TOTAL',
//           width: 6,
//           styles: PosStyles(
//               align: PosAlign.left,
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               bold: true)),
//       PosColumn(
//           text: printSalesData["master"]["net_amt"].toStringAsFixed(2),
//           width: 6,
//           styles: PosStyles(
//               align: PosAlign.right,
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               bold: true)),
//     ]);
//     bytes += generator.feed(1);
//     bytes += generator.row([
//       PosColumn(
//           text: 'SALESMAN',
//           width: 6,
//           styles: PosStyles(
//             align: PosAlign.left,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//           )),
//       PosColumn(
//           text: printSalesData["staff"][0]["sname"].toString().toUpperCase(),
//           width: 6,
//           styles: PosStyles(
//             align: PosAlign.right,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//           )),
//     ]);
//     bytes += generator.hr(ch: '=', linesAfter: 1);
//     // ticket.feed(2);
//     bytes += generator.text('Thank you!',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//     bytes += generator.cut();
//     return bytes;
//   }
// }
