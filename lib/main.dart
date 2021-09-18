// @dart=2.9
import 'package:flutter/material.dart';
import 'package:richard/screens/splash.dart';
import 'package:richard/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ričard',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.orangeAccent,
      ),
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Splash();
          }
          return Home();
        },
      ),
    );
  }
}