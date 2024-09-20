import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/note/add.dart';
import 'package:shop/note/edit.dart';

// Ensure you import your EditCate file

class NoteView extends StatefulWidget {
  final String? categoryid;

  NoteView({Key? key, required this.categoryid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = false;

  getData() async {
    isLoading = true;
    QuerySnapshot? querySnapshot;
    setState(() {});
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryid)
          .collection('note')
          .get();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
    data = querySnapshot!.docs;
    setState(() {});
    print(data);
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(docid: widget.categoryid!)));
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.isEmpty
              ? Center(
                  child: Text('No Notes'),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                      height: 50,
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(
                              0.3), // Temporary color to visualize height
                      child: InkWell(
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Delete',
                            desc:
                                'Are you sure to delete ${data[index]['note']} folder',
                            btnOkText: 'Delete',
                            btnCancelText: 'Rename',
                            btnOkColor: Colors.red,
                            btnCancelColor: Colors.green,
                            btnCancelOnPress: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNote(
                                  notedocid: data[index].id,
                                  oldname: data[index]['note'],
                                  categoryid: widget.categoryid!,
                                ),
                              ));
                            },
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(widget.categoryid)
                                  .collection('note')
                                  .doc(data[index].id)
                                  .delete();
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Successfully',
                                desc: 'The folder deleted successfully',
                                btnOkOnPress: () {
                                  setState(() {
                                    getData();
                                  });
                                },
                              )..show();
                            },
                          )..show();
                        },
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Display(categoryid: categoryid)));
                        },
                        child: SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.notes, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data[index]['note'],
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '2:40 pm',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
