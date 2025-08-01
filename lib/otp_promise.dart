import 'src/fia_platform_interface.dart';
import 'otp_auth_type.dart';

class OtpPromise {
  String transactionId;
  late OtpAuthType authType;
  bool hasException;
  String? exception;
  int? digitCount;

  OtpPromise(Map obj)
    : transactionId = obj['transactionId'],
      hasException = obj['hasException'],
      exception = obj['exception'],
      digitCount = obj['digitCount'] {
    switch (obj['authType']) {
      case 'SMS':
        authType = OtpAuthType.sms;
        break;
      case 'Whatsapp':
        authType = OtpAuthType.whatsapp;
        break;
      case 'Miscall':
        authType = OtpAuthType.miscall;
        break;
      case 'HE':
        authType = OtpAuthType.he;
        break;
      case 'FIA':
        authType = OtpAuthType.fia;
        break;
      case 'MagicOtp':
        authType = OtpAuthType.magicOtp;
        break;
      case 'MagicLink':
        authType = OtpAuthType.magicLink;
        break;
      case 'Voice':
        authType = OtpAuthType.voice;
        break;
      default:
        authType = OtpAuthType.he;
        break;
    }
  }

  Future<void> validate(String otp) {
    return FiaPlatform.instance.validateOtp(transactionId, otp);
  }

  Future<void> validateHE() {
    return FiaPlatform.instance.validateHE(transactionId);
  }

  Future<String> listenToMiscall() {
    return FiaPlatform.instance.listenToMiscall(transactionId);
  }

  Future<void> launchWhatsappForMagicOtp() {
    return FiaPlatform.instance.launchWhatsappForMagicOtp(transactionId);
  }

  Future<void> launchWhatsappForMagicLink() {
    return FiaPlatform.instance.launchWhatsappForMagicLink(transactionId);
  }

  /// Clean this object from memory.
  ///
  /// Call this method when this object is not used anymore.
  Future<void> clean() {
    return FiaPlatform.instance.forgetPromise(transactionId);
  }
}
