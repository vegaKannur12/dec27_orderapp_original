import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqlorder24/controller/controller.dart';
import 'package:sqlorder24/screen/NEWPAGES/nextscreen.dart';
import 'package:sqlorder24/screen/NEWPAGES/stockreport.dart';
import 'package:sqlorder24/screen/ORDER/0_splashScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlorder24/screen/ORDER/1_companyRegistrationScreen.dart';
import 'package:sqlorder24/screen/ORDER/6_downloadedPage.dart';
import 'package:sqlorder24/screen/ORDER/6_uploaddata.dart';
import 'package:sqlorder24/screen/ORDER/externalDir.dart';
import 'screen/ADMIN_/adminController.dart';
/////////////registration keyyyyyyyyyyyyyyyyy
///FOR SQL -------- VEGADEMOAXVO---ranov---222
////demo -------   FR67RTMNSMSM  user----vega,pwd---vega
///////new key-----4016ZNMNSMVO
//////key-------RA98BHRFSMSM---user----kannur  pwd---1
// void requestPermission() async {
//   var status = await Permission.storage.status;
//   // var statusbl= await Permission.bluetooth.status;

//   var status1 = await Permission.manageExternalStorage.status;

//   if (!status1.isGranted) {
//     await Permission.storage.request();
//   }

//   if (!status1.isGranted) {
//     var status = await Permission.manageExternalStorage.request();
//     if (status.isGranted) {
//       await Permission.bluetooth.request();
//     } else {
//       openAppSettings();
//     }
//     // await Permission.app
//   }
//   if (!status1.isRestricted) {
//     await Permission.manageExternalStorage.request();
//   }
//   if (!status1.isPermanentlyDenied) {
//     await Permission.manageExternalStorage.request();
//   }
// }

 requestPermission() async {
  var sta = await Permission.storage.request();
  var status = Platform.isIOS
      ? await Permission.photos.request()
      : await Permission.manageExternalStorage.request();
  if (status.isGranted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  } else if (status.isRestricted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}
// void permission()async{
//   var camstatus = await Permission.camera.status;
//   var calstatus = await Permission.microphone.status;

//   if(camstatus.isGranted){
//     await Permission.camera.request();
//   }
//   if(calstatus.isGranted){
//     await Permission.microphone.request();
//   }

//   if(await Permission.camera.isGranted){
//     if(await Permission.microphone.isGranted){
//       print("camera oponened");
//     }
//   }

// }

// checkPerm() async {
//   var status = await Permission.bluetooth.status;
//   // var status1 = await Permission.bluetooth.;

//   print("bulsd-------$status");
//   if (status.isGranted) {
//     print("dfnkdjjk");
//     await Permission.bluetooth.request();
//   }

//   if (await Permission.bluetooth.status.isPermanentlyDenied) {
//     openAppSettings();
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cid = prefs.getString("company_id");
  var status = await Permission.storage.status;
//  permission();
  await requestPermission();

  // checkPerm();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
      ChangeNotifierProvider(
        create: (_) => AdminController(),
      ),
    ],
    child: MyApp(),
  ));
  configLoading();
}

///////////////////// background run /////////////////////
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto Mono sample',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // fontFamily: 'OpenSans',
        // primaryColor:Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        // scaffoldBackgroundColor: P_Settings.bodycolor,
        // textTheme: const TextTheme(
        //   headline1: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        //   headline6: TextStyle(
        //     fontSize: 25.0,
        //   ),
        //   bodyText2: TextStyle(
        //     fontSize: 14.0,
        //   ),
        // ),
      ),
      home:
// DownloadedPage(
//             title: "Download Page",
//             type: "drawer call",
//             context: context,
//           ),
      //     Uploaddata(
      //   title: "Upload data",
      //   cid: "VC1001",
      //   type: "drawer call",
      // ),
      // StockReport(),
      SplashScreen(),
      // NextPage(),
      // NextPage(
      //     temp: {
      //   "IP": "103.177.225.245",
      //   "PORT": "54321",
      //   "DB": "APP_REGISTER",
      //   "USR": "sa",
      //   "PWD": "##v0e3g9a#"
      // }
      // ),
      //  RegistrationScreen(),
      builder: EasyLoading.init(),
      // home: MyWaveClipper(),
    );
  }

  ////////////////////////////////
  // Future<void> tryOtaUpdate() async {
  //   try {
  //     //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
  //     OtaUpdate()
  //         .execute(
  //       'https://internal1.4q.sk/flutter_hello_world.apk',
  //       destinationFilename: 'flutter_hello_world.apk',
  //       //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
  //       sha256checksum:
  //           'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
  //     )
  //         .listen(
  //       (OtaEvent event) {
  //         currentEvent = event;
  //         // setState(() => currentEvent = event
  //       },
  //     );
  //     // ignore: avoid_catches_without_on_clauses
  //   } catch (e) {
  //     print('Failed to make OTA update. Details: $e');
  //   }
  // }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
