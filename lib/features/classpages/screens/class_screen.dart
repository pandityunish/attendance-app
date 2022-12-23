import 'package:attendance_app/features/classpages/repository/classpages_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassScreen extends StatefulWidget {
  static const String routeName = "/Class-screen";
  final String classname;
  final String docsid;
  const ClassScreen({super.key, required this.classname, required this.docsid});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final TextEditingController studentcontroller = TextEditingController();
  final TextEditingController editstudentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "CLASS ${widget.classname}",
            ),
            actions: [
              PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () {},
                      child: const Text(
                        "Copy form Class",
                        style: TextStyle(color: Colors.black),
                      )),
                  PopupMenuItem(
                    onTap: () {},
                    child: const Text(
                      "Form Clipboard",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  PopupMenuItem(
                      onTap: () {},
                      child: const Text(
                        "Change Sorting",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ]),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Student Name"),
                      content: TextFormField(
                        controller: studentcontroller,
                        autofocus: true,
                        autocorrect: true,
                        keyboardType: TextInputType.name,
                        decoration:
                            const InputDecoration(hintText: "Student name"),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Provider.of<ClasspagesRepository>(context,
                                      listen: false)
                                  .addStudents(context, widget.docsid,
                                      studentcontroller.text.trim());
                              studentcontroller.clear();
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"))
                      ],
                    );
                  },
                );
              }),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("School")
              .doc(widget.docsid)
              .collection("Students")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "ADD STUDENTS",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            title: Text(
                              "${data["name"]}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 25),
                            ),
                            trailing: PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          onTap: () {
                                            Future(
                                              () => showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Delete ${data["name"]}"),
                                                      content: const Text(
                                                          "Do you want to delete this student?"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "School")
                                                                  .doc(widget
                                                                      .docsid)
                                                                  .collection(
                                                                      "Students")
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .delete();
                                                            },
                                                            child: const Text(
                                                                "Ok"))
                                                      ],
                                                    );
                                                  }),
                                            );
                                          },
                                          child: const Text("Delete")),
                                      PopupMenuItem(
                                          onTap: () {
                                            Future(
                                              () => showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Edit ${data["name"]}"),
                                                      content: TextFormField(
                                                        initialValue:
                                                            "${data["name"]}",
                                                        controller:
                                                            studentcontroller,
                                                        autofocus: true,
                                                        autocorrect: true,
                                                        keyboardType:
                                                            TextInputType.name,
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText:
                                                                    "Student name"),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "School")
                                                                  .doc(widget
                                                                      .docsid)
                                                                  .collection(
                                                                      "Students")
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                "name":
                                                                    editstudentcontroller
                                                                        .text
                                                                        .trim()
                                                              });
                                                            },
                                                            child: const Text(
                                                                "Ok"))
                                                      ],
                                                    );
                                                  }),
                                            );
                                          },
                                          child: const Text("Edit"))
                                    ])),
                      ),
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
