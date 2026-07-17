//
//  FiaMethodCallHandler.swift
//  fia
//
//  Created by Andri nova riswanto on 15/05/25.
//

import Foundation
import Flutter
import FiaIOS

class FiaMethodCallHandler {

    private let fia = FIAFactory.getInstance()

    var promises: [String:OtpPromise] = [:]

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! [String : Any]

        switch call.method {
        case "initialize":
            let merchantKey = arguments["merchantKey"] as! String
            let merchantAppId = arguments["merchantAppId"] as! String
            let groupId = arguments["iosGroupId"] as! String

            fia.initialize(merchantKey, merchantAppId, groupId)
            result(nil)
        case "otp":
            let purpose = arguments["purpose"] as! String
            let phone = arguments["phone"] as! String
            let additionalInfo = arguments["additionalInfo"] as? [String : String]
            let magicRedirect = parseMagicRedirect(arguments["magicRedirect"] as? String)

            let promising: (OtpPromise) -> Void = { promise in
                self.promises[promise.transactionId] = promise

                var obj: [String : Any] = [:]
                obj["transactionId"] = promise.transactionId
                obj["activityId"] = promise.activityId
                obj["hasException"] = promise.hasError
                obj["exception"] = promise.error.localizedDescription
                obj["digitCount"] = promise.digitCount
                obj["isBlocked"] = promise.isBlocked

                switch (promise.authType) {
                case .SMS:
                    obj["authType"] = "SMS"
                case .Whatsapp:
                    obj["authType"] = "Whatsapp"
                case .Miscall:
                    obj["authType"] = "Miscall"
                case .HE:
                    obj["authType"] = "HE"
                case .MagicOtp:
                    obj["authType"] = "MagicOtp"
                case .MagicLink:
                    obj["authType"] = "MagicLink"
                case .Voice:
                    obj["authType"] = "Voice"
                @unknown default:
                    obj["authType"] = "HE"
                }
                result(obj)
            }

            let otp = fia.otp()
            switch (purpose) {
            case "login":
                otp.login(phone, additionalInfo: additionalInfo, redirect: magicRedirect, promising)
            case "register":
                otp.register(phone, additionalInfo: additionalInfo, redirect: magicRedirect, promising)
            case "transaction":
                otp.transaction(phone, additionalInfo: additionalInfo, redirect: magicRedirect, promising)
            case "forgetPassword":
                otp.forgetPassword(phone, additionalInfo: additionalInfo, redirect: magicRedirect, promising)
            default:
                result(FlutterError(
                  code: "UnknownPurpose",
                  message: "Unknown otp purpose \"\(purpose)\".",
                  details: nil
                ))
            }
        case "validateOtp":
            let otp = arguments["otp"] as! String

            withPromise(arguments, result) { promise in
                promise.validate(
                  otp,
                  { err in
                      result(FlutterError(
                        code: "ValidateFailed",
                        message: err.localizedDescription,
                        details: nil
                      ))
                  },
                  { result(nil) }
                )
            }
        case "validateHE":
            withPromise(arguments, result) { promise in
                promise.validateHE(
                  { err in
                      result(FlutterError(
                        code: "ValidateFailed",
                        message: err.localizedDescription,
                        details: nil
                      ))
                  },
                  { result(nil) }
                )
            }
        case "listenToMiscall":
            // The native iOS SDK has no miscall listener; the user types the
            // otp in and it goes through validateOtp instead.
            result(FlutterError(
              code: "UnsupportedOnIOS",
              message: "listenToMiscall is only available on Android.",
              details: nil
            ))
        case "launchWhatsappForMagicOtp":
            withPromise(arguments, result) { promise in
                promise.launchWhatsappForMagicOtp(
                  { err in
                      result(FlutterError(
                        code: "ValidateFailed",
                        message: err.localizedDescription,
                        details: nil
                      ))
                  },
                  { result(nil) }
                )
            }
        case "launchWhatsappForMagicLink":
            withPromise(arguments, result) { promise in
                promise.launchWhatsappForMagicLink(
                  { err in
                      result(FlutterError(
                        code: "ValidateFailed",
                        message: err.localizedDescription,
                        details: nil
                      ))
                  },
                  { result(nil) }
                )
            }
        case "forgetPromise":
            let transactionId = arguments["transactionId"] as! String

            promises.removeValue(forKey: transactionId)
            result(nil)
        case "setFeatures":
            let withLocation = arguments["withLocation"] as? Bool ?? false
            let withBiometricPopup = arguments["withBiometricPopup"] as? Bool ?? false
            let withBiometricLevelHigh = arguments["withBiometricLevelHigh"] as? Bool ?? false
            let withOtpSpammingFunction = arguments["withOtpSpammingFunction"] as? Bool ?? false
            let withPromoAbuseFunction = arguments["withPromoAbuseFunction"] as? Bool ?? false
            let promoIds = arguments["promoIds"] as? [String] ?? []
            let withAccountTakeoverFunction = arguments["withAccountTakeoverFunction"] as? Bool ?? false
            let userIdentifier = arguments["userIdentifier"] as? String ?? ""
            // withVpn, withSimNumbersAndOperators, withAppTamperingFunction and
            // withSuspiciousAppFunction are android only: DeviceIntelligenceIOS
            // does not implement them, so they are ignored here.
            fia.setFeatures { $0
                .withLocation(withLocation)
                .withBiometricPopup(withBiometricPopup)
                .withBiometricLevelHigh(withBiometricLevelHigh)
                .withOtpSpammingFunction(withOtpSpammingFunction)
                .withPromoAbuseFunction(promoIds, withPromoAbuseFunction)
                .withAccountTakeoverFunction(userIdentifier, withAccountTakeoverFunction)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func onMagicLink(userActivity: NSUserActivity) {
        fia.onMagicLink(userActivity: userActivity)
    }

    func onMagicLink(url: String) {
        fia.onMagicLink(url: url)
    }

    // Errors out when the promise is gone, so the dart side never waits
    // forever on a result that can no longer arrive.
    private func withPromise(
        _ arguments: [String : Any],
        _ result: @escaping FlutterResult,
        _ block: (OtpPromise) -> Void
    ) {
        let transactionId = arguments["transactionId"] as! String

        guard let promise = promises[transactionId] else {
            result(FlutterError(
              code: "PromiseNotFound",
              message: "No such transaction.",
              details: nil
            ))
            return
        }
        block(promise)
    }

    private func parseMagicRedirect(_ name: String?) -> OtpMagicRedirect {
        switch name {
        case "WHATSAPP_NORMAL":
            return .WHATSAPP_NORMAL
        case "WHATSAPP_BUSINESS":
            return .WHATSAPP_BUSINESS
        case "MANUAL":
            return .MANUAL
        default:
            return .AUTO
        }
    }
}
