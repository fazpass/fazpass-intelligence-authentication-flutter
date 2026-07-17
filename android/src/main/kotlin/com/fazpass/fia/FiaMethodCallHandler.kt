package com.fazpass.fia

import android.annotation.SuppressLint
import android.app.Activity
import com.fazpass.fia.objects.OtpMagicRedirect
import com.fazpass.fia.objects.OtpPromise
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

private typealias TransactionId = String

internal class FiaMethodCallHandler: MethodCallHandler {

    private val fia = FIAFactory.getInstance()

    private val promises = hashMapOf<TransactionId, OtpPromise>()
    var activity: Activity? = null

    @SuppressLint("MissingPermission")
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
                val additionalInfo = call.argument<Map<String, String>>("additionalInfo")
                val magicRedirect = parseMagicRedirect(call.argument<String>("magicRedirect"))
                val callback = { it: OtpPromise ->
                    promises[it.transactionId] = it
                    result.success(otpPromiseToMap(it))
                }
                val otp = fia.otp(currentActivity)
                when (purpose) {
                    "login" ->
                        if (additionalInfo == null) otp.login(phone, magicRedirect, callback)
                        else otp.login(phone, additionalInfo, magicRedirect, callback)
                    "register" ->
                        if (additionalInfo == null) otp.register(phone, magicRedirect, callback)
                        else otp.register(phone, additionalInfo, magicRedirect, callback)
                    "transaction" ->
                        if (additionalInfo == null) otp.transaction(phone, magicRedirect, callback)
                        else otp.transaction(phone, additionalInfo, magicRedirect, callback)
                    "forgetPassword" ->
                        if (additionalInfo == null) otp.forgetPassword(phone, magicRedirect, callback)
                        else otp.forgetPassword(phone, additionalInfo, magicRedirect, callback)
                    else -> result.error(
                        "UnknownPurpose",
                        "Unknown otp purpose \"$purpose\".",
                        null
                    )
                }
            }
            "validateOtp" -> withPromise(call, result) {
                val otp = call.argument<String>("otp")!!
                it.validate(
                    otp,
                    { err -> result.error(err::class.java.name, err.message, null) },
                    { result.success(null) }
                )
            }
            "validateHE" -> withPromise(call, result) {
                it.validateHE(
                    { err -> result.error(err::class.java.name, err.message, null) },
                    { result.success(null) }
                )
            }
            "listenToMiscall" -> withPromise(call, result) {
                it.listenToMiscall(
                    { err -> result.error(err::class.java.name, err.message, null) },
                    { otp -> result.success(otp) }
                )
            }
            "launchWhatsappForMagicOtp" -> withPromise(call, result) {
                it.launchWhatsappForMagicOtp(
                    { err -> result.error(err::class.java.name, err.message, null) },
                    { result.success(null) }
                )
            }
            "launchWhatsappForMagicLink" -> withPromise(call, result) {
                it.launchWhatsappForMagicLink(
                    { err -> result.error(err::class.java.name, err.message, null) },
                    { result.success(null) }
                )
            }
            "forgetPromise" -> {
                val transactionId = call.argument<String>("transactionId")!!
                promises.remove(transactionId)
                result.success(null)
            }
            "setFeatures" -> {
                val withVpn = call.argument<Boolean>("withVpn") ?: false
                val withLocation = call.argument<Boolean>("withLocation") ?: false
                val withBiometricPopup = call.argument<Boolean>("withBiometricPopup") ?: false
                val withBiometricLevelHigh = call.argument<Boolean>("withBiometricLevelHigh") ?: false
                val withSimNumbersAndOperators = call.argument<Boolean>("withSimNumbersAndOperators") ?: false
                val withOtpSpammingFunction = call.argument<Boolean>("withOtpSpammingFunction") ?: false
                val withAppTamperingFunction = call.argument<Boolean>("withAppTamperingFunction") ?: false
                val withSuspiciousAppFunction = call.argument<Boolean>("withSuspiciousAppFunction") ?: false
                val withPromoAbuseFunction = call.argument<Boolean>("withPromoAbuseFunction") ?: false
                val promoIds = call.argument<List<String>>("promoIds") ?: listOf()
                val withAccountTakeoverFunction = call.argument<Boolean>("withAccountTakeoverFunction") ?: false
                val userIdentifier = call.argument<String>("userIdentifier") ?: ""
                fia.setFeatures { it
                    .withVpn(withVpn)
                    .withLocation(withLocation)
                    .withBiometricPopup(withBiometricPopup)
                    .withBiometricLevelHigh(withBiometricLevelHigh)
                    .withSimNumbersAndOperators(withSimNumbersAndOperators)
                    .withOtpSpammingFunction(withOtpSpammingFunction)
                    .withAppTamperingFunction(withAppTamperingFunction)
                    .withSuspiciousAppFunction(withSuspiciousAppFunction)
                    .withPromoAbuseFunction(promoIds = promoIds.toTypedArray(), withPromoAbuseFunction)
                    .withAccountTakeoverFunction(userIdentifier, withAccountTakeoverFunction)
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    // Errors out when the promise is gone, so the dart side never waits
    // forever on a result that can no longer arrive.
    private fun withPromise(
        call: MethodCall,
        result: MethodChannel.Result,
        block: (OtpPromise) -> Unit
    ) {
        val transactionId = call.argument<String>("transactionId")!!
        val promise = promises[transactionId]
        if (promise == null) {
            result.error("PromiseNotFound", "No such transaction.", null)
            return
        }
        block(promise)
    }

    private fun parseMagicRedirect(name: String?): OtpMagicRedirect = when (name) {
        "WHATSAPP_NORMAL" -> OtpMagicRedirect.WHATSAPP_NORMAL
        "WHATSAPP_BUSINESS" -> OtpMagicRedirect.WHATSAPP_BUSINESS
        "MANUAL" -> OtpMagicRedirect.MANUAL
        else -> OtpMagicRedirect.AUTO
    }

    private fun otpPromiseToMap(promise: OtpPromise): HashMap<String, Any> {
        return hashMapOf(
            "transactionId" to promise.transactionId,
            "activityId" to promise.activityId,
            "hasException" to promise.hasException,
            "exception" to promise.exception.stackTraceToString(),
            "digitCount" to promise.digitCount,
            "isBlocked" to promise.isBlocked,
            "authType" to promise.authType.name
        )
    }
}
