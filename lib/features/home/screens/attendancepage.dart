import 'package:attendance_app/features/classpages/screens/students_attendance_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              context, StudentsAttendanceScreen.routeName,
                              arguments: {
                                "classname": data["ClassName"],
                                "docid": snapshot.data!.docs[index].id
                              });
                        },
                        title: Text(
                          "Class ${data["ClassName"]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(color: Colors.orange),
                          child: Center(
                              child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("School")
                                .doc(snapshot.data!.docs[index].id)
                                .collection("Students")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center();
                              } else {
                                return Text("${snapshot.data!.docs.length}");
                              }
                            },
                          )),
                        )),
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
