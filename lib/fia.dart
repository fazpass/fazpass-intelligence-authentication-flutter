import 'otp_settings.dart';
import 'otp_user_settings.dart';
import 'src/fia_platform_interface.dart';

class Fia {
  /// Initialize everything.
  ///
  /// Must be called once before calling any other methods.
  Future<void> initialize(
    String merchantKey,
    String merchantAppId, {
    String iosGroupId = '',
  }) {
    return FiaPlatform.instance.initialize(
      merchantKey,
      merchantAppId,
      iosGroupId,
    );
  }

  /// Creates an instance of `OtpSettings`.
  ///
  /// It can request an otp which you have to validate by yourself.
  OtpSettings otp() {
    return OtpSettings();
  }

  /// Creates an instance of `OtpUserSettings`.
  ///
  /// Unlike [otp], which lets the server decide which auth type to use, this
  /// first returns every auth type available for the phone number so the user
  /// can pick the one they prefer.
  OtpUserSettings otpManual() {
    return OtpUserSettings();
  }

  /// Setup additional pro-feature settings for requesting otp.
  ///
  /// [withVpn], [withSimNumbersAndOperators], [withAppTamperingFunction] and
  /// [withSuspiciousAppFunction] are Android only — the native iOS SDK does not
  /// implement them, and they are ignored there.
  Future<void> setFeatures({
    bool withVpn = false,
    bool withLocation = false,
    bool withBiometricPopup = false,
    bool withBiometricLevelHigh = false,
    bool withSimNumbersAndOperators = false,
    bool withOtpSpammingFunction = false,
    bool withAppTamperingFunction = false,
    bool withSuspiciousAppFunction = false,
    bool withPromoAbuseFunction = false,
    List<String> promoIds = const [],
    bool withAccountTakeoverFunction = false,
    String userIdentifier = '',
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
