import 'otp_gateway_promise.dart';
import 'src/fia_platform_interface.dart';

/// Requests the auth types available for a phone number, so the user can pick
/// the one they prefer instead of letting the server choose.
class OtpUserSettings {
  /// Requests the available auth types for a login attempt.
  ///
  /// [additionalInfo] attaches arbitrary key/value metadata to the request.
  Future<OtpGatewayPromise> login(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otpManual(
      'login',
      phone,
      additionalInfo,
    );
    return OtpGatewayPromise(obj);
  }

  /// Requests the available auth types for a registration attempt.
  ///
  /// See [login] for the optional parameters.
  Future<OtpGatewayPromise> register(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otpManual(
      'register',
      phone,
      additionalInfo,
    );
    return OtpGatewayPromise(obj);
  }

  /// Requests the available auth types for a transaction.
  ///
  /// See [login] for the optional parameters.
  Future<OtpGatewayPromise> transaction(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otpManual(
      'transaction',
      phone,
      additionalInfo,
    );
    return OtpGatewayPromise(obj);
  }

  /// Requests the available auth types for a forgotten password flow.
  ///
  /// See [login] for the optional parameters.
  Future<OtpGatewayPromise> forgetPassword(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otpManual(
      'forgetPassword',
      phone,
      additionalInfo,
    );
    return OtpGatewayPromise(obj);
  }
}
