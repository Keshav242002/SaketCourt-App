import 'package:flutter/material.dart';

void mySnackBar(
    {required BuildContext context,
      required Widget widget,
      required Color backGroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: widget,
      backgroundColor: backGroundColor,
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 50, left: 15, right: 15),
      elevation: 30,
    ),
  );
}
