import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlorder24/components/customSnackbar.dart';
import 'package:sqlorder24/screen/SALES/saleItemDetails.dart';
import 'package:sqlorder24/screen/SALES/salesBottomsheet.dart';
import 'package:provider/provider.dart';
import '../../components/commoncolor.dart';
import '../../components/popupPayment.dart';
import '../../controller/controller.dart';
import '../../db_helper.dart';

class SaleCartX001 extends StatefulWidget {
  String custmerId;
  String os;
  String areaId;
  String areaname;
  String type;
  String branch_id;
  SaleCartX001( 
      {required this.areaId,
      required this.custmerId,
      required this.os,
      required this.areaname,
      required this.type,
      required this.branch_id});

  @override
  State<SaleCartX001> createState() => _SaleCartX001State();
}

class _SaleCartX001State extends State<SaleCartX001> {
  String? payment_mode;
  String? selected;
  PaymentSelect paysheet = PaymentSelect();
  SaleItemDetails saleDetails = SaleItemDetails();
  SalesBottomSheet sheet = SalesBottomSheet();
  TextEditingController discPerCtrl = TextEditingController();
  TextEditingController discRupeeCtrl = TextEditingController();
  List<String> s = [];
  List rawCalcResult = [];
  String? gen_condition;

  DateTime now = DateTime.now();
  String? date;
  String? sid;
  int counter = 0;
  bool isAdded = false;
  String? sname;
  double discInRupee = 0.00;
  String discInPercentage = "";
  // double totalAftrdiscount = 0.0;

  ////////////////////////////////////////////////////////
  @override
  void initState() {
    date = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    s = date!.split(" ");
    Provider.of<Controller>(context, listen: false)
        .calculatesalesTotal(widget.os, widget.custmerId);
    print("jhdjs-----${widget.os}");
    Provider.of<Controller>(context, listen: false).countFromTable(
      "salesBagTable",
      widget.os,
      widget.custmerId,
    );
    Provider.of<Controller>(context, listen: false).totalAftrdiscount =
        Provider.of<Controller>(context, listen: false).salesTotal;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<dynamic> salebagReturnList =
        Provider.of<Controller>(context, listen: false)
            .salebagList
            .where((salee) =>
                double.parse(salee["qty"].toString().trimLeft()) <
                0.0) // salee["qty"]< "0.0"
            .toList();

    print("Return List===$salebagReturnList");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: P_Settings.salewaveColor,
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       await OrderAppDB.instance
          //           .deleteFromTableCommonQuery("salesBagTable", "");
          //       await OrderAppDB.instance
          //           .deleteFromTableCommonQuery("salesMasterTable", "");
          //       await OrderAppDB.instance
          //           .deleteFromTableCommonQuery("salesDetailTable", "");
          //     },
          //     icon: Icon(Icons.delete)),
          // IconButton(
          //   onPressed: () async {
          //     List<Map<String, dynamic>> list =
          //         await OrderAppDB.instance.getListOfTables();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => TableList(list: list)),
          //     );
          //   },
          //   icon: Icon(Icons.table_bar),
          // ),
        ],
      ),
      body: GestureDetector(onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }), child: Center(
        child: Consumer<Controller>(builder: (context, value, child) {
          if (value.isCartLoading) {
            return CircularProgressIndicator();
          } else {
            print("value.rateEdit----${value.rateEdit}");
            print("baglist length...........${value.salebagList.length}");
            return Provider.of<Controller>(context, listen: false)
                        .salebagList
                        .length ==
                    0
                ? Container(
                    height: size.height * 0.9,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "asset/empty.png",
                            height: 80,
                            color: P_Settings.salewaveColor,
                            width: 100,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Text(
                            "Your cart is empty !!!",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("View products"))
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Colors.transparent),
                              ),
                              onPressed: () {},
                              child: Text(
                                "${value.count} Items",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: P_Settings.collectionbuttnColor),
                              ),
                            ),
                            Spacer(),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0,
                                      color: P_Settings.collectionbuttnColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Add Items",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            P_Settings.collectionbuttnColor))),
                          ],
                        ),
                      ),
                      // Divider(thickness: 2,),
                      Expanded(
                        child: ListView.builder(
                          itemCount: value.salebagList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return listItemFunction(
                              value.salebagList[index]["cartrowno"],
                              value.salebagList[index]["itemName"],
                              value.salebagList[index]["hsn"],
                              value.salebagList[index]["rate"],
                              value.salebagList[index]["discount_per"],
                              value.salebagList[index]["discount_amt"],
                              value.salebagList[index]["ces_per"],
                              value.salebagList[index]["ces_amt"],
                              value.salebagList[index]["net_amt"],
                              value.salebagList[index]["totalamount"],
                              value.salebagList[index]["qty"],
                              size,
                              value.controller[index],
                              index,
                              value.salebagList[index]["code"],
                              value.salebagList[index]["tax_per"].toString(),
                              value.salebagList[index]["tax_amt"],
                              value.salebagList[index]["unit_name"],
                              value.salebagList[index]["package"],

                              // value.salebagList[index]["discount"].toString(),
                              // value.salebagList[index]["ces_amt"],
                              // value.salebagList[index]["ces_a"].toString(),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: size.height * 0.07,
                        child: Row(
                          children: [
                            Container(
                              width: size.width,
                              height: size.height * 0.07,
                              color: P_Settings.roundedButtonColor,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(" Sales Total : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Flexible(
                                      child: Text(
                                          "\u{20B9}${value.salesTotal.toStringAsFixed(2)} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.07,
                        // color: Colors.yellow,
                        child: Row(
                          children: [
                            Container(
                              width: size.width, //size.width * 0.6,
                              height: size.height * 0.07,
                              color: P_Settings.roundedButtonColor,
                              // Color.fromARGB(255, 212, 224, 233),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(" Disc : "),
                                    Flexible(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "%",
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              // borderRadius:
                                              //     BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 5, 5, 5),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              // borderRadius:
                                              //     BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 5, 5, 5),
                                                width: 1.0,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              // borderRadius:
                                              //     BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                                width: 3,
                                              ),
                                            ),
                                            hintText: "%"),
                                        controller: discPerCtrl,
                                        onChanged: (value) async {
                                          if (value.isEmpty) {
                                            setState(() {
                                              discInRupee = 0.00;
                                              discRupeeCtrl.clear();
                                            });
                                            await calcDiscount(0.0);
                                          }
                                        },
                                        // onFieldSubmitted: (value) {
                                        //   convertToRupee(
                                        //       discPerCtrl.text.toString().trim(),
                                        //       "per");
                                        //   setState(() {});
                                        // },
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "₹",
                                            filled: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              // borderRadius:
                                              //     BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 5, 5, 5),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              // borderRadius:
                                              //     BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 5, 5, 5),
                                                width: 1.0,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              // borderRadius:
                                              //     BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                                width: 3,
                                              ),
                                            ),
                                            hintText: "₹"),
                                        controller: discRupeeCtrl,
                                        onChanged: (value) async {
                                          if (value.isEmpty) {
                                            setState(() {
                                              discInRupee = 0.00;
                                              discPerCtrl.clear();
                                            });
                                            await calcDiscount(0.00);
                                          }
                                        },
                                        // onFieldSubmitted: (value) {
                                        //   convertToRupee(
                                        //       discRupeeCtrl.text
                                        //           .toString()
                                        //           .trim(),
                                        //       "rupee");
                                        //   setState(() {});
                                        // },
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Flexible(
                                        child: IconButton(
                                            onPressed: () async {
                                              if (discPerCtrl.text
                                                      .toString()
                                                      .trim()
                                                      .isEmpty &&
                                                  discRupeeCtrl.text
                                                      .toString()
                                                      .trim()
                                                      .isEmpty) {
                                                await calcDiscount(0.0);
                                                CustomSnackbar snackbar =
                                                    CustomSnackbar();
                                                snackbar.showSnackbar(
                                                    context,
                                                    "Must enter discount amount",
                                                    "");
                                              } else if (discPerCtrl.text
                                                      .toString()
                                                      .trim()
                                                      .isNotEmpty &&
                                                  discRupeeCtrl.text
                                                      .toString()
                                                      .trim()
                                                      .isNotEmpty) {
                                                CustomSnackbar snackbar =
                                                    CustomSnackbar();
                                                snackbar.showSnackbar(
                                                    context,
                                                    "Dont enter % and amount together",
                                                    "");
                                              } else if (discPerCtrl
                                                  .text.isNotEmpty) {
                                                convertToRupee(
                                                    discPerCtrl.text
                                                        .toString()
                                                        .trim(),
                                                    "per");
                                              } else if (discRupeeCtrl
                                                  .text.isNotEmpty) {
                                                convertToRupee(
                                                    discRupeeCtrl.text
                                                        .toString()
                                                        .trim(),
                                                    "rupee");
                                              }
                                            },
                                            icon: Icon(
                                              Icons.done,
                                              color: Colors.green,
                                            )))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      GestureDetector(
                        child: Container(
                          height: size.height * 0.07,
                          color: Colors.yellow,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.5,
                                height: size.height * 0.07,
                                color: Colors.yellow,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(" Net Total  : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Flexible(
                                      child: Text(
                                        "\u{20B9}${Provider.of<Controller>(context, listen: false).totalAftrdiscount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (() async {
                                  // value.areDetails.clear();
                                  if (discPerCtrl.text.isNotEmpty &&
                                          discInRupee == 0.00 ||
                                      discRupeeCtrl.text.isNotEmpty &&
                                          discInRupee == 0.00) {
                                    print("improper calc");
                                    CustomSnackbar snak = CustomSnackbar();
                                    snak.showSnackbar(
                                        context,
                                        "Click tick mark to calculate Discount",
                                        "");
                                  } else {
                                    if (discPerCtrl.text.isEmpty &&
                                        discRupeeCtrl.text.isEmpty &&
                                        value.salesTotal !=
                                            value.totalAftrdiscount) {
                                      value.totalAftrdiscount =
                                          value.salesTotal;
                                    }
                                    if (value.salebagList.length > 0) {
                                      print(
                                          "baserate on save-----${value.orderTotal2[11].toString()}");
                                      print(
                                          "discPerCtrl.text----------------${discPerCtrl.text}");
                                      print(
                                          "disc in rupee----------------${discInRupee}");
                                      print(
                                          "totalaftrDisc----------------${value.totalAftrdiscount}");      
                                      paysheet.showpaymentSheet(
                                          context,
                                          widget.areaId,
                                          widget.areaname,
                                          widget.custmerId,
                                          s[0],
                                          s[1],
                                          " ",
                                          " ",
                                          value.orderTotal2[11],
                                          widget.branch_id,
                                          double.tryParse(discPerCtrl.text) ??
                                              0.00,
                                          discInRupee,
                                          value.totalAftrdiscount,"salecart");
                                    }
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .count = "0";
                                    print("area name ${widget.areaname}");
                                  }
                                  // Provider.of<Controller>(context,listen: false).saveOrderDetails(id, value.cid!, series, orderid,  widget.custmerId, orderdate, staffid, widget.areaId, pcode, qty, rate, context)
                                }),
                                child: Container(
                                  width: size.width * 0.5,
                                  height: size.height * 0.07,
                                  color: Colors.green,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Save",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Icon(Icons.shopping_basket)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
          }
        }),
      )),
    );
  }

  calcDiscount(double discamt) {
    double discval = double.parse(discamt.toString());
    double totval = Provider.of<Controller>(context, listen: false).salesTotal;
    if (discamt == 0.00) {
      discInRupee = 0.00;
      Provider.of<Controller>(context, listen: false).totalAftrdiscount =
          totval;
    } else {
      Provider.of<Controller>(context, listen: false).totalAftrdiscount =
          totval - discval;
    }

    setState(() {});
  }

  convertToRupee(String val, String wgttype) {
    double net =
        Provider.of<Controller>(context, listen: false).salesTotal ?? 0;
    double amt = double.tryParse(val) ?? 0;
    if (wgttype == "rupee") {
      discInRupee = amt;
      double dper = discInRupee * (100 / net);
      discInPercentage = dper.toStringAsFixed(3);
      discPerCtrl.text = discInPercentage;
    } else {
      discInRupee = net * (amt / 100);
      discInRupee = double.parse(discInRupee.toStringAsFixed(3));
      discRupeeCtrl.text = discInRupee.toString();
    }
    calcDiscount(discInRupee);
    // deductionCalulate(moistInkg, type);
    print("% or amt= $amt \nNet = $net\n discInRupee  =$discInRupee");
    print("Disc in Rupee---${discInRupee.toString()}");
    setState(() {});
    // setState(() {});
  }

  Widget listItemFunction(
      int cartrowno,
      String itemName,
      String hsn,
      double rate,
      double disc_per,
      double disc_amt,
      double cess_per,
      double cess_amt,
      double net_amt,
      double gross,
      double qty,
      Size size,
      TextEditingController _controller,
      int index,
      String code,
      String tax,
      double tax_amt,
      String unit_name,
      double pkg
      // String discount,
      ) {
    print("qty net-------$net_amt...$tax_amt");
    _controller.text = qty.toString();

    return Consumer<Controller>(
      builder: (context, value, child) {
        return Container(
          height: size.height * 0.2,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
            child: Ink(
              // color: Colors.grey[100],
              decoration: BoxDecoration(
                color: Colors.grey[100],
                // borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: () {
                  print("net amount............$net_amt");
                  Provider.of<Controller>(context, listen: false).fromDb = true;
                  value.salesqty[index].text = qty.toStringAsFixed(1);
                  value.salesrate[index].text = rate.toStringAsFixed(2);
                  value.discount_prercent[index].text =
                      disc_per.toStringAsFixed(4);
                  value.discount_amount[index].text =
                      disc_amt.toStringAsFixed(2);

                  saleDetails.showsalesMoadlBottomsheet(
                    itemName,
                    code,
                    hsn,
                    qty,
                    rate,
                    disc_per,
                    disc_amt,
                    double.parse(tax),
                    tax_amt,
                    cess_per,
                    cess_amt,
                    net_amt,
                    gross,
                    context,
                    size,
                    index,
                    widget.custmerId,
                    widget.os,
                    pkg,
                    unit_name,
                    widget.branch_id,
                  );
                  // setState(() {
                  Provider.of<Controller>(context, listen: false)
                          .totalAftrdiscount =
                      Provider.of<Controller>(context, listen: false)
                          .salesTotal;
                  // });
                },
                // leading: CircleAvatar(backgroundColor: Colors.green),
                title: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     bottom: 8.0,
                          //   ),
                          //   child: Container(
                          //     height: size.height * 0.3,
                          //     width: size.width * 0.2,
                          //     child: Image.asset(
                          //       "asset/noImage.jpg",
                          //       fit: BoxFit.cover,
                          //     ),
                          //     // child: Image.network(
                          //     //   'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                          //     //   fit: BoxFit.cover,
                          //     // ),
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: size.width * 0.05,
                          //   height: size.height * 0.001,
                          // ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      // flex: 3,
                                      child: Text(
                                        "${itemName} ",
                                        // "dbhjsdbhjsb sdsdbsdbfd fsdfbjsdbfjd snfbjhsdbfh",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: P_Settings.wavecolor),
                                      ),
                                    ),
                                    Flexible(
                                      // flex: 3,
                                      child: Text(
                                        " (${code})",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 4, top: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Rate   :",
                                              style: TextStyle(fontSize: 13),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              "\u{20B9}${rate}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ), // Row(

                                        Row(
                                          children: [
                                            Text(
                                              "Discount:",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.03,
                                            ),
                                            Container(
                                              child: Text(
                                                " \u{20B9}${disc_amt.toStringAsFixed(2)}",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Qty     :",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Container(
                                            child: Text(
                                              "${qty.toString()} (${unit_name.toString()}) (${pkg.toString()})",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Tax  :",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.03,
                                          ),
                                          Container(
                                            child: Text(
                                              " \u{20B9}${tax_amt.toStringAsFixed(2)}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Gross:",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Container(
                                            child: Text(
                                              "\u{20B9}${gross.toStringAsFixed(2)}",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Cess :",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Container(
                                            child: Text(
                                              "\u{20B9}${cess_amt.toStringAsFixed(2)}",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 182, 179, 179),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 7,
                      ),
                      child: Container(
                        height: size.height * 0.03,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.grey[100]),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                              "Do you want to delete ($code) ???"),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              P_Settings
                                                                  .wavecolor),
                                                  onPressed: () async {
                                                    await OrderAppDB.instance
                                                        .deleteFromTableCommonQuery(
                                                            "salesBagTable",
                                                            "customerid='${widget.custmerId}' AND cartrowno=$cartrowno");
                                                    await Provider.of<
                                                                Controller>(
                                                            context,
                                                            listen: false)
                                                        .calculatesalesTotal(
                                                            widget.os,
                                                            widget.custmerId);
                                                    Provider.of<Controller>(
                                                            context,
                                                            listen: false)
                                                        .getSaleBagDetails(
                                                            widget.custmerId,
                                                            widget.os,
                                                            "",
                                                            context,
                                                            "",
                                                            "",
                                                            widget.branch_id);
                                                    Provider.of<Controller>(
                                                            context,
                                                            listen: false)
                                                        .getSaleProductList(
                                                            widget.custmerId,
                                                            context);
                                                    Provider.of<Controller>(
                                                            context,
                                                            listen: false)
                                                        .countFromTable(
                                                      "salesBagTable",
                                                      widget.os,
                                                      widget.custmerId,
                                                    );
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text(
                                                    "Ok",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.03),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              P_Settings
                                                                  .wavecolor),
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: P_Settings.extracolor,
                                    ),
                                    label: Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.black),
                                    ))
                              ],
                            ),
                            Spacer(),
                            Text(
                              "Total price : ",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            rate < disc_amt
                                ? Text(
                                    "0.00",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black),
                                  )
                                : Text(
                                    "\u{20B9}${net_amt.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//////////////////////////////////////////////////////////////////////
}
