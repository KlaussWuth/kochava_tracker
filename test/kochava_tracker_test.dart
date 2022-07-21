///
///  KochavaTracker (Flutter)
///
///  Copyright (c) 2020 - 2022 Kochava, Inc. All rights reserved.
///

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kochava_tracker/kochava_tracker.dart';

void main() {
  const MethodChannel channel = MethodChannel('kochava_tracker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getDeviceId', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      expect(methodCall.method, "getDeviceId");
      return 'KA1234';
    });

    expect(await KochavaTracker.instance.getDeviceId(), 'KA1234');
  });
}
