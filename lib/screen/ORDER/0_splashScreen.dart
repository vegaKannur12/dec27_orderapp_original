import 'package:flutter/material.dart';
import 'package:sqlorder24/components/commoncolor.dart';
import 'package:sqlorder24/controller/controller.dart';
import 'package:sqlorder24/db_helper.dart';
import 'package:sqlorder24/screen/ADMIN_/adminController.dart';
import 'package:sqlorder24/screen/NEWPAGES/nextscreen.dart';
import 'package:sqlorder24/screen/ORDER/0_dashnew.dart';
import 'package:sqlorder24/screen/ORDER/1_companyRegistrationScreen.dart';
import 'package:sqlorder24/screen/ORDER/2_companyDetailsscreen.dart';
import 'package:sqlorder24/screen/ORDER/3_staffLoginScreen.dart';
import 'package:sqlorder24/screen/ORDER/externalDir.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String? cid;
  String? fp;
  bool? isautodownload;
  String? userType;
  String? firstMenu;
  // String? versof;
  bool? continueClicked;
  bool? staffLog;
  String? dataFile;
  String? os;
  String? st_uname;
  String? st_pwd;
  String? com_cid;
  String? tempFp1;
  ExternalDir externalDir = ExternalDir();
  Map<String, dynamic>? temp ;

  navigate() async {
    temp = await externalDir.fileRead();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = prefs.getString("company_id");
    os = prefs.getString("os");
    userType = prefs.getString("user_type");
    st_uname = prefs.getString("st_username");
    // versof = prefs.getString("versof");
    st_pwd = prefs.getString("st_pwd");
    firstMenu = prefs.getString("firstMenu");
    com_cid = prefs.getString("cid");
    isautodownload = prefs.getBool("isautodownload");
    continueClicked = prefs.getBool("continueClicked");
    staffLog = prefs.getBool("staffLog");
    print("st-----$st_uname---$st_pwd");
    print("continueClicked..........$staffLog......$continueClicked");

    if (cid != null) {
      Provider.of<Controller>(context, listen: false).cid = cid;
    }
    if (firstMenu != null) {
      Provider.of<Controller>(context, listen: false).menu_index = firstMenu;

      print(
          "menu index from splash----->${Provider.of<Controller>(context, listen: false).menu_index}");
    }

  

    await Future.delayed(Duration(seconds: 3), () async {
      print("->${temp}");
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) 
              {
                print("data from file------------$temp----");
                if (temp != null && temp!.isNotEmpty && temp != {} && cid!=null) {
                  if (st_uname != null &&
                      st_pwd != null &&
                      staffLog != null &&
                      staffLog!) {
                    return Dashboard();
                  } else {
                    return StaffLogin();
                  }
                  // return Dashboard();
                  // // StaffLogin();
                }
                 else 
                {
                  print("not valid user");
                  return NextPage();
                }
              }));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    // Provider.of<Controller>(context, listen: false).getfilefromStorage();
    navigate();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: P_Settings.wavecolor,
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
                width: 200,
                child: Image.asset(
                  "asset/logo_black_bg.png",
                )),
          ],
        )),
      ),
    );
  }
}
