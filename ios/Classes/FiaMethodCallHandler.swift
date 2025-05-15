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
            
            fia.initialize(merchantKey, merchantAppId)
            result(nil)
        case "otp":
            let purpose = arguments["purpose"] as! String
            let phone = arguments["phone"] as! String
            
            let promising: (OtpPromise) -> Void = { promise in
              self.promises[promise.transactionId] = promise
              
              var obj = [:]
              obj["transactionId"] = promise.transactionId
              obj["hasException"] = promise.hasError
              
              switch (promise.authType) {
              case .Message:
                obj["authType"] = "Message"
                break
              case .Miscall:
                obj["authType"] = "Miscall"
                break
              case .HE:
                obj["authType"] = "He"
                break
              case .FIA:
                obj["authType"] = "FIA"
                break
              @unknown default:
                obj["authType"] = "Message"
                break
              }

              if (promise.hasError) {
                obj["exception"] = promise.error.localizedDescription
              } else {
                obj["exception"] = nil
              }
              
              if (promise.authType == OtpAuthType.Message
                || promise.authType == OtpAuthType.Miscall) {
                obj["digitCount"] = promise.digitCount
              } else {
                obj["digitCount"] = nil
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
        case "forgetPromise":
            let transactionId = arguments["transactionId"] as! String
            
            promises.removeValue(forKey: transactionId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
