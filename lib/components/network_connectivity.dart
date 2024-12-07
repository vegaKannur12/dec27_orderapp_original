import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetConnection {
  static Future<bool> networkConnection(
      BuildContext context, String type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      final snackBar;
      if (type != "bal") {
        final snackBar = SnackBar(
          content: Text('No internet connection'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
      }

      // final snackBar1 = SnackBar(
      //   content: Text('No internet connection'),
      //   action: SnackBarAction(
      //     label: 'Undo',
      //     onPressed: () {
      //       // Some code to undo the change.
      //     },
      //   ),
      // );
      print("Select a date");
      return false;
    }
    return false;
  }
}
