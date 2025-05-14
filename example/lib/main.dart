import 'package:fia_example/pages/home_page.dart';
import 'package:fia_example/pages/login_page.dart';
import 'package:fia_example/pages/validate_page.dart';
import 'package:flutter/material.dart';

void main() {
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
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/validate': (context) => ValidatePage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
