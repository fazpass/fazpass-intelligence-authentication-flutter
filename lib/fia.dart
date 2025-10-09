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

  /// Setup additional pro-feature settings for requesting otp.
  Future<void> setFeatures({
    bool withVpn=false,
    bool withLocation=false,
    bool withBiometricPopup=false,
    bool withBiometricLevelHigh=false,
    bool withSimNumbersAndOperators=false,
    bool withOtpSpammingFunction=false,
    bool withAppTamperingFunction=false,
    bool withSuspiciousAppFunction=false,
    bool withPromoAbuseFunction=false,
    List<String> promoIds=const [],
    bool withAccountTakeoverFunction=false,
    String userIdentifier='',
  }) {
    return FiaPlatform.instance.setFeatures(
      withVpn,
      withLocation,
      withBiometricPopup,
      withBiometricLevelHigh,
      withSimNumbersAndOperators,
      withOtpSpammingFunction,
      withAppTamperingFunction,
      withSuspiciousAppFunction,
      withPromoAbuseFunction,
      promoIds,
      withAccountTakeoverFunction,
      userIdentifier,
    );
  }
}
