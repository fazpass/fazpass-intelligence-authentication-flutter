package com.fazpass.fia

import android.app.Activity
import com.fazpass.fia.objects.OtpPromise
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

private typealias TransactionId = String

internal class FiaMethodCallHandler: MethodCallHandler {

    private val fia = FIAFactory.getInstance()

    private val promises = hashMapOf<TransactionId, OtpPromise>()
    var activity: Activity? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val currentActivity = activity
        if (currentActivity == null) {
            result.error(
                "NoActivityAttached",
                "Activity hasn't been attached yet.",
                null
            )
            return
        }

        when (call.method) {
            "initialize" -> {
                val merchantKey = call.argument<String>("merchantKey")!!
                val merchantAppId = call.argument<String>("merchantAppId")!!
                fia.initialize(currentActivity, merchantKey, merchantAppId)
                result.success(null)
            }
            "otp" -> {
                val purpose = call.argument<String>("purpose")!!
                val phone = call.argument<String>("phone")!!
                val callback = { it: OtpPromise ->
                    promises[it.transactionId] = it
                    result.success(otpPromiseToMap(it))
                }
                when (purpose) {
                    "login" -> fia.otp(currentActivity).login(phone, callback)
                    "register" -> fia.otp(currentActivity).register(phone, callback)
                    "transaction" -> fia.otp(currentActivity).transaction(phone, callback)
                    "forgetPassword" -> fia.otp(currentActivity).forgetPassword(phone, callback)
                }
            }
            "validateOtp" -> {
                val transactionId = call.argument<String>("transactionId")!!
                val otp = call.argument<String>("otp")!!
                val promise = promises[transactionId]
                promise?.let {
                    it.validate(
                        otp,
                        { err -> result.error(err::class.java.name, err.message, null) },
                        { result.success(null) }
                    )
                }
            }
            "validateHE" -> {
                val transactionId = call.argument<String>("transactionId")!!
                val promise = promises[transactionId]
                promise?.let {
                    it.validateHE(
                        { err -> result.error(err::class.java.name, err.message, null) },
                        { result.success(null) }
                    )
                }
            }
            "listenToMiscall" -> {
                val transactionId = call.argument<String>("transactionId")!!
                val promise = promises[transactionId]
                promise?.let { it.listenToMiscall { otp -> result.success(otp) } }
            }
            "launchWhatsappForMagicOtp" -> {
                val transactionId = call.argument<String>("transactionId")!!
                val promise = promises[transactionId]
                promise?.let {
                    it.launchWhatsappForMagicOtp(
                        { err -> result.error(err::class.java.name, err.message, null) },
                        { result.success(null) }
                    )
                }
            }
            "launchWhatsappForMagicLink" -> {
                val transactionId = call.argument<String>("transactionId")!!
                val promise = promises[transactionId]
                promise?.let {
                    it.launchWhatsappForMagicLink(
                        { err -> result.error(err::class.java.name, err.message, null) },
                        { result.success(null) }
                    )
                }
            }
            "forgetPromise" -> {
                val transactionId = call.argument<String>("transactionId")!!
                promises.remove(transactionId)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun otpPromiseToMap(promise: OtpPromise): HashMap<String, Any> {
        return hashMapOf(
            "transactionId" to promise.transactionId,
            "hasException" to promise.hasException,
            "exception" to promise.exception.stackTraceToString(),
            "digitCount" to promise.digitCount,
            "authType" to promise.authType.name
        )
    }
}