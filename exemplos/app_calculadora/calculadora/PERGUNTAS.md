# Perguntas sobre o Código da Calculadora Flutter

Este arquivo contém 20 perguntas para estudo detalhado do código da calculadora implementada em Flutter. As perguntas visam explorar conceitos importantes do framework, arquitetura de software e boas práticas de desenvolvimento.

## 1. Estrutura Básica do App
1. Qual é a função da classe `CalculadoraApp` e como ela configura o tema do Material Design?
2. Por que a classe `TelaPrincipal` é um `StatefulWidget` em vez de um `StatelessWidget`?

## 2. Gerenciamento de Estado
3. Como o estado da calculadora é gerenciado na classe `_TelaPrincipalState`? Quais variáveis são usadas?
4. Qual é o papel do método `initState()` na inicialização do controlador da calculadora?
5. Como o método `setState()` é usado para atualizar a interface após pressionar um botão?

## 3. Layout e Widgets
6. Descreva a estrutura do layout principal usando `Column`, `Expanded` e `GridView`. Por que essa organização?
7. Como o `Container` é usado para posicionar e estilizar o display da calculadora?
8. Qual é a diferença entre `Expanded` com `flex: 1` e `flex: 2` no layout?
9. Como o `GridView.count` é configurado para organizar os botões em uma grade 4x4?

## 4. Botões e Interação
10. Como os botões são criados usando `ElevatedButton` e qual é o propósito do `Padding` ao redor deles?
11. Explique como o método `_onButtonPressed` mapeia strings de botões para objetos `Key` e interage com o controlador.
12. Qual é a função do `style` no `ElevatedButton` para controlar o tamanho mínimo dos botões?

## 5. Arquitetura da Calculadora (calculadora.dart)
13. Quais são os três tipos de tecla definidos no enum `KeyType` e como eles são usados?
14. Como a classe `Display` separa a responsabilidade de gerenciar o texto exibido?
15. Explique o papel do `CalculatorEngine` na avaliação de expressões matemáticas.
16. Como o `CalculatorController` orquestra as interações entre `Display` e `CalculatorEngine`?
17. Qual é a diferença entre as ações `CalcAction.clear`, `CalcAction.backspace` e `CalcAction.enter`?

## 6. Mapeamento de Teclas (calculator_keys.dart)
18. Como o mapa `calculatorKeys` associa strings de botões a objetos `Key`? Dê exemplos.
19. Por que alguns operadores usam `value` diferente do `label` no objeto `Key`?

## 7. Tratamento de Erros e Validação
20. Como o código trata erros como divisão por zero ou expressões inválidas? Onde isso é implementado?

# Guia para Testes Unitários

Esta seção ensina como criar testes unitários básicos para as operações da calculadora usando o framework de testes do Dart. Os testes unitários ajudam a verificar se as funções funcionam corretamente de forma isolada, facilitando a detecção de bugs e a manutenção do código.

## Configuração dos Testes

1. **Dependências**: Certifique-se de que o `pubspec.yaml` inclui o package `test` nas dev_dependencies:
   ```yaml
   dev_dependencies:
     test: ^1.24.0
   ```

2. **Executar testes**: No terminal, rode `flutter test` ou `dart test` para executar todos os testes.

3. **Estrutura de teste**: Crie um arquivo `test/calculadora_test.dart` para testar as classes do `calculadora.dart`.

## Testando o CalculatorEngine

O `CalculatorEngine` é responsável por avaliar expressões matemáticas. Vamos criar testes para cada operação básica.

### Exemplo de Arquivo de Teste

```dart
import 'package:test/test.dart';
import 'package:calculadora/calculadora.dart';

void main() {
  group('CalculatorEngine', () {
    final engine = CalculatorEngine();

    test('Soma: 2 + 3 = 5', () {
      expect(engine.evaluate('2+3'), equals(5.0));
    });

    test('Subtração: 10 - 4 = 6', () {
      expect(engine.evaluate('10-4'), equals(6.0));
    });

    test('Multiplicação: 3 * 5 = 15', () {
      expect(engine.evaluate('3*5'), equals(15.0));
    });

    test('Multiplicação com x: 3 x 5 = 15', () {
      expect(engine.evaluate('3x5'), equals(15.0));
    });

    test('Divisão: 10 / 2 = 5', () {
      expect(engine.evaluate('10/2'), equals(5.0));
    });

    test('Divisão por zero lança erro', () {
      expect(() => engine.evaluate('10/0'), throwsA(isA<UnsupportedError>()));
    });

    test('Expressão inválida lança erro', () {
      expect(() => engine.evaluate('abc'), throwsA(isA<FormatException>()));
    });

    test('Resultado inteiro sem .0', () {
      expect(engine.evaluate('4/2'), equals(2.0)); // Mesmo sendo int, retorna double
    });
  });
}
```

### Como Obter os Resultados

- **Executar um teste específico**: `flutter test test/calculadora_test.dart`
- **Ver saída**: Os testes mostram se passaram (verde) ou falharam (vermelho), com detalhes do erro.
- **Cobertura**: Use `flutter test --coverage` para ver quais linhas do código foram testadas.

## Testando o CalculatorController

Para testar o controlador, simule pressionar teclas e verifique o display.

### Exemplo de Teste para Controller

```dart
import 'package:test/test.dart';
import 'package:calculadora/calculadora.dart';

void main() {
  group('CalculatorController', () {
    late CalculatorController controller;

    setUp(() {
      controller = CalculatorController();
    });

    test('Pressionar dígitos e calcular soma', () {
      controller.press(const Key(label: '2', type: KeyType.digit));
      controller.press(const Key(label: '+', type: KeyType.operator));
      controller.press(const Key(label: '3', type: KeyType.digit));
      controller.press(const Key(label: '=', type: KeyType.action, action: CalcAction.enter));
      
      expect(controller.display.text, equals('5'));
    });

    test('Limpar display', () {
      controller.press(const Key(label: '1', type: KeyType.digit));
      controller.press(const Key(label: '2', type: KeyType.digit));
      expect(controller.display.text, equals('12'));
      
      controller.press(const Key(label: 'C', type: KeyType.action, action: CalcAction.clear));
      expect(controller.display.text, equals(''));
    });

    test('Erro de divisão por zero', () {
      controller.press(const Key(label: '5', type: KeyType.digit));
      controller.press(const Key(label: '/', type: KeyType.operator));
      controller.press(const Key(label: '0', type: KeyType.digit));
      controller.press(const Key(label: '=', type: KeyType.action, action: CalcAction.enter));
      
      expect(controller.display.text, equals('Erro'));
    });
  });
}
```

## Dicas para Criar Testes

- **Isolar unidades**: Teste uma classe ou método por vez.
- **Usar `setUp`**: Para inicializar objetos comuns a múltiplos testes.
- **Matchers**: Use `equals`, `throwsA`, `isA` para verificar resultados.
- **Nomes descritivos**: Os nomes dos testes devem explicar o que estão testando.
- **Cobrir casos extremos**: Teste valores limites, erros e casos normais.

Pratique criando testes para outras operações e funcionalidades para consolidar o aprendizado!