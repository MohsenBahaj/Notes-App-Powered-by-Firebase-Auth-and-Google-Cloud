import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Ensure you import your EditCate file

class Display extends StatefulWidget {
  final String categoryid;
  Display({Key? key, required this.categoryid});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  TextEditingController textController = TextEditingController();
  bool isLoading = false;
  List<Map<String, dynamic>> subnotes = [];

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot subnoteQuerySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryid)
          .collection('note')
          .get();

      setState(() {
        subnotes = subnoteQuerySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        textController.text = subnotes.toString();
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error as needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note'),
          actions: [
            IconButton(
              onPressed: () async {
                isLoading = true;
                setState(() {
                  getData();
                });
                await Future.delayed(Duration(milliseconds: 100));
                isLoading = false;
                setState(() {});
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addNotes');
          },
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TextField(
                controller: textController,
              ));
  }
}
