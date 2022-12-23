import 'package:attendance_app/common/utiles.dart';
import 'package:attendance_app/features/classpages/repository/classpages_repository.dart';
import 'package:attendance_app/features/classpages/screens/past_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentsAttendanceScreen extends StatefulWidget {
  static const String routeName = "/studentsAttendance";
  final String classname;
  final String docsid;
  const StudentsAttendanceScreen(
      {super.key, required this.classname, required this.docsid});

  @override
  State<StudentsAttendanceScreen> createState() =>
      _StudentsAttendanceScreenState();
}

class _StudentsAttendanceScreenState extends State<StudentsAttendanceScreen> {
  int number = 0;
  bool? isClicked = false;
  String getdocid = "";
  List names = [];
  List namesofabsence = [];
  void addallname(String id, int index) async {
    var data1 = await FirebaseFirestore.instance
        .collection("School")
        .doc(widget.docsid)
        .collection("Students")
        .doc(id)
        .collection("Attendanceofstudent")
        .get();
    setState(() {
      getdocid = data1.docs[index].id;
      // print(data1.docs[index].id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final classrepository =
        Provider.of<ClasspagesRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Class ${widget.classname}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              DateFormat.yMEd().format(DateTime.now()),
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    Future(() => Navigator.pushNamed(
                            context, PastAttendance.routeName,
                            arguments: {
                              "classname": widget.classname,
                              "docid": widget.docsid,
                            }));
                  },
                  child: const Text("Past Attendance"))
            ],
          )
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.save),
            onPressed: () {
              classrepository.addallattendance(context, widget.docsid, names);
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("School")
                  .doc(widget.docsid)
                  .collection("Students")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text(
                            "No Students",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 30),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              leading: IconButton(
                                  onPressed: () async {
                                    if (names.contains(data["name"])) {
                                      showsnackbar(
                                          context, "The student is present");
                                    } else {
                                      if (namesofabsence
                                          .contains(data["name"])) {
                                        namesofabsence.remove(data["name"]);
                                        await FirebaseFirestore.instance
                                            .collection("School")
                                            .doc(widget.docsid)
                                            .collection("Students")
                                            .doc(snapshot.data!.docs[index].id)
                                            .collection("Attendanceofstudent")
                                            .get()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection("School")
                                              .doc(widget.docsid)
                                              .collection("Students")
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .collection("Attendanceofstudent")
                                              .doc(value.docs[index].id)
                                              .delete();
                                        });
                                      } else {
                                        namesofabsence.add(data["name"]);
                                        classrepository.addabsenceofstudent(
                                          context,
                                          widget.docsid,
                                          snapshot.data!.docs[index].id,
                                        );
                                      }
                                      setState(() {});
                                    }
                                  },
                                  icon: namesofabsence.contains(data["name"])
                                      ? const Icon(
                                          Icons.close,
                                          color: Colors.blue,
                                        )
                                      : const Icon(
                                          Icons.remove_circle_outline_sharp,
                                          color: Colors.black,
                                        )),
                              trailing: IconButton(
                                  onPressed: () async {
                                    if (namesofabsence.contains(data["name"])) {
                                      showsnackbar(
                                          context, "The student is absent");
                                    } else {
                                      if (names.contains(data["name"])) {
                                        names.remove(data["name"]);
                                        namesofabsence.remove(data["name"]);
                                        await FirebaseFirestore.instance
                                            .collection("School")
                                            .doc(widget.docsid)
                                            .collection("Students")
                                            .doc(snapshot.data!.docs[index].id)
                                            .collection("Attendanceofstudent")
                                            .get()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection("School")
                                              .doc(widget.docsid)
                                              .collection("Students")
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .collection("Attendanceofstudent")
                                              .doc(value.docs[index].id)
                                              .delete();
                                        });
                                      } else {
                                        names.add(data["name"]);

                                        classrepository.addattendanceofstudent(
                                          context,
                                          widget.docsid,
                                          snapshot.data!.docs[index].id,
                                        );
                                      }
                                      setState(() {});
                                    }
                                  },
                                  icon: names.contains(data["name"])
                                      ? const Icon(
                                          Icons.check_box,
                                          color: Colors.blue,
                                        )
                                      : const Icon(
                                          Icons
                                              .check_box_outline_blank_outlined,
                                          color: Colors.black,
                                        )),
                              onTap: () {},
                              title: Text(
                                "${data["name"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 25),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
            Positioned(
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Attendees",
                          style: TextStyle(fontSize: 18),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("School")
                              .doc(widget.docsid)
                              .collection("Students")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center();
                            } else {
                              return Text(
                                "${names.length}/${snapshot.data!.docs.length}",
                                style: const TextStyle(fontSize: 20),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
