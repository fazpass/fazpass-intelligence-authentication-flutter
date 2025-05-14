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
      case 'Message':
        authType = OtpAuthType.message;
        break;
      case 'Miscall':
        authType = OtpAuthType.miscall;
        break;
      case 'He':
        authType = OtpAuthType.he;
        break;
      case 'FIA':
        authType = OtpAuthType.fia;
        break;
      default:
        authType = OtpAuthType.message;
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

  /// Clean this object from memory.
  ///
  /// Call this method when this object is not used anymore.
  Future<void> clean() {
    return FiaPlatform.instance.forgetPromise(transactionId);
  }
}
