# fia_example

Demonstrates how to use the fia plugin.

## Getting Started

The example needs merchant credentials, which are not committed.

1. `cp .env.example .env`
2. Fill in `FIA_MERCHANT_KEY` and `FIA_MERCHANT_APP_ID` with the values from your
   Fazpass dashboard.
3. `flutter pub get`
4. `flutter run`

`.env` is gitignored so the credentials never reach a commit or a published version
of the package — keep it that way. Without it the build fails with a missing asset
error.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
