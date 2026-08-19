import 'otp_gateway.dart';
import 'otp_promise.dart';
import 'src/fia_platform_interface.dart';

/// The result of a manual otp request, holding every auth type available for
/// the phone number so the user can pick one with [pick].
class OtpGatewayPromise {
  /// Identifies this gateway promise on the native side.
  ///
  /// [transactionId] can't be used for that: it is only filled in when
  /// [isAuthenticated] is true.
  String gatewayId;

  /// Whether the user has already been authenticated and does not need to
  /// request an otp at all.
  ///
  /// When this is true the flow ends here: take the [transactionId] and check
  /// for the user verified status. [gateways] is empty.
  bool isAuthenticated;

  /// Only filled when [isAuthenticated] is true, otherwise it is empty.
  String transactionId;

  /// Identifies this otp attempt on the Keypaz dashboard.
  String activityId;

  /// Whether this otp request was blocked, e.g. by otp spamming detection.
  bool isBlocked;

  bool hasException;
  String? exception;

  /// Every auth type available for this phone number.
  List<OtpGateway> gateways;

  OtpGatewayPromise(Map obj)
    : gatewayId = obj['gatewayId'] ?? '',
      isAuthenticated = obj['isAuthenticated'] ?? false,
      transactionId = obj['transactionId'] ?? '',
      activityId = obj['activityId'] ?? '',
      isBlocked = obj['isBlocked'] ?? false,
      hasException = obj['hasException'],
      exception = obj['exception'],
      gateways =
          ((obj['gateways'] as List?) ?? [])
              .map((it) => OtpGateway(it as Map))
              .toList();

  /// Requests an otp through the auth type the user picked.
  ///
  /// [number] is the [OtpGateway.number] of the chosen gateway. The returned
  /// promise is the same object the automatic otp flow produces.
  Future<OtpPromise> pick(int number) async {
    final obj = await FiaPlatform.instance.pickOtpGateway(gatewayId, number);
    return OtpPromise(obj);
  }

  /// Clean this object from memory.
  ///
  /// Call this method when this object is not used anymore.
  Future<void> clean() {
    return FiaPlatform.instance.forgetGatewayPromise(gatewayId);
  }
}
