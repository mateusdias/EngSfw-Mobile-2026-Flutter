import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_camera/main.dart';

void main() {
  testWidgets('renders configured home widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MyApp(home: Center(child: Text('Camera App Test'))),
    );

    expect(find.text('Camera App Test'), findsOneWidget);
  });
}
