import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sqlorder24/db_helper.dart';
import 'package:sqlorder24/screen/ORDER/externalDir.dart';

class TableList extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  TableList({required this.list});

  @override
  State<TableList> createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  String? db;
  String? ip;
  String? port;
  String? un;
  String? pw;
  ExternalDir externalDir = ExternalDir();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSecondDBDetails();
  }

  getSecondDBDetails() async {
    Map<String, dynamic>? temp = await externalDir.fileRead();
    TextEditingController dbc = TextEditingController();
    TextEditingController ipc = TextEditingController();
    TextEditingController usrc = TextEditingController();
    TextEditingController portc = TextEditingController();
    TextEditingController pwdc = TextEditingController();
    bool pressed = false;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    db = temp!["DB"];
    ip = temp!["IP"];
    port = temp!["PORT"];
    un = temp!["USR"];
    pw = temp!["PWD"];
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // db = prefs.getString("conDb");
    // ip = prefs.getString("conIp");
    // port = prefs.getString("conPort");
    // un = prefs.getString("conUsr");
    // pw = prefs.getString("conPass");
    print("+++++ $db---$ip----$port----$un------$pw");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Of tables"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25, top: 12),
            child: GestureDetector(
              onLongPress: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                                void Function(void Function()) setState) =>
                            AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(false);
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('DB Deatails'),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 90, child: Text("DB")),
                                    Text(" :  ${db.toString()}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 90, child: Text("IP")),
                                    Text(" :  ${ip.toString()}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 90, child: Text("PORT")),
                                    Text(" :  ${port.toString()}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 90, child: Text("USERNAME")),
                                    Text(" :  ${un.toString()}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 90, child: Text("PASSWORD")),
                                    Text(" :  ${pw.toString()}")
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('CONNECT'),
                              onPressed: () async {
                                try {
                                  await SqlConn.connect(
                                      ip: ip.toString(),
                                      port: port.toString(),
                                      databaseName: db.toString(),
                                      username: un.toString(),
                                      password: pw.toString());

                                  if (SqlConn.isConnected) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        content: const Text("Connected"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              color: Colors.green,
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("OK"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        content: const Text("Not Connected"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              color: Colors.green,
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("OK"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      content: Text("${e.toString()}"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            color: Colors.green,
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("OK"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  debugPrint(
                                      "Errorrrrrrrrrrrrrrrrrr------>>>>${e.toString()}");
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Icon(
                Icons.donut_large_outlined,
                color: Colors.black12,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text(
              widget.list[index]["name"],
              style: TextStyle(fontSize: 18),
            ),
            onTap: () async {
              List<Map<String, dynamic>> list = await OrderAppDB.instance
                  .getTableData(widget.list[index]["name"]);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TableContent(
                          tableName: widget.list[index]["name"]
                              .toString()
                              .toUpperCase(),
                          list: list,
                        )),
              );
            },
          );
        }),
      ),
    );
  }
}

/////////////////////////////////////////////
class TableContent extends StatefulWidget {
  String tableName;
  List<Map<String, dynamic>> list;
  TableContent({required this.tableName, required this.list});

  @override
  State<TableContent> createState() => _TableContentState();
}

class _TableContentState extends State<TableContent> {
  String searchkey = "";
  bool isSearch = false;
  String hinttext = "";
  List<Map<String, dynamic>>? newList = [];

  onChangedValue(String value) {
    newList!.clear();

    print("value inside function ---${value}");
    setState(() {
      searchkey = value;
      if (value.isEmpty) {
        isSearch = false;
      } else {
        isSearch = true;
        if (widget.tableName == "registrationTable") {
          newList = widget.list
              .where((cat) =>
                  cat["cid"].toUpperCase().contains(value.toUpperCase()))
              .toList();
        } else if (widget.tableName == "staffDetailsTable") {
          newList = widget.list
              .where((cat) =>
                  cat["sid"].toUpperCase().contains(value.toUpperCase()))
              .toList();
        } else if (widget.tableName == "areaDetailsTable") {
          newList = widget.list
              .where((cat) =>
                  cat["aid"].toUpperCase().contains(value.toUpperCase()))
              .toList();
        } else if (widget.tableName == "accountHeadsTable") {
          newList = widget.list
              .where((cat) =>
                  cat["hname"].toUpperCase().contains(value.toUpperCase()))
              .toList();
        } else if (widget.tableName == "productDetailsTable") {
          newList = widget.list
              .where((cat) =>
                  cat["tax"].toUpperCase().contains(value.toUpperCase()))
              .toList();
        }
      }
    });
    print("new list---${newList}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.tableName == "registrationTable") {
      hinttext = "search with cid";
    } else if (widget.tableName == "staffDetailsTable") {
      hinttext = "search with sid";
    } else if (widget.tableName == "areaDetailsTable") {
      hinttext = "search with aid";
    } else if (widget.tableName == "accountHeadsTable") {
      hinttext = "search with hname";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.tableName}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 60,
              child: TextField(
                onChanged: (value) {
                  onChangedValue(value);
                },
                decoration: InputDecoration(
                  hintText: hinttext,
                  prefixIcon: Icon(Icons.search),
                  // suffix: ElevatedButton(child: Text("search"),
                  // onPressed: (){

                  // },)
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: isSearch ? newList!.length : widget.list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(isSearch
                      ? newList![index].toString()
                      : widget.list[index].toString()),
                );
              },
            ),
          ),
        ],
      ),
      // body:
      // SingleChildScrollView(

      // scrollDirection: Axis.horizontal,
      // child: DataTable(
      //   columns: [
      //     DataColumn(label: Text("id")),
      //     DataColumn(label: Text("barcode")),
      //     DataColumn(label: Text("time")),
      //     DataColumn(label: Text("qty")),
      //     DataColumn(label: Text("")),

      //     // DataColumn(label: Text("id")),
      //   ],
      //   rows: widget.list
      //       .map(
      //         (e) => DataRow(cells: [
      //           DataCell(Text(e["id"].toString())),
      //           DataCell(Text(e["barcode"].toString())),
      //           DataCell(Text(e["time"].toString())),
      //           DataCell(TextField()),
      //           // DataCell(Text(e["qty"].toString())),
      //           DataCell(Icon(Icons.delete)),
      //           // DataCell(TextField())

      //         ]),
      //       )
      //       .toList(),
      // ),
      // ),
    );
  }
}
