
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {required this.title,
        required this.color,
        required this.onPressed,
        required this.width});

  final Color color;
  final String title;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ConstrainedBox(
        constraints:
        //BoxConstraints.tightFor(width: 120, height: 50),
        BoxConstraints.expand(height: 40, width: width),
        child: ElevatedButton(
          onPressed: () {
            return onPressed();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: kColorWhite),
            ),
          ),
        ),
      ),
    );
  }
}
