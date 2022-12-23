import 'package:attendance_app/features/classpages/screens/statistic_page.dart';
import 'package:attendance_app/features/home/screens/attendancepage.dart';
import 'package:attendance_app/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ButtonNavigatonBarPage extends StatefulWidget {
  static const String routeName = "/bottomnavigation";
  const ButtonNavigatonBarPage({super.key});

  @override
  State<ButtonNavigatonBarPage> createState() => _ButtonNavigatonBarPageState();
}

class _ButtonNavigatonBarPageState extends State<ButtonNavigatonBarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text("Attendance Taker"),
            bottom: const TabBar(tabs: [
              Tab(
                text: "CLASS",
              ),
              Tab(
                text: "ATTENDANCE",
              ),
              Tab(
                text: "STATISTIC",
              )
            ]),
          ),
          body: const TabBarView(
              children: [HomeScreen(), AttendancePage(), StatisticPage()])),
    );
  }
}
