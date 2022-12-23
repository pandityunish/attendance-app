import 'package:attendance_app/button_navigation_bar.dart';
import 'package:attendance_app/common/splash_screen.dart';
import 'package:attendance_app/features/classpages/screens/allstudents_attendance.dart';
import 'package:attendance_app/features/classpages/screens/class_screen.dart';
import 'package:attendance_app/features/classpages/screens/class_student_attendance.dart';
import 'package:attendance_app/features/classpages/screens/past_attendance.dart';
import 'package:attendance_app/features/home/screens/home_screen.dart';
import 'package:attendance_app/features/tableattendance/screens/all_students_table_attendance.dart';
import 'package:flutter/material.dart';

import '../features/classpages/screens/students_attendance_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case ButtonNavigatonBarPage.routeName:
      return MaterialPageRoute(
          builder: (context) => const ButtonNavigatonBarPage());
    case ClassScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final classname = arguments["classname"];
      final docid = arguments["docid"];
      return MaterialPageRoute(
          builder: (context) => ClassScreen(
                classname: classname,
                docsid: docid,
              ));
    case StudentsAttendanceScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final classname = arguments["classname"];
      final docid = arguments["docid"];
      return MaterialPageRoute(
          builder: (context) => StudentsAttendanceScreen(
                classname: classname,
                docsid: docid,
              ));
    case PastAttendance.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final classname = arguments["classname"];
      final docid = arguments["docid"];

      return MaterialPageRoute(
          builder: (context) => PastAttendance(
                classname: classname,
                docsid: docid,
              ));
    case AllStudentsAttendance.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final classname = arguments["classname"];
      final docid = arguments["docid"];
      final docsid1 = arguments["docsid1"];
      return MaterialPageRoute(
          builder: (context) => AllStudentsAttendance(
                classname: classname,
                docsid: docid,
                docsid1: docsid1,
              ));
    case ClassStudentAttendance.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final classname = arguments["classname"];
      final docid = arguments["docid"];

      return MaterialPageRoute(
          builder: (context) => ClassStudentAttendance(
                classname: classname,
                docsid: docid,
              ));
    case AllStudentsTableAttendance.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final studentname = arguments["studentname"];
      final docid = arguments["docid"];
      final docsid1 = arguments["docsid1"];
      return MaterialPageRoute(
          builder: (context) => AllStudentsTableAttendance(
                studentname: studentname,
                docid: docid,
                docsid1: docsid1,
              ));
    default:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}
