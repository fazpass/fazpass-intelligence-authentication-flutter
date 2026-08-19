import 'dart:convert';

import 'package:fia/fia.dart';
import 'package:fia/otp_gateway_promise.dart';
import 'package:fia/otp_magic_redirect.dart';
import 'package:fia/otp_promise.dart';
import 'package:http/http.dart' as http;

class FiaService {
  static final FiaService _instance = FiaService._internal();
  FiaService._internal();
  factory FiaService() {
    return _instance;
  }

  final config = _FiaConfig.production;

  final _fia = Fia();
  OtpPromise? lastPromise;
  OtpGatewayPromise? lastGatewayPromise;
  String? phone;

  void initialize() {
    _fia.initialize(
      config.merchantKey,
      config.merchantAppId,
      iosGroupId: 'group.com.fiaExample',
    );
  }

  Future<void> requestOtp(String phone) async {
    final promise = await _fia.otp().register(phone);
    if (promise.hasException) {
      throw promise.exception!;
    }
    lastPromise = promise;
    this.phone = phone;
  }

  /// Asks for every auth type available for [phone] so the user can pick one.
  ///
  /// Returns true when the user was already authenticated and no otp is needed.
  Future<bool> requestOtpManual(String phone) async {
    final promise = await _fia.otpManual().register(phone);
    if (promise.hasException) {
      throw promise.exception!;
    }
    lastGatewayPromise = promise;
    this.phone = phone;

    if (promise.isAuthenticated) {
      final status = await checkVerificationStatus(promise.transactionId);
      await promise.clean();
      lastGatewayPromise = null;
      if (!status) throw 'Failed to verify user.';
      return true;
    }
    return false;
  }

  /// Requests an otp through the auth type the user picked.
  Future<void> pickGateway(int number) async {
    final gatewayPromise = lastGatewayPromise;
    if (gatewayPromise == null) throw 'No gateway promise.';

    final promise = await gatewayPromise.pick(number);
    if (promise.hasException) {
      throw promise.exception!;
    }
    lastPromise = promise;
    await gatewayPromise.clean();
    lastGatewayPromise = null;
  }

  Future<void> launchWhatsappForMagicOtp() async {
    await lastPromise?.launchWhatsappForMagicOtp(
      magicRedirect: OtpMagicRedirect.auto,
    );
  }

  Future<void> launchWhatsappForMagicLink() async {
    await lastPromise?.launchWhatsappForMagicLink(
      magicRedirect: OtpMagicRedirect.auto,
    );
    final status = await checkVerificationStatus();
    await lastPromise?.clean();
    if (!status) throw 'Failed to verify user.';
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

  Future<bool> checkVerificationStatus([String? transactionId]) async {
    final id = transactionId ?? lastPromise?.transactionId;
    final response = await http.get(
      Uri.parse(
        'https://api.fazpass.com/v1/otp/fia/verification-status/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': config.merchantKey,
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

enum _FiaConfig {
  production(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmaWVyIjo5NzcwfQ.RTOdNJK-P3iKnVOP8m_xnCet7OcuG5GETdYlPM0FIpo',
    '2e814399-6120-4a5e-93e2-562a903d480d',
  );

  final String merchantKey;
  final String merchantAppId;

  const _FiaConfig(this.merchantKey, this.merchantAppId);
}
