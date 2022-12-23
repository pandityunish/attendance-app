import 'package:attendance_app/common/utiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeRepository with ChangeNotifier {
  void createClass(BuildContext context, String classname) async {
    try {
      await FirebaseFirestore.instance
          .collection("School")
          .doc()
          .set({"ClassName": classname});
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }
}
