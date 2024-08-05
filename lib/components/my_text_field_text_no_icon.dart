import 'package:flutter/material.dart';

class MyTextFieldTextNoIcon extends StatelessWidget {
  final String displayLabel;
  final Function onChanged;
  final bool isLast;
  final bool isText;
  final bool isPassword;
  final TextEditingController controller;

  const MyTextFieldTextNoIcon(
      {super.key, required this.isPassword,
        required this.controller,
        required this.isText,
        required this.isLast,
        required this.displayLabel,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextField(
          style: const TextStyle(color: Colors.blue),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            enabled: true,
            labelText: displayLabel,
            labelStyle: const TextStyle(color: Colors.blueGrey),
          ),
          onChanged: (_) => onChanged,
          obscureText: isPassword,
          keyboardType: isText ? TextInputType.text : TextInputType.text,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          controller: controller,
          onSubmitted: (_) => isLast
              ? FocusScope.of(context).unfocus()
              : FocusScope.of(context).nextFocus()),
    );
  }
}
