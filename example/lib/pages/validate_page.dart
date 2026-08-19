import 'package:fia/otp_auth_type.dart';
import 'package:fia_example/fia_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key});

  @override
  State<ValidatePage> createState() => _ValidatePageState();
}

class _ValidatePageState extends State<ValidatePage> {
  final _fiaService = FiaService();
  final _otpController = TextEditingController();

  late final authType = _fiaService.lastPromise?.authType;

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
            Text('validate otp type: $authType', textAlign: TextAlign.center),
            // Magic otp and magic link both start by sending the user to
            // WhatsApp. Magic otp then comes back with an otp to type in,
            // magic link validates itself once the user taps the link.
            if (authType == OtpAuthType.magicOtp ||
                authType == OtpAuthType.magicLink)
              ElevatedButton(
                onPressed:
                    authType == OtpAuthType.magicOtp
                        ? _launchWhatsappForMagicOtp
                        : _launchWhatsappForMagicLink,
                child: const Text('Open Whatsapp'),
              ),
            if ([
              OtpAuthType.sms,
              OtpAuthType.whatsapp,
              OtpAuthType.voice,
              OtpAuthType.magicOtp,
              OtpAuthType.miscall,
            ].any((type) => type == authType))
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  label: Text('Otp'),
                  hintText: '1234',
                ),
              ),
            if (authType != OtpAuthType.magicLink)
              ElevatedButton(
                onPressed: () {
                  switch (authType) {
                    case OtpAuthType.he:
                      _validateHe();
                      break;
                    default:
                      _validateOtp();
                      break;
                  }
                },
                child: const Text('Validate OTP'),
              ),
          ],
        ),
      ),
    );
  }

  void _validateOtp() async {
    try {
      await _fiaService.validateOtp(_otpController.text.toString());
      if (!mounted) return;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      _showError(e);
    }
  }

  void _validateHe() async {
    try {
      await _fiaService.validateHe();
      if (!mounted) return;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      _showError(e);
    }
  }

  void _launchWhatsappForMagicOtp() async {
    try {
      await _fiaService.launchWhatsappForMagicOtp();
    } catch (e) {
      _showError(e);
    }
  }

  void _launchWhatsappForMagicLink() async {
    try {
      await _fiaService.launchWhatsappForMagicLink();
      if (!mounted) return;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(Object e) {
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
              TextButton(onPressed: () => Navigator.pop(c), child: Text('OK')),
            ],
          ),
    );
  }
}
