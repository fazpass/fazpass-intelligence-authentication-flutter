import 'otp_settings.dart';
import 'src/fia_platform_interface.dart';

class Fia {
  /// Initialize everything.
  ///
  /// Must be called once before calling any other methods.
  Future<void> initialize(String merchantKey, String merchantAppId) {
    return FiaPlatform.instance.initialize(merchantKey, merchantAppId);
  }

  /// Creates an instance of `OtpSettings`.
  ///
  /// It can request an otp which you have to validate by yourself.
  OtpSettings otp() {
    return OtpSettings();
  }
}
