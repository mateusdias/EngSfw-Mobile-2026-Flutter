import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:imc/main.dart';

void main() {
  testWidgets('exibe os campos principais da calculadora', (
    WidgetTester tester,
  ) async {
    // Monta o aplicativo na memoria de teste.
    await tester.pumpWidget(const IMCApp());

    // Procura pelos textos que identificam os campos e o botao.
    expect(find.text('Altura (m)'), findsOneWidget);
    expect(find.text('Peso (kg)'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
  });

  testWidgets('mostra mensagem quando os campos nao foram preenchidos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IMCApp());

    // Clica no botao sem preencher nada.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calcular'));
    await tester.pumpAndSettle();

    // Verifica se o AlertDialog apareceu com a mensagem esperada.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Preencha os campos de altura e peso.'), findsOneWidget);
  });

  testWidgets('calcula o IMC corretamente com valores validos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IMCApp());

    // Encontra os dois TextFields da tela.
    final Finder campos = find.byType(TextField);

    // Preenche altura e peso como um usuario faria.
    await tester.enterText(campos.at(0), '1.80');
    await tester.enterText(campos.at(1), '81');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Calcular'));
    await tester.pumpAndSettle();

    // 81 / (1.80 * 1.80) = 25.00
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Seu IMC e 25.00.'), findsOneWidget);
  });

  testWidgets('valida o limite maximo de peso', (WidgetTester tester) async {
    await tester.pumpWidget(const IMCApp());

    final Finder campos = find.byType(TextField);

    await tester.enterText(campos.at(0), '1.75');
    await tester.enterText(campos.at(1), '601');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('O peso maximo permitido e 600 kg.'), findsOneWidget);
  });
}
