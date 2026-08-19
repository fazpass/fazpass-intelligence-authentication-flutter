import 'otp_promise.dart';
import 'src/fia_platform_interface.dart';

class OtpSettings {
  /// Requests an otp for a login attempt.
  ///
  /// [additionalInfo] attaches arbitrary key/value metadata to the request.
  Future<OtpPromise> login(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otp('login', phone, additionalInfo);
    return OtpPromise(obj);
  }

  /// Requests an otp for a registration attempt.
  ///
  /// See [login] for the optional parameters.
  Future<OtpPromise> register(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otp(
      'register',
      phone,
      additionalInfo,
    );
    return OtpPromise(obj);
  }

  /// Requests an otp for a transaction.
  ///
  /// See [login] for the optional parameters.
  Future<OtpPromise> transaction(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otp(
      'transaction',
      phone,
      additionalInfo,
    );
    return OtpPromise(obj);
  }

  /// Requests an otp for a forgotten password flow.
  ///
  /// See [login] for the optional parameters.
  Future<OtpPromise> forgetPassword(
    String phone, {
    Map<String, String>? additionalInfo,
  }) async {
    final obj = await FiaPlatform.instance.otp(
      'forgetPassword',
      phone,
      additionalInfo,
    );
    return OtpPromise(obj);
  }
}
