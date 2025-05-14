import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fia_method_channel.dart';

abstract class FiaPlatform extends PlatformInterface {
  /// Constructs a FiaPlatform.
  FiaPlatform() : super(token: _token);

  static final Object _token = Object();

  static FiaPlatform _instance = MethodChannelFia();

  /// The default instance of [FiaPlatform] to use.
  ///
  /// Defaults to [MethodChannelFia].
  static FiaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FiaPlatform] when
  /// they register themselves.
  static set instance(FiaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize(String merchantKey, String merchantAppId) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<Map> otp(String purpose, String phone) {
    throw UnimplementedError('otp() has not been implemented.');
  }

  Future<void> validateOtp(String transactionId, String otp) {
    throw UnimplementedError('validateOtp() has not been implemented.');
  }

  Future<void> validateHE(String transactionId) {
    throw UnimplementedError('validateHE() has not been implemented.');
  }

  Future<String> listenToMiscall(String transactionId) {
    throw UnimplementedError('listenToMiscall() has not been implemented.');
  }

  Future<void> forgetPromise(String transactionId) {
    throw UnimplementedError('forgetPromise() has not been implemented.');
  }
}
