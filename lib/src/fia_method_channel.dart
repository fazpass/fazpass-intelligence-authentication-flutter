import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fia_platform_interface.dart';

/// An implementation of [FiaPlatform] that uses method channels.
class MethodChannelFia extends FiaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fia');

  @override
  Future<void> initialize(String merchantKey, String merchantAppId) {
    return methodChannel.invokeMethod<void>('initialize', {
      'merchantKey': merchantKey,
      'merchantAppId': merchantAppId,
    });
  }

  @override
  Future<Map> otp(String purpose, String phone) async {
    return (await methodChannel.invokeMethod<Map>('otp', {
          'purpose': purpose,
          'phone': phone,
        })) ??
        {};
  }

  @override
  Future<void> validateOtp(String transactionId, String otp) {
    return methodChannel.invokeMethod<void>('validateOtp', {
      'transactionId': transactionId,
      'otp': otp,
    });
  }

  @override
  Future<void> validateHE(String transactionId) {
    return methodChannel.invokeMethod<void>('validateHE', {
      'transactionId': transactionId,
    });
  }

  @override
  Future<String> listenToMiscall(String transactionId) async {
    return (await methodChannel.invokeMethod<String>('listenToMiscall', {
          'transactionId': transactionId,
        })) ??
        '';
  }

  @override
  Future<void> forgetPromise(String transactionId) {
    return methodChannel.invokeMethod<void>('forgetPromise', {
      'transactionId': transactionId,
    });
  }
}
