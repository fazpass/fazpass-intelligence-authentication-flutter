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
            
            let promising: (OtpPromise) -> Void = { promise in
                self.promises[promise.transactionId] = promise
                
                var obj = [:]
                obj["transactionId"] = promise.transactionId
                obj["hasException"] = promise.hasError
                obj["exception"] = promise.error.localizedDescription
                obj["digitCount"] = promise.digitCount
              
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
            
            switch (purpose) {
            case "login":
              fia.otp().login(phone, promising)
            case "register":
              fia.otp().login(phone, promising)
            case "transaction":
              fia.otp().login(phone, promising)
            case "forgetPassword":
              fia.otp().login(phone, promising)
            default:
              fia.otp().login(phone, promising)
            }
        case "validateOtp":
            let transactionId = arguments["transactionId"] as! String
            let otp = arguments["otp"] as! String
            
            guard let promise = promises[transactionId] else {
                  result(FlutterError(
                    code: "PromiseNotFound",
                    message: "No such transaction.",
                    details: nil
                  ))
                  return
            }
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
        case "validateHE":
            let transactionId = arguments["transactionId"] as! String
            
            guard let promise = promises[transactionId] else {
                  result(FlutterError(
                    code: "PromiseNotFound",
                    message: "No such transaction.",
                    details: nil
                  ))
                  return
            }
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
        case "listenToMiscall":
            result("")
        case "launchWhatsappForMagicOtp":
            let transactionId = arguments["transactionId"] as! String
            
            guard let promise = promises[transactionId] else {
                  result(FlutterError(
                    code: "PromiseNotFound",
                    message: "No such transaction.",
                    details: nil
                  ))
                  return
            }
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
        case "launchWhatsappForMagicLink":
            let transactionId = arguments["transactionId"] as! String
            
            guard let promise = promises[transactionId] else {
                  result(FlutterError(
                    code: "PromiseNotFound",
                    message: "No such transaction.",
                    details: nil
                  ))
                  return
            }
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
        case "forgetPromise":
            let transactionId = arguments["transactionId"] as! String
            
            promises.removeValue(forKey: transactionId)
            result(nil)
        case "setFeatures":
            let withVpn = arguments["withVpn"] as? Bool ?? false
            let withLocation = arguments["withLocation"] as? Bool ?? false
            let withBiometricPopup = arguments["withBiometricPopup"] as? Bool ?? false
            let withBiometricLevelHigh = arguments["withBiometricLevelHigh"] as? Bool ?? false
            let withSimNumbersAndOperators = arguments["withSimNumbersAndOperators"] as? Bool ?? false
            let withOtpSpammingFunction = arguments["withVpn"] as? Bool ?? false
            let withAppTamperingFunction = arguments["withAppTamperingFunction"] as? Bool ?? false
            let withSuspiciousAppFunction = arguments["withSuspiciousAppFunction"] as? Bool ?? false
            let withPromoAbuseFunction = arguments["withPromoAbuseFunction"] as? Bool ?? false
            let promoIds = arguments["promoIds"] as? [String] ?? []
            let withAccountTakeoverFunction = arguments["withAccountTakeoverFunction"] as? Bool ?? false
            let userIdentifier = arguments["userIdentifier"] as? String ?? ""
            fia.setFeatures { $0
                //.withVpn(withVpn)
                .withLocation(withLocation)
                .withBiometricPopup(withBiometricPopup)
                .withBiometricLevelHigh(withBiometricLevelHigh)
                //.withSimNumbersAndOperators(withSimNumbersAndOperators)
                .withOtpSpammingFunction(withOtpSpammingFunction)
                //.withAppTamperingFunction(withAppTamperingFunction)
                //.withSuspiciousAppFunction(withSuspiciousAppFunction)
                //.withPromoAbuseFunction(promoIds = promoIds.toTypedArray(), withPromoAbuseFunction)
                .withAccountTakeoverFunction(userIdentifier, withAccountTakeoverFunction)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
