import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final String path;
  const CustomLogo({required this.path});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.grey[400]),
        child: Image.asset(
          path,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
