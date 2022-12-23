import 'package:attendance_app/features/classpages/screens/allstudents_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastAttendance extends StatefulWidget {
  static const String routeName = "/past-attendance";
  final String classname;
  final String docsid;

  const PastAttendance({
    super.key,
    required this.classname,
    required this.docsid,
  });

  @override
  State<PastAttendance> createState() => _PastAttendanceState();
}

class _PastAttendanceState extends State<PastAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Class Attendance"),
            Text("Class${widget.classname}")
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("School")
            .doc(widget.docsid)
            .collection("Pastdocument")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data();

                DateTime time = DateTime.fromMicrosecondsSinceEpoch(
                    data["Date"].microsecondsSinceEpoch);
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context, AllStudentsAttendance.routeName,
                          arguments: {
                            "classname": widget.classname,
                            "docid": widget.docsid,
                            "docsid1": snapshot.data!.docs[index].id
                          });
                    },
                    title: Text(DateFormat.yMEd().format(time)),
                    leading: Container(
                      height: 50,
                      width: 50,
                      color: Colors.orange,
                      child: Center(child: Text("${index + 1}")),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
