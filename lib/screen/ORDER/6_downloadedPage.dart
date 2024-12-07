import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlorder24/components/commoncolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlorder24/db_helper.dart';
import 'package:sqlorder24/service/tableList.dart';
import '../../controller/controller.dart';

class DownloadedPage extends StatefulWidget {
  String? type;
  String? title;
  final BuildContext context;
  DownloadedPage({this.type, this.title, required this.context});

  @override
  State<DownloadedPage> createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  String? cid;
  String? sid;
  String? bid;
  String? userType;
  String? formattedDate;
  List s = [];
  DateTime date = DateTime.now();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String? db;
  String? ip;
  String? port;
  String? un;
  String? pw;

  List<String> downloadItems = [
    "Download All",
    "Account Heads",
    "Product Details",
    "Product category",
    "Company",
    "Wallet",
    "Area",
    "Staff",
    "Product units",
    "Settings",
    "Stock"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getSecondDBDetails();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    s = formattedDate!.split(" ");
    Provider.of<Controller>(context, listen: false).isDown =
        List.generate(downloadItems.length, (index) => false);

    getCid();
  }

  // void initPlatformState() async {
  //   BackgroundMode.start();
  //   print("background download");
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     print("download data");
  //     // Provider.of<Controller>(context, listen: false)
  //     //     .getaccountHeadsDetails(context, s[0], cid!);
  //     // Provider.of<Controller>(context, listen: false).getProductCompany(cid!);
  //     // Provider.of<Controller>(context, listen: false).getProductCategory(cid!);
  //     Provider.of<Controller>(context, listen: false).getWallet(context);
  //     BackgroundMode.disable();
  //     BackgroundMode.bringToForeground();
  //   });
  // }
  getSecondDBDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    db = prefs.getString("conDb");
    ip = prefs.getString("conIp");
    port = prefs.getString("conPort");
    un = prefs.getString("conUsr");
    pw = prefs.getString("conPass");
    print("++++ $db---$ip----$port----$un------$pw");
  }

  getCid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = prefs.getString("cid");
    userType = prefs.getString("userType");
    sid = prefs.getString("sid");
    bid = prefs.getString("br_id");
    // initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      appBar: widget.type == ""
          ? AppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 25, top: 12),
                  child: GestureDetector(
                    onLongPress: () async {
                      List<Map<String, dynamic>> list =
                          await OrderAppDB.instance.getListOfTables();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TableList(list: list)),
                      );
                    },
                    child: Icon(
                      Icons.donut_large_outlined,
                      color: Colors.black12,
                    ),
                  ),
                )
              ],
              backgroundColor: P_Settings.wavecolor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(6.0),
                child: Consumer<Controller>(
                  builder: (context, value, child) {
                    if (value.isLoading) 
                    {
                      return LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: P_Settings.wavecolor,

                        // valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                        // value: 0.25,
                      );
                    } 
                    else 
                    {
                      return Container();
                    }
                  },
                ),
              ),
              // title: Text("Company Details",style: TextStyle(fontSize: 20),),
            )
          : null,
      body: Consumer<Controller>(
        builder: (context, value, child) {
          // print("value.sof-----${value.sof}");
          return Column(
            children: [
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     primary: P_Settings.wavecolor,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10), // <-- Radius
              //     ),
              //   ),
              //   onPressed: () {
              //     initPlatformState();
              //   },
              //   child: Text("Auto Download"),
              // ),
              Flexible(
                child: Container(
                  height: size.height * 0.9,
                  child: ListView.builder(
                    itemCount: downloadItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: P_Settings.wavecolor),
                          child: ListTile(
                            trailing: IconButton(
                              onPressed:
                                  //  value.versof == "0"
                                  //     ? null
                                  //     :
                                  value.isDownloaded
                                      ? null
                                      : value.isDown[index]
                                          ? null
                                          : () async {
                                              // SharedPreferences prefs =
                                              //     await SharedPreferences
                                              //         .getInstance();
                                              // prefs.setBool("isautodownload", true);
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .isautodownload = false;
                                              print("time delay inside");
                                              if (downloadItems[index] ==
                                                  "Download All") {
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterDataALL(
                                                        context, index, "all");
                                                //  Provider.of<Controller>(context,
                                                // listen: false)
                                                // .getMasterData("products",
                                                //     context, index, "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData(
                                                //     "itemcategory",
                                                //     context,
                                                //     index,
                                                //     "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData(
                                                //     "itemcompany",
                                                //     context,
                                                //     index,
                                                //     "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData("wallet",
                                                //     context, index, "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData("area",
                                                //     context, index, "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData("staff",
                                                //     context, index, "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData("units",
                                                //     context, index, "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData("settings",
                                                //     context, index, "all");
                                                //      Provider.of<Controller>(context,
                                                //     listen: false)
                                                // .getMasterData("stock",
                                                //     context, 0, "all");
                                              }
                                              if (downloadItems[index] ==
                                                  "Account Heads") 
                                              {
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("customer",
                                                        context, index, "");
                                                print("s[0]===${s[0]}");
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getaccountHeadsDetails(
                                                //         context,
                                                //         s[0],
                                                //         cid!,
                                                //         index);
                                              }
                                              if (downloadItems[index] ==
                                                  "Product category") {
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getProductCategory(
                                                //         cid!, index);
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData(
                                                        "itemcategory",
                                                        context,
                                                        index,
                                                        "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Company") 
                                              {
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getProductCompany(
                                                //         cid!, index);
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData(
                                                        "itemcompany",
                                                        context,
                                                        index,
                                                        "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Product Details") {
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getProductDetails(
                                                //         cid!, index);
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("products",
                                                        context, index, "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Wallet") {
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getWallet(context, index);
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("wallet",
                                                        context, index, "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Area") {
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getAreaDetails(
                                                //         cid!, index, "");
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("area",
                                                        context, index, "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Staff") {
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("staff",
                                                        context, index, "");
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getStaffDetails(
                                                //         cid!, index, "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Product units") {
                                                // Provider.of<Controller>(context,
                                                //         listen: false)
                                                //     .getProductUnits(
                                                //         cid!, index);
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("units",
                                                        context, index, "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Settings") {
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("settings",
                                                        context, index, "");
                                              }
                                              if (downloadItems[index] ==
                                                  "Stock") {
                                                Provider.of<Controller>(context,
                                                        listen: false)
                                                    .getMasterData("stock",
                                                        context, 0, "");
                                              }

                                              // Stock
                                              //   Provider.of<Controller>(context,
                                              //     listen: false)
                                              // .getMasterData(
                                              //     "stock", context, 0, "company details");
                                            },
                              icon: Icon(Icons.download),
                              color: Colors.white,
                            ),
                            title: Center(
                                child: Text(
                              downloadItems[index],
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // value.versof == "0"
              //     ? Container(
              //         height: size.height * 0.2,
              //         child: Text(
              //           "Invalid Registration!!!",
              //           style: TextStyle(fontSize: 18, color: Colors.red),
              //         ),
              //       )
              //     : Container()
            ],
          );
        },
      ),
    );
  }
}
