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

// get instance
final fia = Fia();

// initialize
fia.initialize("MERCHANT_KEY", "MERCHANT_APP_ID");

// request OTP with login purpose
OtpPromise otpPromise = await fia.otp().login("PHONE");
if (otpPromise.hasException) {
    final exception = otpPromise.exception;
    // handle exception here
    return;
}

// check OTP authentication type
switch (otpPromise.authType) {
    case OtpAuthType.message:
        // on message...
        break;
    case OtpAuthType.miscall:
        // on miscall...
        break;
    case OtpAuthType.he:
        // on He...
        break;
    case OtpAuthType.fia:
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
```

## License

[MIT](LICENSE)
