package com.kochava.kochava_tracker

//
//  KochavaTracker (Flutter)
//
//  Copyright (c) 2020 - 2022 Kochava, Inc. All rights reserved.
//

import android.content.Context
import android.util.Log
import com.kochava.core.util.internal.TextUtil
import com.kochava.tracker.Tracker
import com.kochava.tracker.engagement.Engagement
import com.kochava.tracker.events.Event
import com.kochava.tracker.events.Events
import com.kochava.tracker.log.LogLevel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/**
 * Kochava Tracker Plugin
 */
class KochavaTrackerPlugin : FlutterPlugin, MethodCallHandler {
    private val LOGTAG = "KVA/Tracker"
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    /**
     * Attached to the flutter engine.
     */
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kochava_tracker")
        channel.setMethodCallHandler(this)
    }

    /**
     * Detached from the flutter engine.
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Handler for method calls from the Dart/Flutter layer to the native.
     */
    override fun onMethodCall(call: MethodCall, result: Result) {
        val isFailure = runCatching {
            return when (call.method) {
                // void executeAdvancedInstruction(string name, string value)
                "executeAdvancedInstruction" -> {
                    val name = call.argument("name") ?: ""
                    val value = call.argument("value") ?: ""
                    Tracker.getInstance().executeAdvancedInstruction(name, value)
                    result.success(null)
                }

                // void setLogLevel(LogLevel logLevel)
                "setLogLevel" -> {
                    Tracker.getInstance().setLogLevel(LogLevel.fromString(call.arguments()))
                    result.success(null)
                }

                // void setSleep(bool sleep)
                "setSleep" -> {
                    Tracker.getInstance().setSleep(call.arguments())
                    result.success(null)
                }

                // void setAppLimitAdTracking(bool appLimitAdTracking)
                "setAppLimitAdTracking" -> {
                    Tracker.getInstance().setAppLimitAdTracking(call.arguments())
                    result.success(null)
                }

                // void registerCustomDeviceIdentifier(string name, string value)
                "registerCustomDeviceIdentifier" -> {
                    val name = call.argument("name") ?: ""
                    val value = call.argument("value") ?: ""
                    Tracker.getInstance().registerCustomDeviceIdentifier(name, value)
                    result.success(null)
                }

                // void registerIdentityLink(string name, string value)
                "registerIdentityLink" -> {
                    val name = call.argument("name") ?: ""
                    val value = call.argument("value") ?: ""
                    Tracker.getInstance().registerIdentityLink(name, value)
                    result.success(null)
                }

                // void enableAndroidInstantApps(string instantAppGuid)
                "enableAndroidInstantApps" -> {
                    Tracker.getInstance().enableInstantApps(call.arguments())
                    result.success(null)
                }

                // void enableIosAppClips(string identifier)
                "enableIosAppClips" -> {
                    Log.w(LOGTAG, "enableIosAppClips API is not available on this platform.")
                    result.success(null)
                }

                // void enableIosAtt()
                "enableIosAtt" -> {
                    Log.w(LOGTAG, "enableIosAtt API is not available on this platform.")
                    result.success(null)
                }

                // void setIosAttAuthorizationWaitTime(double waitTime)
                "setIosAttAuthorizationWaitTime" -> {
                    Log.w(LOGTAG, "setIosAttAuthorizationWaitTime API is not available on this platform.")
                    result.success(null)
                }

                // void setIosAttAuthorizationAutoRequest(bool autoRequest)
                "setIosAttAuthorizationAutoRequest" -> {
                    Log.w(LOGTAG, "setIosAttAuthorizationAutoRequest API is not available on this platform.")
                    result.success(null)
                }

                // void registerPrivacyProfile(string name, string[] keys)
                "registerPrivacyProfile" -> {
                    val name = call.argument("name") ?: ""
                    val keys = call.argument("keys") ?: emptyList<String>()
                    Tracker.getInstance().registerPrivacyProfile(name, keys.toTypedArray())
                    result.success(null)
                }

                // void setPrivacyProfileEnabled(string name, bool enabled)
                "setPrivacyProfileEnabled" -> {
                    val name = call.argument("name") ?: ""
                    val enabled = call.argument("enabled") ?: false
                    Tracker.getInstance().setPrivacyProfileEnabled(name, enabled)
                    result.success(null)
                }

                // bool getStarted()
                "getStarted" -> {
                    result.success(Tracker.getInstance().isStarted)
                }

                // void start(string androidAppGuid, string iosAppGuid, string partnerName)
                "start" -> {
                    val androidAppGuid = call.argument("androidAppGuid") ?: ""
                    val partnerName = call.argument("partnerName") ?: ""
                    if (!TextUtil.isNullOrBlank(androidAppGuid)) {
                        Tracker.getInstance().startWithAppGuid(context, androidAppGuid)
                    } else if (!TextUtil.isNullOrBlank(partnerName)) {
                        Tracker.getInstance().startWithPartnerName(context, partnerName)
                    } else {
                        // Allow the native to log the error of no app guid.
                        Tracker.getInstance().startWithAppGuid(context, "")
                    }
                    result.success(null)
                }

                // void shutdown(bool deleteData)
                "shutdown" -> {
                    Tracker.getInstance().shutdown(context, call.arguments())
                    result.success(null)
                }

                // string getDeviceId()
                "getDeviceId" -> {
                    result.success(Tracker.getInstance().deviceId)
                }

                // InstallAttribution getInstallAttribution()
                "getInstallAttribution" -> {
                    val installAttribution = Tracker.getInstance().installAttribution
                    result.success(installAttribution.toJson().toString())
                }

                // void retrieveInstallAttribution(Callback<InstallAttribution> callback)
                "retrieveInstallAttribution" -> {
                    Tracker.getInstance().retrieveInstallAttribution { installAttribution ->
                        result.success(installAttribution.toJson().toString())
                    }
                }
                
                // void processDeeplink(string path, Callback<Deeplink> callback)
                "processDeeplink" -> {
                    val path = call.arguments() ?: ""
                    Tracker.getInstance().processDeeplink(path) { deeplink ->
                        result.success(deeplink.toJson().toString())
                    }
                }

                // void processDeeplinkWithOverrideTimeout(string path, double timeout, Callback<Deeplink> callback)
                "processDeeplinkWithOverrideTimeout" -> {
                    val path = call.argument("path") ?: ""
                    val timeout = call.argument("timeout") ?: 10.0
                    Tracker.getInstance().processDeeplink(path, timeout) { deeplink ->
                        result.success(deeplink.toJson().toString())
                    }
                }

                // void registerPushToken(string token)
                "registerPushToken" -> {
                    Engagement.getInstance().registerPushToken(call.arguments())
                    result.success(null)
                }

                // void setPushEnabled(bool enabled)
                "setPushEnabled" -> {
                    Engagement.getInstance().setPushEnabled(call.arguments())
                    result.success(null)
                }

                // void sendEvent(string name)
                "sendEvent" -> {
                    Events.getInstance().send(call.arguments())
                    result.success(null)
                }

                // void sendEventWithString(string name, string data)
                "sendEventWithString" -> {
                    val name = call.argument("name") ?: ""
                    val data = call.argument("data") ?: ""
                    Events.getInstance().sendWithString(name, data)
                    result.success(null)
                }

                // void sendEventWithDictionary(string name, object data)
                "sendEventWithDictionary" -> {
                    val name = call.argument("name") ?: ""
                    val data = call.argument<Map<String, Any>>("data") ?: HashMap<String, Any>()
                    Events.getInstance().sendWithDictionary(name, data)
                    result.success(null)
                }

                // void sendEventWithEvent(Event event)
                "sendEventWithEvent" -> {
                    val name = call.argument("name") ?: ""
                    val data = call.argument<Map<String, Any>>("data") ?: HashMap<String, Any>()
                    val androidGooglePlayReceiptData = call.argument("androidGooglePlayReceiptData") ?: ""
                    val androidGooglePlayReceiptSignature = call.argument("androidGooglePlayReceiptSignature") ?: ""
                    Event.buildWithEventName(name).apply {
                        mergeCustomDictionary(data)
                        if(!TextUtil.isNullOrBlank(androidGooglePlayReceiptData) && !TextUtil.isNullOrBlank(androidGooglePlayReceiptSignature)) {
                            setGooglePlayReceipt(androidGooglePlayReceiptData, androidGooglePlayReceiptSignature);
                        }
                        send()
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }.isFailure
        if (isFailure) {
            result.error("1234", "Failed to process: ${call.method}", null)
        }
    }
}
