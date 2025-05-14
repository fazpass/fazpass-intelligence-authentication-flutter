import 'otp_promise.dart';
import 'src/fia_platform_interface.dart';

class OtpSettings {
  Future<OtpPromise> login(String phone) async {
    final obj = await FiaPlatform.instance.otp('login', phone);
    return OtpPromise(obj);
  }

  Future<OtpPromise> register(String phone) async {
    final obj = await FiaPlatform.instance.otp('register', phone);
    return OtpPromise(obj);
  }

  Future<OtpPromise> transaction(String phone) async {
    final obj = await FiaPlatform.instance.otp('transaction', phone);
    return OtpPromise(obj);
  }

  Future<OtpPromise> forgetPassword(String phone) async {
    final obj = await FiaPlatform.instance.otp('forgetPassword', phone);
    return OtpPromise(obj);
  }
}
