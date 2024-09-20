import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shop/components/customtextfield.dart';
import 'package:shop/components/materialbutton.dart';
import 'package:shop/note/view.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  bool isLoading = false;
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  Future<void> cateAdd() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection('note');
    // Call the user's CollectionReference to add a new user
    isLoading = true;
    setState(() {});

    try {
      await notes.add({
        'note': note.text,
      });
      isLoading = false;
      setState(() {});

      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'note Added',
        desc: 'The note added successfully',
        btnOkOnPress: () {},
      ).show();
    } catch (error) {
      isLoading = false;
      setState(() {});

      print('Error adding note: $error');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to add note: $error',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('home', (route) => false);

            setState(() {});
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formState,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    CustomTextField(
                      text: '',
                      hintText: 'Enter note title',
                      controller: note,
                      validator: (value) {
                        if (value == '') {
                          return 'note name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'Add',
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          await cateAdd();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (c) => NoteView(
                                        categoryid: widget.docid,
                                      )));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
