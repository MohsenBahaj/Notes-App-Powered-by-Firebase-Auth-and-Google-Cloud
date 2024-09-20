import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class GoogleCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGoogleButton;

  const GoogleCustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isGoogleButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGoogleButton
        ? SignInButton(
            Buttons.Google,
            onPressed: onPressed,
            text: text,
          )
        : MaterialButton(
            height: 60,
            onPressed: onPressed,
            color: Colors.orange,
            textColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text),
                SizedBox(width: 10), // Add some spacing
                Icon(
                    Icons.arrow_forward), // Add an arrow icon or any other icon
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          );
  }
}
