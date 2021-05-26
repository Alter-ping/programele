import 'package:finalproject/Setup/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Firebase Demo",
        theme: new ThemeData(
            appBarTheme: AppBarTheme(
          color: Colors.indigo[400],
        )),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        home: new LoginPage(),
        debugShowCheckedModeBanner: false);
  }
}
