import 'dart:convert';

import 'package:fia/fia.dart';
import 'package:fia/otp_promise.dart';
import 'package:http/http.dart' as http;

class FiaService {
  static final FiaService _instance = FiaService._internal();
  FiaService._internal();
  factory FiaService() {
    return _instance;
  }

  static final String MERCHANT_KEY =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmaWVyIjo5NzcwfQ.RTOdNJK-P3iKnVOP8m_xnCet7OcuG5GETdYlPM0FIpo';
  static final String MERCHANT_APP_ID = '2e814399-6120-4a5e-93e2-562a903d480d';

  final _fia = Fia();
  OtpPromise? lastPromise;
  String? phone;

  void initialize() {
    _fia.initialize(MERCHANT_KEY, MERCHANT_APP_ID);
  }

  Future<void> requestOtp(String phone) async {
    final promise = await _fia.otp().login(phone);
    if (promise.hasException) {
      throw promise.exception!;
    }
    lastPromise = promise;
    this.phone = phone;
  }

  Future<void> validateOtp(String otp) async {
    await lastPromise?.validate(otp);
    final status = await checkVerificationStatus();
    await lastPromise?.clean();
    if (!status) throw 'Failed to verify user.';
  }

  Future<void> validateHe() async {
    await lastPromise?.validateHE();
    final status = await checkVerificationStatus();
    await lastPromise?.clean();
    if (!status) throw 'Failed to verify user.';
  }

  Future<bool> checkVerificationStatus() async {
    final response = await http.get(
      Uri.parse(
        'https://api.fazpass.com/v1/otp/fia/verification-status/${lastPromise?.transactionId}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': MERCHANT_KEY,
      },
    );

    final json = jsonDecode(response.body);
    final data = json['data'];
    if (data == null) {
      throw json['message'];
    }
    return data['is_verified'];
  }
}
