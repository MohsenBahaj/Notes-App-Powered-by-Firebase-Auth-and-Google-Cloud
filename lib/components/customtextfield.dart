import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextField(
      {super.key,
      required this.text,
      required this.hintText,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (text != '')
          Container(
            height: 15,
          ),
        if (text != '')
          Text(text,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        if (text != '')
          SizedBox(
            height: 10,
          ),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              hintStyle: TextStyle(color: Colors.grey[500]),
              hintText: hintText,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 184, 184, 184)),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: BorderSide(color: Colors.grey))),
        ),
      ]),
    );
  }
}
