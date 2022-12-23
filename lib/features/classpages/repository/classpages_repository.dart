import 'package:attendance_app/common/utiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ClasspagesRepository with ChangeNotifier {
  void addStudents(BuildContext context, String docid, String name) async {
    try {
      await FirebaseFirestore.instance
          .collection("School")
          .doc(docid)
          .collection("Students")
          .doc()
          .set({"name": name});
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  void addallattendance(BuildContext context, String docid, List name) async {
    try {
      await FirebaseFirestore.instance
          .collection("School")
          .doc(docid)
          .collection("Pastdocument")
          .add({
        "Allattendance": FieldValue.arrayUnion(name),
        "Date": DateTime.now()
      });
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  void addattendanceofstudent(
    BuildContext context,
    String docid,
    String docsid1,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("School")
          .doc(docid)
          .collection("Students")
          .doc(docsid1)
          .collection("Attendanceofstudent")
          .add({
        "Date": DateTime.now(),
        "present": 1,
      });
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  void addabsenceofstudent(
    BuildContext context,
    String docid,
    String docsid1,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("School")
          .doc(docid)
          .collection("Students")
          .doc(docsid1)
          .collection("Attendanceofstudent")
          .add({
        "Date": DateTime.now(),
        "present": 0,
      });
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  void removeabsenceofstudent(
    BuildContext context,
    String docid,
    String docsid2,
    String docsid1,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("School")
          .doc(docid)
          .collection("Students")
          .doc(docsid1)
          .collection("Attendanceofstudent")
          .doc(docsid2)
          .delete();
    } catch (e) {
      showsnackbar(context, e.toString());
      print(e.toString());
    }
  }
}
