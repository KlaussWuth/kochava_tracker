///
///  KochavaTracker (Flutter)
///
///  Copyright (c) 2020 - 2022 Kochava, Inc. All rights reserved.
///

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kochava_tracker_example/main.dart';

void main() {
  testWidgets('Verify Device ID', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the device id is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data?.startsWith('DeviceId: ') == true,
      ),
      findsOneWidget,
    );
  });
}
