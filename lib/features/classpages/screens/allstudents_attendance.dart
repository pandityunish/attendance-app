import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllStudentsAttendance extends StatefulWidget {
  final String classname;
  final String docsid;
  final String docsid1;
  static const String routeName = "/all-studentsattendance";
  const AllStudentsAttendance({
    super.key,
    required this.classname,
    required this.docsid,
    required this.docsid1,
  });

  @override
  State<AllStudentsAttendance> createState() => _AllStudentsAttendanceState();
}

class _AllStudentsAttendanceState extends State<AllStudentsAttendance> {
  List allnamesofstudent = [];

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
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add),
            onPressed: () {}),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("School")
                    .doc(widget.docsid)
                    .collection("Pastdocument")
                    .doc(widget.docsid1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final data = snapshot.data!.data();
                    List namesofstudent = data!["Allattendance"];
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: namesofstudent.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.check_box,
                                      color: Colors.blue,
                                    )),
                                onTap: () {},
                                title: Text(
                                  namesofstudent[index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
