///
///  KochavaTracker (Flutter)
///
///  Copyright (c) 2020 - 2022 Kochava, Inc. All rights reserved.
///

///
/// Kochava Tracker SDK
///
/// A lightweight and easy to integrate SDK, providing first-class integration with Kochava’s installation attribution and analytics platform.
///
/// Getting Started: https://support.kochava.com/sdk-integration/flutter-sdk-integration
///
library kochava_tracker;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

///
/// Kochava Tracker Deeplink Result
///
class KochavaTrackerDeeplink {
  final String destination;
  final Map<String, dynamic> raw;

  /// Constructor
  KochavaTrackerDeeplink._(
    this.destination,
    this.raw,
  );

  /// Default Value Constructor
  KochavaTrackerDeeplink.withDefaults()
      : destination = "",
        raw = Map();

  /// From Json Constructor
  factory KochavaTrackerDeeplink(Map<String, dynamic> json) {
    final String destination = json["destination"];
    final Map<String, dynamic> raw = json["raw"];
    return KochavaTrackerDeeplink._(destination, raw);
  }
}

///
/// Kochava Tracker Install Attribution Result
///
class KochavaTrackerInstallAttribution {
  final bool retrieved;
  final Map<String, dynamic> raw;
  final bool attributed;
  final bool firstInstall;

  /// Constructor
  KochavaTrackerInstallAttribution._(
    this.retrieved,
    this.raw,
    this.attributed,
    this.firstInstall,
  );

  /// Default Value Constructor
  KochavaTrackerInstallAttribution.withDefaults()
      : retrieved = false,
        raw = Map(),
        attributed = false,
        firstInstall = false;

  /// Json Json Constructor
  factory KochavaTrackerInstallAttribution(Map<String, dynamic> json) {
    final bool retrieved = json["retrieved"];
    final Map<String, dynamic> raw = json["raw"];
    final bool attributed = json["attributed"];
    final bool firstInstall = json["firstInstall"];
    return KochavaTrackerInstallAttribution._(
        retrieved, raw, attributed, firstInstall);
  }
}

/// Log Levels
///
/// Defaults to Info
///
enum KochavaTrackerLogLevel {
  None,
  Error,
  Warn,
  Info,
  Debug,
  Trace,
}

///
/// Standard Event Types
///
/// For samples and expected usage see: https://support.kochava.com/reference-information/post-install-event-examples/
///
enum KochavaTrackerEventType {
  Achievement,
  AddToCart,
  AddToWishList,
  CheckoutStart,
  LevelComplete,
  Purchase,
  Rating,
  RegistrationComplete,
  Search,
  TutorialComplete,
  View,
  AdView,
  PushReceived,
  PushOpened,
  ConsentGranted,
  Deeplink,
  AdClick,
  StartTrial,
  Subscribe,
}

///
/// Kochava Tracker Event
///
class KochavaTrackerEvent {
  final String _eventName;
  final Map<String, dynamic> _eventData = Map();
  String? _iosAppStoreReceiptBase64String;
  String? _androidGooglePlayReceiptData;
  String? _androidGooglePlayReceiptSignature;

  /// Constructor
  KochavaTrackerEvent.withName(this._eventName);

  /// Event Type Constructor
  factory KochavaTrackerEvent.withType(KochavaTrackerEventType eventType) {
    switch (eventType) {
      case KochavaTrackerEventType.Achievement:
        return KochavaTrackerEvent.withName("Achievement");
      case KochavaTrackerEventType.AddToCart:
        return KochavaTrackerEvent.withName("Add to Cart");
      case KochavaTrackerEventType.AddToWishList:
        return KochavaTrackerEvent.withName("Add to Wish List");
      case KochavaTrackerEventType.CheckoutStart:
        return KochavaTrackerEvent.withName("Checkout Start");
      case KochavaTrackerEventType.LevelComplete:
        return KochavaTrackerEvent.withName("Level Complete");
      case KochavaTrackerEventType.Purchase:
        return KochavaTrackerEvent.withName("Purchase");
      case KochavaTrackerEventType.Rating:
        return KochavaTrackerEvent.withName("Rating");
      case KochavaTrackerEventType.RegistrationComplete:
        return KochavaTrackerEvent.withName("Registration Complete");
      case KochavaTrackerEventType.Search:
        return KochavaTrackerEvent.withName("Search");
      case KochavaTrackerEventType.TutorialComplete:
        return KochavaTrackerEvent.withName("Tutorial Complete");
      case KochavaTrackerEventType.View:
        return KochavaTrackerEvent.withName("View");
      case KochavaTrackerEventType.AdView:
        return KochavaTrackerEvent.withName("Ad View");
      case KochavaTrackerEventType.PushReceived:
        return KochavaTrackerEvent.withName("Push Received");
      case KochavaTrackerEventType.PushOpened:
        return KochavaTrackerEvent.withName("Push Opened");
      case KochavaTrackerEventType.ConsentGranted:
        return KochavaTrackerEvent.withName("Consent Granted");
      case KochavaTrackerEventType.Deeplink:
        return KochavaTrackerEvent.withName("_Deeplink");
      case KochavaTrackerEventType.AdClick:
        return KochavaTrackerEvent.withName("Ad Click");
      case KochavaTrackerEventType.StartTrial:
        return KochavaTrackerEvent.withName("Start Trial");
      case KochavaTrackerEventType.Subscribe:
        return KochavaTrackerEvent.withName("Subscribe");
      default:
        return KochavaTrackerEvent.withName("");
    }
  }

  /// Send the event.
  void send() {
    KochavaTracker.instance.sendEventWithEvent(this);
  }

  /// Set a custom key/value on the event where the type of the value is a string.
  void setCustomStringValue(String key, String value) {
    if (key.isNotEmpty && value.isNotEmpty) {
      _eventData[key] = value;
    }
  }

  /// Set a custom key/value on the event where the type of the value is a boolean.
  void setCustomBoolValue(String key, bool value) {
    if (key.isNotEmpty) {
      _eventData[key] = value;
    }
  }

  /// Set a custom key/value on the event where the type of the value is a number.
  void setCustomNumberValue(String key, num value) {
    if (key.isNotEmpty) {
      _eventData[key] = value;
    }
  }

  /// (Internal) Set a custom key/value on the event where the type of the value is a dictionary.
  void _setCustomDictionaryValue(String key, Map<String, dynamic> value) {
    if (key.isNotEmpty) {
      _eventData[key] = value;
    }
  }

  /// (Android Only) Set the receipt from the Android Google Play Store.
  void setAndroidGooglePlayReceipt(String data, String signature) {
    if (data.isNotEmpty && signature.isNotEmpty) {
      _androidGooglePlayReceiptData = data;
      _androidGooglePlayReceiptSignature = signature;
    }
  }

  /// (iOS Only) Set the receipt from the iOS Apple App Store.
  void setIosAppStoreReceipt(String base64String) {
    if (base64String.isNotEmpty) {
      _iosAppStoreReceiptBase64String = base64String;
    }
  }

  ///
  /// Standard Event Parameters.
  ///
  void setAction(String value) => setCustomStringValue("action", value);
  void setBackground(bool value) => setCustomBoolValue("background", value);
  void setCheckoutAsGuest(String value) =>
      setCustomStringValue("checkout_as_guest", value);
  void setCompleted(bool value) => setCustomBoolValue("completed", value);
  void setContentId(String value) => setCustomStringValue("content_id", value);
  void setContentType(String value) =>
      setCustomStringValue("content_type", value);
  void setCurrency(String value) => setCustomStringValue("currency", value);
  void setDate(String value) => setCustomStringValue("date", value);
  void setDescription(String value) =>
      setCustomStringValue("description", value);
  void setDestination(String value) =>
      setCustomStringValue("destination", value);
  void setDuration(num value) => setCustomNumberValue("duration", value);
  void setEndDate(String value) => setCustomStringValue("end_date", value);
  void setItemAddedFrom(String value) =>
      setCustomStringValue("item_added_from", value);
  void setLevel(String value) => setCustomStringValue("level", value);
  void setMaxRatingValue(num value) =>
      setCustomNumberValue("max_rating_value", value);
  void setName(String value) => setCustomStringValue("name", value);
  void setOrderId(String value) => setCustomStringValue("order_id", value);
  void setOrigin(String value) => setCustomStringValue("origin", value);
  void setPayload(Map<String, dynamic> value) =>
      _setCustomDictionaryValue("payload", value);
  void setPrice(num value) => setCustomNumberValue("price", value);
  void setQuantity(num value) => setCustomNumberValue("quantity", value);
  void setRatingValue(num value) => setCustomNumberValue("rating_value", value);
  void setReceiptId(String value) => setCustomStringValue("receipt_id", value);
  void setReferralFrom(String value) =>
      setCustomStringValue("referral_from", value);
  void setRegistrationMethod(String value) =>
      setCustomStringValue("registration_method", value);
  void setResults(String value) => setCustomStringValue("results", value);
  void setScore(String value) => setCustomStringValue("score", value);
  void setSearchTerm(String value) =>
      setCustomStringValue("search_term", value);
  void setSource(String value) => setCustomStringValue("source", value);
  void setSpatialX(num value) => setCustomNumberValue("spatial_x", value);
  void setSpatialY(num value) => setCustomNumberValue("spatial_y", value);
  void setSpatialZ(num value) => setCustomNumberValue("spatial_z", value);
  void setStartDate(String value) => setCustomStringValue("start_date", value);
  void setSuccess(String value) => setCustomStringValue("success", value);
  void setUri(String value) => setCustomStringValue("uri", value);
  void setUserId(String value) => setCustomStringValue("user_id", value);
  void setUserName(String value) => setCustomStringValue("user_name", value);
  void setValidated(String value) => setCustomStringValue("validated", value);

  ///
  /// Ad LTV Event Parameters
  ///
  void setAdCampaignId(String value) =>
      setCustomStringValue("ad_campaign_id", value);
  void setAdCampaignName(String value) =>
      setCustomStringValue("ad_campaign_name", value);
  void setAdDeviceType(String value) =>
      setCustomStringValue("device_type", value);
  void setAdGroupId(String value) => setCustomStringValue("ad_group_id", value);
  void setAdGroupName(String value) =>
      setCustomStringValue("ad_group_name", value);
  void setAdMediationName(String value) =>
      setCustomStringValue("ad_mediation_name", value);
  void setAdNetworkName(String value) =>
      setCustomStringValue("ad_network_name", value);
  void setAdPlacement(String value) => setCustomStringValue("placement", value);
  void setAdSize(String value) => setCustomStringValue("ad_size", value);
  void setAdType(String value) => setCustomStringValue("ad_type", value);

  /// Return all the event info in the form to pass down to the native layer.
  Map<String, dynamic> getData() {
    return {
      "name": _eventName,
      "data": _eventData,
      "iosAppStoreReceiptBase64String": _iosAppStoreReceiptBase64String,
      "androidGooglePlayReceiptData": _androidGooglePlayReceiptData,
      "androidGooglePlayReceiptSignature": _androidGooglePlayReceiptSignature,
    };
  }
}

///
/// Kochava Tracker SDK
///
class KochavaTracker {
  /// Internal Singleton Instance
  static final KochavaTracker _instance = KochavaTracker._();

  /// Singleton Instance.
  static KochavaTracker get instance => _instance;

  /// Internal State
  final MethodChannel _channel = const MethodChannel('kochava_tracker');
  String? _registeredAndroidAppGuid;
  String? _registeredIosAppGuid;
  String? _registeredPartnerName;

  /// Private Constructor
  KochavaTracker._();

  /// Reserved function, only use if directed to by your Client Success Manager.
  void executeAdvancedInstruction(String name, String value) {
    _invokeChannel(
      "executeAdvancedInstruction",
      {
        "name": name,
        "value": value,
      },
    );
  }

  /// Set the log level. This should be set prior to starting the SDK.
  void setLogLevel(KochavaTrackerLogLevel logLevel) {
    String logLevelString = "info";
    switch (logLevel) {
      case KochavaTrackerLogLevel.None:
        logLevelString = "none";
        break;
      case KochavaTrackerLogLevel.Error:
        logLevelString = "error";
        break;
      case KochavaTrackerLogLevel.Warn:
        logLevelString = "warn";
        break;
      case KochavaTrackerLogLevel.Info:
        logLevelString = "info";
        break;
      case KochavaTrackerLogLevel.Debug:
        logLevelString = "debug";
        break;
      case KochavaTrackerLogLevel.Trace:
        logLevelString = "trace";
        break;
    }
    _invokeChannel("setLogLevel", logLevelString);
  }

  /// Set the sleep state.
  void setSleep(bool sleep) {
    _invokeChannel(
      "setSleep",
      sleep,
    );
  }

  /// Set if app level advertising tracking should be limited.
  void setAppLimitAdTracking(bool appLimitAdTracking) {
    _invokeChannel(
      "setAppLimitAdTracking",
      appLimitAdTracking,
    );
  }

  /// Register a custom device identifier for install attribution.
  void registerCustomDeviceIdentifier(String name, String value) {
    _invokeChannel(
      "registerCustomDeviceIdentifier",
      {
        "name": name,
        "value": value,
      },
    );
  }

  /// Register an Identity Link that allows linking different identities together in the form of key and value pairs.
  void registerIdentityLink(String name, String value) {
    _invokeChannel(
      "registerIdentityLink",
      {
        "name": name,
        "value": value,
      },
    );
  }

  /// (Android Only) Enable the Instant App feature by setting the instant app guid.
  void enableAndroidInstantApps(String instantAppGuid) {
    _invokeChannel(
      "enableAndroidInstantApps",
      instantAppGuid,
    );
  }

  /// (iOS Only) Enable App Clips by setting the Container App Group Identifier for App Clips data migration.
  void enableIosAppClips(String containerAppGroupIdentifier) {
    _invokeChannel(
      "enableIosAppClips",
      containerAppGroupIdentifier,
    );
  }

  /// (iOS Only) Enable App Tracking Transparency.
  void enableIosAtt() {
    _invokeChannel(
      "enableIosAtt",
    );
  }

  /// (iOS Only) Set the amount of time in seconds to wait for App Tracking Transparency Authorization. Default 30 seconds.
  void setIosAttAuthorizationWaitTime(num waitTime) {
    _invokeChannel(
      "setIosAttAuthorizationWaitTime",
      waitTime,
    );
  }

  /// (iOS Only) Set if the SDK should automatically request App Tracking Transparency Authorization on start. Default true.
  void setIosAttAuthorizationAutoRequest(bool autoRequest) {
    _invokeChannel(
      "setIosAttAuthorizationAutoRequest",
      autoRequest,
    );
  }

  /// Register a privacy profile, creating or overwriting an existing pofile.
  void registerPrivacyProfile(String name, List<String> keys) {
    _invokeChannel(
      "registerPrivacyProfile",
      {
        "name": name,
        "keys": keys,
      },
    );
  }

  /// Enable or disable an existing privacy profile.
  void setPrivacyProfileEnabled(String name, bool enabled) {
    _invokeChannel(
      "setPrivacyProfileEnabled",
      {
        "name": name,
        "enabled": enabled,
      },
    );
  }

  /// Return if the SDK is currently started.
  Future<bool> getStarted() async {
    try {
      return await _channel.invokeMethod(
        'getStarted',
      );
    } catch (e) {
      _log("Error: getStarted: $e");
      return Future.value(false);
    }
  }

  /// Register the Android App GUID. Do this prior to calling Start.
  void registerAndroidAppGuid(String androidAppGuid) {
    _registeredAndroidAppGuid = androidAppGuid;
  }

  /// Register the iOS App GUID. Do this prior to calling Start.
  void registerIosAppGuid(String iosAppGuid) {
    _registeredIosAppGuid = iosAppGuid;
  }

  /// Register your Partner Name. Do this prior to calling Start.
  ///
  /// NOTE: Only use this method if directed to by your Client Success Manager.
  void registerPartnerName(String partnerName) {
    _registeredPartnerName = partnerName;
  }

  /// Start the SDK with the previously registered App GUID or Partner Name.
  void start() {
    // Version data is updated by script. Do not change.
    final Map<String, String> wrapper = {
      "name": "Flutter",
      "version": "2.0.0",
      "build_date": "2022-06-22T18:36:30Z",
    };
    executeAdvancedInstruction("wrapper", json.encode(wrapper));
    _invokeChannel("start", {
      "androidAppGuid": _registeredAndroidAppGuid,
      "iosAppGuid": _registeredIosAppGuid,
      "partnerName": _registeredPartnerName
    });
  }

  /// Shut down the SDK and optionally delete all local SDK data.
  ///
  /// NOTE: Care should be taken when using this method as deleting the SDK data will make it reset back to a first install state.
  void shutdown(bool deleteData) {
    // Registered values
    _registeredAndroidAppGuid = null;
    _registeredIosAppGuid = null;
    _registeredPartnerName = null;
    // Native
    _invokeChannel("shutdown", deleteData);
  }

  /// Return the Kochava Device ID.
  Future<String> getDeviceId() async {
    try {
      return await _channel.invokeMethod(
        'getDeviceId',
      );
    } catch (e) {
      _log("Error: getDeviceId: $e");
      return Future.value("");
    }
  }

  /// Return the currently retrieved install attribution data.
  Future<KochavaTrackerInstallAttribution> getInstallAttribution() async {
    try {
      return Future.value(
        KochavaTrackerInstallAttribution(
          json.decode(
            await _channel.invokeMethod(
              'getInstallAttribution',
            ),
          ),
        ),
      );
    } catch (e) {
      _log("Error: getInstallAttribution: $e");
      return Future.value(KochavaTrackerInstallAttribution.withDefaults());
    }
  }

  /// Retrieve install attribution data from the server.
  Future<KochavaTrackerInstallAttribution> retrieveInstallAttribution() async {
    try {
      return Future.value(
        KochavaTrackerInstallAttribution(
          json.decode(
            await _channel.invokeMethod(
              'retrieveInstallAttribution',
            ),
          ),
        ),
      );
    } catch (e) {
      _log("Error: retrieveInstallAttribution: $e");
      return Future.value(KochavaTrackerInstallAttribution.withDefaults());
    }
  }

  /// Process a launch deeplink using the default 10 second timeout.
  Future<KochavaTrackerDeeplink> processDeeplink(String path) async {
    try {
      return Future.value(
        KochavaTrackerDeeplink(
          json.decode(
            await _channel.invokeMethod(
              'processDeeplink',
              path,
            ),
          ),
        ),
      );
    } catch (e) {
      _log("Error: processDeeplink: $e");
      return Future.value(KochavaTrackerDeeplink.withDefaults());
    }
  }

  /// Process a launch deeplink using a custom timeout in seconds.
  Future<KochavaTrackerDeeplink> processDeeplinkWithOverrideTimeout(
      String path, num timeout) async {
    try {
      return Future.value(
        KochavaTrackerDeeplink(
          json.decode(
            await _channel.invokeMethod(
              'processDeeplinkWithOverrideTimeout',
              {
                "path": path,
                "timeout": timeout,
              },
            ),
          ),
        ),
      );
    } catch (e) {
      _log("Error: processDeeplinkWithOverrideTimeout: $e");
      return Future.value(KochavaTrackerDeeplink.withDefaults());
    }
  }

  /// Register the push token.
  void registerPushToken(String token) {
    _invokeChannel(
      "registerPushToken",
      token,
    );
  }

  /// Enable or disable the use of the push token.
  void setPushEnabled(bool enabled) {
    _invokeChannel(
      "setPushEnabled",
      enabled,
    );
  }

  /// Send an event.
  void sendEvent(String name) {
    _invokeChannel(
      "sendEvent",
      name,
    );
  }

  /// Send an event with string data.
  void sendEventWithString(String name, String data) {
    _invokeChannel(
      "sendEventWithString",
      {
        "name": name,
        "data": data,
      },
    );
  }

  /// Send an event with dictionary data.
  void sendEventWithDictionary(String name, Map<String, dynamic> data) {
    _invokeChannel(
      "sendEventWithDictionary",
      {
        "name": name,
        "data": data,
      },
    );
  }

  /// (Internal) Send an event object (Called via Event.send()).
  void sendEventWithEvent(KochavaTrackerEvent event) {
    _invokeChannel(
      "sendEventWithEvent",
      event.getData(),
    );
  }

  /// Build and return an event using a Standard Event Type.
  KochavaTrackerEvent buildEventWithEventType(
    KochavaTrackerEventType eventType,
  ) {
    return KochavaTrackerEvent.withType(eventType);
  }

  /// Build and return an event using a custom name.
  KochavaTrackerEvent buildEventWithEventName(String eventName) {
    return KochavaTrackerEvent.withName(eventName);
  }

  /// (Internal) Call the native layer method with the given arguments.
  void _invokeChannel(String method, [dynamic args]) {
    try {
      _channel.invokeMethod(method, args);
    } catch (e) {
      _log("Error: " + method + ": $e");
    }
  }

  /// (Internal) Logger
  void _log(String message) {
    print("KVA/Tracker: " + message);
  }
}
