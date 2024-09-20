import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  const CustomCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(10),
      height: 100,
      child: Column(
        children: [
          Image.asset('Images/folder.png'),
          SizedBox(
            height: 15,
          ),
          Text(name)
        ],
      ),
    ));
  }
}
