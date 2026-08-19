/// An otp auth type the user can pick from in the manual otp flow.
class OtpGateway {
  /// The identifier of this auth type, to be passed to `OtpGatewayPromise.pick`.
  final int number;

  /// The name of this auth type, to be shown to the user.
  final String name;

  OtpGateway(Map obj) : number = obj['number'], name = obj['name'] ?? '';
}
