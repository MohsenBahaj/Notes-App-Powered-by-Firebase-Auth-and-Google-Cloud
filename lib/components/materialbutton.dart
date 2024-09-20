import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key); // Fixed the key syntax

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 60,
      onPressed: onPressed,
      color: Colors.orange,
      textColor: Colors.white,
      child: Text(text),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}
