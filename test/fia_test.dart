import 'package:flutter_test/flutter_test.dart';
import 'package:fia/fia.dart';
import 'package:fia/src/fia_platform_interface.dart';
import 'package:fia/src/fia_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFiaPlatform with MockPlatformInterfaceMixin implements FiaPlatform {
  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> forgetPromise(String transactionId) {
    // TODO: implement forgetPromise
    throw UnimplementedError();
  }

  @override
  Future<void> initialize(String merchantKey, String merchantAppId) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<String> listenToMiscall(String transactionId) {
    // TODO: implement listenToMiscall
    throw UnimplementedError();
  }

  @override
  Future<Map> otp(String purpose, String phone) {
    // TODO: implement otp
    throw UnimplementedError();
  }

  @override
  Future<void> validateHE(String transactionId) {
    // TODO: implement validateHE
    throw UnimplementedError();
  }

  @override
  Future<void> validateOtp(String transactionId, String otp) {
    // TODO: implement validateOtp
    throw UnimplementedError();
  }

  @override
  Future<void> launchWhatsappForMagicLink(String transactionId) {
    // TODO: implement launchWhatsappForMagicLink
    throw UnimplementedError();
  }

  @override
  Future<void> launchWhatsappForMagicOtp(String transactionId) {
    // TODO: implement launchWhatsappForMagicOtp
    throw UnimplementedError();
  }
}

void main() {
  final FiaPlatform initialPlatform = FiaPlatform.instance;

  test('$MethodChannelFia is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFia>());
  });

  test('getPlatformVersion', () async {
    Fia fiaPlugin = Fia();
    MockFiaPlatform fakePlatform = MockFiaPlatform();
    FiaPlatform.instance = fakePlatform;

    //expect(await fiaPlugin.getPlatformVersion(), '42');
  });
}
