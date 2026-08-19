import 'package:fia_example/pages/gateway_page.dart';
import 'package:fia_example/pages/home_page.dart';
import 'package:fia_example/pages/login_page.dart';
import 'package:fia_example/pages/validate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // dotenv reads the .env asset through the root bundle, so the binding has
  // to be up before the credentials are available.
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
        '/gateway': (context) => GatewayPage(),
        '/validate': (context) => ValidatePage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
