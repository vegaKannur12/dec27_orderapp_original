import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlorder24/components/commoncolor.dart';
import 'package:sqlorder24/components/customSnackbar.dart';
import 'package:sqlorder24/controller/controller.dart';
import 'package:sqlorder24/db_helper.dart';
import 'package:sqlorder24/screen/ORDER/1_companyRegistrationScreen.dart';
import 'package:sqlorder24/screen/ORDER/externalDir.dart';
import 'package:sqlorder24/service/tableList.dart';

class NextPage extends StatefulWidget {
  // final Map<String, dynamic> temp;
  const NextPage({
    super.key,
  });
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  ExternalDir externalDir = ExternalDir();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            onPressed: () async {
              List<Map<String, dynamic>> list =
                  await OrderAppDB.instance.getListOfTables();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableList(list: list)),
              );
            },
            icon: Icon(
              Icons.table_bar,
              color: Colors.black26,
            ),
          ),
        ],
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: size.height * 0.4,
            ),
            Container(
                height: 200,
                width: size.width * 0.9,
                child: Center(
                    child: Column(
                  children: [
                    InkWell(
                      onLongPress: () async {
                        Map<String, dynamic>? temp =
                            await externalDir.fileRead();
                        String? db = "";
                        String? ip = "";
                        String? port = "";
                        String? un = "";
                        String? pw = "";
                        TextEditingController dbc = TextEditingController();
                        TextEditingController ipc = TextEditingController();
                        TextEditingController usrc = TextEditingController();
                        TextEditingController portc = TextEditingController();
                        TextEditingController pwdc = TextEditingController();
                        bool pressed = false;
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        if (temp != null && temp.isNotEmpty && temp != {}) {
                          if (temp["DB"].toString().isNotEmpty &&
                              temp["DB"].toString().toLowerCase() != "null" &&
                              temp["DB"].toString() != "" &&
                              temp["IP"].toString().isNotEmpty &&
                              temp["IP"].toString().toLowerCase() != "null" &&
                              temp["IP"].toString() != "" &&
                              temp["PORT"].toString().isNotEmpty &&
                              temp["PORT"].toString().toLowerCase() != "null" &&
                              temp["PORT"].toString() != "" &&
                              temp["USR"].toString().isNotEmpty &&
                              temp["USR"].toString().toLowerCase() != "null" &&
                              temp["USR"].toString() != "" &&
                              temp["PWD"].toString().isNotEmpty &&
                              temp["PWD"].toString().toLowerCase() != "null" &&
                              temp["PWD"].toString() != "") {
                            print("from file from storage");
                            db = temp["DB"];
                            ip = temp["IP"];
                            port = temp["PORT"];
                            un = temp["USR"];
                            pw = temp["PWD"];
                          } else {
                            print("from hardcode");
                            db = "APP_REGISTER";
                            ip = "103.177.225.245";
                            port = "54321";
                            un = "sa";
                            pw = "##v0e3g9a#";
                          }
                        } else {
                          print("from hardcode");
                          db = "APP_REGISTER";
                          ip = "103.177.225.245";
                          port = "54321";
                          un = "sa";
                          pw = "##v0e3g9a#";
                        }
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                        void Function(void Function())
                                            setState) =>
                                    AlertDialog(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          style: ButtonStyle(),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
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
                                            SizedBox(
                                                width: 90, child: Text("DB")),
                                            pressed
                                                ? SizedBox(
                                                    width: 130,
                                                    child: TextFormField(
                                                      controller: dbc,
                                                    ))
                                                : Text(" :  ${db.toString()}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 90, child: Text("IP")),
                                            pressed
                                                ? SizedBox(
                                                    width: 130,
                                                    child: TextFormField(
                                                      controller: ipc,
                                                    ))
                                                : Text(" :  ${ip.toString()}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 90, child: Text("PORT")),
                                            pressed
                                                ? SizedBox(
                                                    width: 130,
                                                    child: TextFormField(
                                                      controller: portc,
                                                    ))
                                                : Text(" :  ${port.toString()}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 90,
                                                child: Text("USERNAME")),
                                            pressed
                                                ? SizedBox(
                                                    width: 130,
                                                    child: TextFormField(
                                                      controller: usrc,
                                                    ))
                                                : Text(" :  ${un.toString()}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 90,
                                                child: Text("PASSWORD")),
                                            pressed
                                                ? SizedBox(
                                                    width: 130,
                                                    child: TextFormField(
                                                      controller: pwdc,
                                                    ))
                                                : Text(" :  ${pw.toString()}")
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            pressed = true;
                                          });

                                          dbc.text = db.toString();
                                          ipc.text = ip.toString();
                                          portc.text = port.toString();
                                          usrc.text = un.toString();
                                          pwdc.text = pw.toString();
                                          print("pressed---$pressed");
                                        },
                                        icon: Icon(Icons.edit)),
                                    pressed
                                        ? TextButton(
                                            onPressed: () async {
                                              Map<String, dynamic> dbMap = {};
                                              dbMap["IP"] = ipc.text.toString();
                                              dbMap["PORT"] =
                                                  portc.text.toString();
                                              dbMap["DB"] = dbc.text.toString();
                                              dbMap["USR"] =
                                                  usrc.text.toString();
                                              dbMap["PWD"] =
                                                  pwdc.text.toString();
                                              print("EDIT DB Map ---->$dbMap");
                                              if (ipc.text.isNotEmpty &&
                                                  portc.text.isNotEmpty &&
                                                  dbc.text.isNotEmpty &&
                                                  usrc.text.isNotEmpty &&
                                                  pwdc.text.isNotEmpty) {
                                                await externalDir
                                                    .fileWrite(dbMap);
                                              } else {
                                                CustomSnackbar snackbar =
                                                    CustomSnackbar();
                                                snackbar.showSnackbar(
                                                    context, "Empty Data", "");
                                                print("Empty Data");
                                              }

                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(
                                                      false); // dismisses only the dialog and returns false
                                            },
                                            child: Text('UPDATE'),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              );
                            });
                      },
                      child: Text(
                        "Welcome to VPOS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      "Click NEXT to Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 17.0, right: 17),
                      child: SizedBox(
                        height: size.height * 0.06,
                        width: size.width * 1 / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // <-- Radius
                            ),
                          ),
                          onPressed: () async {
                            int con = await Provider.of<Controller>(context,
                                    listen: false)
                                .initPrimaryDb(context);
                            if (con == 1) {
                            } else {
                              CustomSnackbar snackbar = CustomSnackbar();
                              snackbar.showSnackbar(
                                  context, "Error Connecting Database", "");
                              print("NOT connected 1st");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const <Widget>[
                              Text(
                                'NEXT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
          ],
        )),
      ),
    );
  }
}
