# Changelog

## 1.2.0

Wraps native FIA android 1.2.7 and ios 1.2.5.

* Added `magicRedirect` to every otp request, to pick which WhatsApp app is
  opened for the magic otp and magic link auth types.
* Added `additionalInfo` to every otp request, for attaching arbitrary
  key/value metadata.
* Added `OtpPromise.activityId` and `OtpPromise.isBlocked`.
* ios: Fixed `register()`, `transaction()` and `forgetPassword()` requesting a
  login otp instead of their own purpose.
* ios: Fixed `withOtpSpammingFunction` being read from the `withVpn` flag.
  android: Same fix.
* ios: Enabled `withPromoAbuseFunction`, which the native SDK does support.
* ios: Magic link now completes. The native `onMagicLink` callback was never
  forwarded, so tapping the link did nothing.
* Requests for an unknown otp purpose, or for a transaction that is no longer
  held, now fail instead of never completing.
* ios: `listenToMiscall()` now fails as unsupported instead of silently
  returning an empty otp. It is android only.

## 1.1.0

* Security patch update
* ios: Fixed error message
* ios: Updated initialize function

## 1.0.3

* Fixed logging error.

## 1.0.2

* Enabled pro-feature configuration for OTP request.

## 1.0.1

* Removed channel FIA.

## 1.0.0

* Updated to match native FIA version 1.1.0

## 0.0.2

* Platform iOS finished.

## 0.0.1

* Platform android finished.
