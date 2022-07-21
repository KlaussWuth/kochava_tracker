///
///  KochavaTracker (Flutter)
///
///  Copyright (c) 2020 - 2022 Kochava, Inc. All rights reserved.
///

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kochava_tracker/kochava_tracker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// See the full documentation on usage https://support.kochava.com/sdk-integration/flutter-sdk-integration/
class _MyAppState extends State<MyApp> {
  String _deviceId = 'N/A';

  @override
  void initState() {
    super.initState();
    startSdk();
  }

  // Start the Kochava SDK and retrieve the Kochava Device ID.
  Future<void> startSdk() async {
    // Start the Kochava SDK.
    KochavaTracker.instance.registerAndroidAppGuid("YOUR_ANDROID_APP_GUID");
    KochavaTracker.instance.registerIosAppGuid("YOUR_IOS_APP_GUID");
    KochavaTracker.instance.setLogLevel(KochavaTrackerLogLevel.Trace);
    KochavaTracker.instance.start();

    // Retrieve the Kochava Device ID.
    String deviceId = await KochavaTracker.instance.getDeviceId();

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kochava Plugin Sample'),
        ),
        body: Center(
            child: ListView(
          children: [
            Text('DeviceId: $_deviceId\n'),
          ],
        )),
      ),
    );
  }
}
