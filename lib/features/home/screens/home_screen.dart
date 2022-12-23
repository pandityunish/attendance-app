import 'package:attendance_app/common/utiles.dart';
import 'package:attendance_app/features/classpages/screens/class_screen.dart';
import 'package:attendance_app/features/home/repository/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/Homepage";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController classcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      title: const Text("Create Class"),
                      content: TextFormField(
                        autofocus: true,
                        controller: classcontroller,
                        autocorrect: true,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(hintText: "Enter Class"),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (classcontroller.text.isNotEmpty) {
                                Provider.of<HomeRepository>(context,
                                        listen: false)
                                    .createClass(
                                        context, classcontroller.text.trim());

                                Navigator.pop(context);
                                classcontroller.clear();
                              } else {
                                showsnackbar(context, "Please Enter Class");
                              }
                            },
                            child: const Text("Ok"))
                      ],
                    );
                  },
                );
              }),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("School").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center();
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "ADD CLASSROOM AND STUDENTS",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ClassScreen.routeName, arguments: {
                                "classname": data["ClassName"],
                                "docid": snapshot.data!.docs[index].id
                              });
                            },
                            title: Text(
                              "Class ${data["ClassName"]}",
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
                                            Future(() => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Delete Class"),
                                                    content: const Text(
                                                        "Do you want to delete this class?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "School")
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id)
                                                                .delete();
                                                          },
                                                          child:
                                                              const Text("Ok"))
                                                    ],
                                                  );
                                                }));
                                          },
                                          child: const Text("Delete")),
                                      PopupMenuItem(
                                          onTap: () {},
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
