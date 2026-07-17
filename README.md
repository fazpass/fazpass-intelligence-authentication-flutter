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
two optional parameters:

```dart
await fia.otp().login(
    "PHONE",
    // attach arbitrary metadata to the request
    additionalInfo: {"orderId": "12345"},
    // pick which WhatsApp app the magic otp / magic link auth types open
    magicRedirect: OtpMagicRedirect.whatsappBusiness,
);
```

`magicRedirect` defaults to `OtpMagicRedirect.auto`, which picks WhatsApp or
WhatsApp Business automatically. Use `OtpMagicRedirect.manual` to let the user
choose when both are installed.

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
