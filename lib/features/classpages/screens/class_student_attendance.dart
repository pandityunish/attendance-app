import 'package:attendance_app/features/tableattendance/screens/all_students_table_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassStudentAttendance extends StatefulWidget {
  static const String routeName = "/class-student-attendance";
  final String docsid;
  final String classname;
  const ClassStudentAttendance(
      {super.key, required this.classname, required this.docsid});

  @override
  State<ClassStudentAttendance> createState() => _ClassStudentAttendanceState();
}

class _ClassStudentAttendanceState extends State<ClassStudentAttendance> {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
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
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    AllStudentsTableAttendance.routeName,
                                    arguments: {
                                      "studentname": data["name"],
                                      "docid": widget.docsid,
                                      "docsid1": snapshot.data!.docs[index].id
                                    });
                              },
                              icon: const Icon(Icons.event_note_rounded)),
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
      ),
    );
  }
}
