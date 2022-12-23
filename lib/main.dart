import 'package:attendance_app/common/route.dart';
import 'package:attendance_app/common/splash_screen.dart';
import 'package:attendance_app/features/classpages/repository/classpages_repository.dart';
import 'package:attendance_app/features/home/repository/home_repository.dart';
import 'package:attendance_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeRepository()),
        ChangeNotifierProvider(create: (_) => ClasspagesRepository()),
      ],
      child: MaterialApp(
        onGenerateRoute: (settings) => generateRoute(settings),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}
