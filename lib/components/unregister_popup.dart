import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlorder24/screen/NEWPAGES/nextscreen.dart';
import 'package:sqlorder24/screen/ORDER/1_companyRegistrationScreen.dart';
import 'package:sqlorder24/screen/ORDER/externalDir.dart';

class Unreg {
  ExternalDir externalDir = ExternalDir();
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('company_id');
        await prefs.remove("continueClicked");
        await prefs.remove("staffLog");
        await prefs.remove("st_username");
        // await prefs.remove("versof");
        await prefs.remove("st_pwd");
        await externalDir.deleteFile();
        print("Everything cleared");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(
                // temp: temp!,
                ),
          ),
        );
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to unregister!!"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
