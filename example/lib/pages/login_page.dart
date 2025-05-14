import 'package:fia_example/fia_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _fiaService = FiaService();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fiaService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            const Text('fazpass', textAlign: TextAlign.center),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                label: Text('Phone'),
                hintText: '+6281234567890',
              ),
            ),
            ElevatedButton(
              onPressed: _requestOtp,
              child: const Text('Request Otp'),
            ),
          ],
        ),
      ),
    );
  }

  void _requestOtp() async {
    final phone = _phoneController.text.toString();
    try {
      await _fiaService.requestOtp(phone);
      if (!mounted) return;
      Navigator.pushNamed(context, '/validate');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (c) => AlertDialog(
              title: Text('Error'),
              content: Text('$e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}
