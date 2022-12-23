import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllStudentsTableAttendance extends StatefulWidget {
  static const String routeName = "/allstudentstableattendance";
  final String studentname;
  final String docid;
  final String docsid1;
  const AllStudentsTableAttendance({
    super.key,
    required this.studentname,
    required this.docid,
    required this.docsid1,
  });

  @override
  State<AllStudentsTableAttendance> createState() =>
      _AllStudentsTableAttendanceState();
}

class _AllStudentsTableAttendanceState
    extends State<AllStudentsTableAttendance> {
  num totaldays = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${widget.studentname}"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("School")
            .doc(widget.docid)
            .collection("Students")
            .doc(widget.docsid1)
            .collection("Attendanceofstudent")
            .orderBy("Date")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Present"))
                      ],
                      rows: snapshot.data!.docs
                          .map((data) => DataRow(cells: [
                                DataCell(Text(DateFormat.yMMMEd().format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        data["Date"].microsecondsSinceEpoch)))),
                                DataCell(Text(data["present"].toString()))
                              ]))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("School")
                        .doc(widget.docid)
                        .collection("Students")
                        .doc(widget.docsid1)
                        .collection("Attendanceofstudent")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> querySnapshot) {
                      if (querySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        for (var doc in querySnapshot.data!.docs) {
                          totaldays = totaldays + doc["present"];
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total days present: $totaldays",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total days school open: ${snapshot.data!.docs.length}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
