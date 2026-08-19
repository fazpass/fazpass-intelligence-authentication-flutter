# fia

FIA Flutter by Fazpass.
Visit [official website](https://fazpass.com) for more information about the product and see documentation at [github documentation](https://github.com/fazpass/fia-documentation/blob/main/README.Flutter.md) for more technical details.

## Installation

Run this command in your root project:

`$ flutter pub add fia`

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```yaml
dependencies:
  fia: ^<version>
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```dart
import 'package:fia/fia.dart';
```

## Usage

```dart
import 'package:fia/fia.dart';
import 'package:fia/otp_auth_type.dart';
import 'package:fia/otp_magic_redirect.dart';
import 'package:fia/otp_promise.dart';

// get instance
final fia = Fia();

// initialize
await fia.initialize("MERCHANT_KEY", "MERCHANT_APP_ID", iosGroupId: "IOS_GROUP_ID");

// request OTP with login purpose
OtpPromise otpPromise = await fia.otp().login("PHONE");
if (otpPromise.hasException) {
    final exception = otpPromise.exception;
    // handle exception here
    return;
}

// check OTP authentication type
switch (otpPromise.authType) {
    case OtpAuthType.sms:
        // on message...
        break;
    case OtpAuthType.whatsapp:
        // on message...
        break;
    case OtpAuthType.miscall:
        // on miscall...
        break;
    case OtpAuthType.he:
        // on He...
        break;
    case OtpAuthType.magicOtp:
        // on FIA...
        break;
    case OtpAuthType.magicLink:
        // on FIA...
        break;
    case OtpAuthType.voice:
        // on FIA...
        break;
};

// validate Message or Miscall OTP
try {
    await otpPromise.validate("OTP");
    // on validated
} catch (e) {
    // on error
}

// validate HE
try {
    await otpPromise.validateHE();
    // on validated
} catch (e) {
    // on error
}

// release the promise once you are done with it
await otpPromise.clean();
```

### Otp request options

Every otp request (`login`, `register`, `transaction`, `forgetPassword`) takes
an optional `additionalInfo` parameter for attaching arbitrary metadata:

```dart
await fia.otp().login("PHONE", additionalInfo: {"orderId": "12345"});
```

### Magic otp and magic link

Both auth types start by sending the user to WhatsApp to post a prepared
message. Magic otp then comes back with an otp you validate as usual; magic
link validates itself once the user taps the incoming link.

```dart
// magic otp: opens WhatsApp, then you collect and validate the otp
await otpPromise.launchWhatsappForMagicOtp();
await otpPromise.validate("OTP");

// magic link: completes once the user has tapped the link
await otpPromise.launchWhatsappForMagicLink();
```

Both take an optional `magicRedirect` to pick which WhatsApp app is opened:

```dart
await otpPromise.launchWhatsappForMagicOtp(
    magicRedirect: OtpMagicRedirect.whatsappBusiness,
);
```

It defaults to `OtpMagicRedirect.auto`, which picks WhatsApp or WhatsApp
Business automatically. Use `OtpMagicRedirect.manual` to let the user choose
when both are installed.

### Request otp with a user-preferred auth type

`otpManual()` returns every auth type available for the phone number so the
user can pick one, instead of letting the server decide.

```dart
import 'package:fia/otp_gateway_promise.dart';

OtpGatewayPromise gatewayPromise = await fia.otpManual().login("PHONE");
if (gatewayPromise.hasException) {
    final exception = gatewayPromise.exception;
    // handle exception here
    return;
}

if (gatewayPromise.isAuthenticated) {
    // the user is already authenticated and needs no otp — the flow ends here,
    // take gatewayPromise.transactionId and check the verified status
    return;
}

// show gatewayPromise.gateways to the user, then request the otp through the
// one they picked. The result is the same OtpPromise the automatic flow gives.
final gateway = gatewayPromise.gateways[SELECTED_INDEX];
OtpPromise otpPromise = await gatewayPromise.pick(gateway.number);

// release the gateway promise once you are done with it
await gatewayPromise.clean();
```

Each `OtpGateway` has a `number` (the identifier you pass to `pick`) and a
`name` (what to show the user). From here the flow is identical to the
automatic one: switch on `otpPromise.authType` and validate.

### Platform differences

| API | Android | iOS |
|---|---|---|
| `OtpPromise.listenToMiscall()` | ✅ | ❌ throws — the user types the otp in and you call `validate()` |
| `setFeatures(withVpn:)` | ✅ | ❌ ignored |
| `setFeatures(withSimNumbersAndOperators:)` | ✅ | ❌ ignored |
| `setFeatures(withAppTamperingFunction:)` | ✅ | ❌ ignored |
| `setFeatures(withSuspiciousAppFunction:)` | ✅ | ❌ ignored |

The ignored flags are not implemented by the native iOS SDK. Every other
feature flag works on both platforms.

## License

[MIT](LICENSE)
