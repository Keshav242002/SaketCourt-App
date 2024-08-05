import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../utils/constants.dart';

void myLogoAlert(
    {required BuildContext context,
      required String message,
      required bool navigateEnabled,
      required String route}) {
  Alert(
      context: context,
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          message,
          style: kListNameStyle,
          textAlign: TextAlign.center,
        ),
      ),

      buttons: [
        DialogButton(
          // gradient: const LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     kColorRed,
          //     kColorWhite,
          //   ],
          // ),
            color: kColorRed,
            onPressed: () {
              if (navigateEnabled) {
                Navigator.pop(context);
                Navigator.pushNamed(context, route);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
      ]).show();
}
