/// Controls which WhatsApp app is used when redirecting for the
/// [OtpAuthType.magicOtp] and [OtpAuthType.magicLink] auth types.
enum OtpMagicRedirect {
  /// Automatically selects WhatsApp or WhatsApp Business.
  auto,

  /// Always redirects to WhatsApp.
  whatsappNormal,

  /// Always redirects to WhatsApp Business.
  whatsappBusiness,

  /// Shows a dialog letting the user choose which WhatsApp app to use when
  /// both WhatsApp and WhatsApp Business are installed.
  manual;

  /// The value as the native SDKs name it.
  String get nativeName => switch (this) {
    OtpMagicRedirect.auto => 'AUTO',
    OtpMagicRedirect.whatsappNormal => 'WHATSAPP_NORMAL',
    OtpMagicRedirect.whatsappBusiness => 'WHATSAPP_BUSINESS',
    OtpMagicRedirect.manual => 'MANUAL',
  };
}
