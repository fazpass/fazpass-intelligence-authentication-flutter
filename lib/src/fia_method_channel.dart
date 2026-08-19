import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../otp_magic_redirect.dart';
import 'fia_platform_interface.dart';

/// An implementation of [FiaPlatform] that uses method channels.
class MethodChannelFia extends FiaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fia');

  @override
  Future<void> initialize(
    String merchantKey,
    String merchantAppId,
    String iosGroupId,
  ) {
    return methodChannel.invokeMethod<void>('initialize', {
      'merchantKey': merchantKey,
      'merchantAppId': merchantAppId,
      'iosGroupId': iosGroupId,
    });
  }

  @override
  Future<Map> otp(
    String purpose,
    String phone,
    Map<String, String>? additionalInfo,
  ) async {
    return (await methodChannel.invokeMethod<Map>('otp', {
          'purpose': purpose,
          'phone': phone,
          'additionalInfo': additionalInfo,
        })) ??
        {};
  }

  @override
  Future<Map> otpManual(
    String purpose,
    String phone,
    Map<String, String>? additionalInfo,
  ) async {
    return (await methodChannel.invokeMethod<Map>('otpManual', {
          'purpose': purpose,
          'phone': phone,
          'additionalInfo': additionalInfo,
        })) ??
        {};
  }

  @override
  Future<Map> pickOtpGateway(String gatewayId, int number) async {
    return (await methodChannel.invokeMethod<Map>('pickOtpGateway', {
          'gatewayId': gatewayId,
          'number': number,
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
  Future<void> launchWhatsappForMagicOtp(
    String transactionId,
    OtpMagicRedirect magicRedirect,
  ) {
    return methodChannel.invokeMethod<void>('launchWhatsappForMagicOtp', {
      'transactionId': transactionId,
      'magicRedirect': magicRedirect.nativeName,
    });
  }

  @override
  Future<void> launchWhatsappForMagicLink(
    String transactionId,
    OtpMagicRedirect magicRedirect,
  ) {
    return methodChannel.invokeMethod<void>('launchWhatsappForMagicLink', {
      'transactionId': transactionId,
      'magicRedirect': magicRedirect.nativeName,
    });
  }

  @override
  Future<void> forgetPromise(String transactionId) {
    return methodChannel.invokeMethod<void>('forgetPromise', {
      'transactionId': transactionId,
    });
  }

  @override
  Future<void> forgetGatewayPromise(String gatewayId) {
    return methodChannel.invokeMethod<void>('forgetGatewayPromise', {
      'gatewayId': gatewayId,
    });
  }

  @override
  Future<void> setFeatures(
    bool withVpn,
    bool withLocation,
    bool withBiometricPopup,
    bool withBiometricLevelHigh,
    bool withSimNumbersAndOperators,
    bool withOtpSpammingFunction,
    bool withAppTamperingFunction,
    bool withSuspiciousAppFunction,
    bool withPromoAbuseFunction,
    List<String> promoIds,
    bool withAccountTakeoverFunction,
    String userIdentifier,
  ) {
    return methodChannel.invokeMethod<void>('setFeatures', {
      'withVpn': withVpn,
      'withLocation': withLocation,
      'withBiometricPopup': withBiometricPopup,
      'withBiometricLevelHigh': withBiometricLevelHigh,
      'withSimNumbersAndOperators': withSimNumbersAndOperators,
      'withOtpSpammingFunction': withOtpSpammingFunction,
      'withAppTamperingFunction': withAppTamperingFunction,
      'withSuspiciousAppFunction': withSuspiciousAppFunction,
      'withPromoAbuseFunction': withPromoAbuseFunction,
      'promoIds': promoIds,
      'withAccountTakeoverFunction': withAccountTakeoverFunction,
      'userIdentifier': userIdentifier,
    });
  }
}
