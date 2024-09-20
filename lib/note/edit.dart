import 'dart:js_interop';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/components/customtextfield.dart';
import 'package:shop/components/materialbutton.dart';
import 'package:shop/note/view.dart';

//----------Run code------------------
//flutter run -d chrome --web-hostname 10.0.2.2 --web-port 53182
//----------Run code------------------

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categoryid;
  final String oldname;

  const EditNote({
    super.key,
    required this.notedocid,
    required this.oldname,
    required this.categoryid,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isLoading = false;
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  Future<void> editNote() async {
    // Call the user's CollectionReference to add a new user
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryid)
        .collection('note');
    isLoading = true;
    // print(widget.notedocid);
    return notes.doc(widget.notedocid).update({
      'note': note.text,
    }).then((value) {
      isLoading = false;
    }).catchError((error) {
      isLoading = false;
    });
  }

  @override
  void initState() {
    note.text = widget.oldname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=>NoteView(categoryid: widget.notedocid,)))

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
                        hintText: 'Enter note Name',
                        controller: note,
                        validator: (value) {
                          if (value == '') {
                            return 'note name is required';
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        text: 'Edit',
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await editNote();
                              setState(() {
                                isLoading = false;
                              });
                              AwesomeDialog(
                                dismissOnTouchOutside: false,
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Modification',
                                desc: 'The note edited successfully',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: ' "Failed to add note: $e"',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            } finally {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (c) => NoteView(
                                            categoryid: widget.categoryid,
                                          )));
                            }
                          }
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
