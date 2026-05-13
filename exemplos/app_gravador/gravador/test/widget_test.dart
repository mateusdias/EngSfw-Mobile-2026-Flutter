// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:gravador/main.dart';

void main() {
  testWidgets('Mostra a tela inicial do gravador', (WidgetTester tester) async {
    await tester.pumpWidget(const GravadorApp());

    expect(find.text('Gravador de Audio'), findsWidgets);
    expect(find.text('Toque para iniciar'), findsOneWidget);
    expect(find.text('Gravar audio'), findsOneWidget);
    expect(find.text('Reproduzir'), findsOneWidget);
  });
}
