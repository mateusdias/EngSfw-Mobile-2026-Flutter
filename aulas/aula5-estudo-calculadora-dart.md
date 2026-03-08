# Aula 05 — Estudo de caso: Calculadora em Dart (Dart puro)

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração:** 2h/a

## 1. Objetivos da aula

Ao final desta aula, espera-se que o estudante:

* Entenda uma arquitetura simples orientada a objetos em Dart;
* Interprete código com **encapsulamento** usando `_`;
* Diferencie uso de **`final`** e **`const`**;
* Compreenda o papel de **`enum`** para tipagem segura;
* Entenda o fluxo de processamento entre classes (`Display`, `Engine`, `Controller`);
* Veja aplicação prática de **RegExp**, `try/catch` e `FormatException`.

## 2. Contexto do exemplo

Nesta aula, vamos estudar o arquivo:

* `exemplos/calculadora.dart`

A proposta do código é simular uma calculadora de console com uma expressão por vez:

* Formato: `a op b` (por exemplo: `10/5`, `2x2`, `3.5*2`)
* Operadores: `+`, `-`, `*`, `/`, `x`
* Ações: limpar (`C`), apagar último caractere (`⌫`) e calcular (`Enter`)

## 3. Organização do código por responsabilidade

No exemplo, cada classe tem uma responsabilidade bem definida:

* `Key` representa uma tecla;
* `Display` guarda e manipula o texto da tela;
* `CalculatorEngine` interpreta a expressão e calcula;
* `CalculatorController` recebe teclas e orquestra todo o fluxo.

Esse desenho evita classe “Deus” e melhora manutenção.

## 4. Enum como conjunto fechado de valores

Trecho do código:

```dart
enum KeyType { digit, operator, action }
enum CalcAction { clear, backspace, enter }
```

Conceitos importantes:

* `enum` define um conjunto fechado de valores válidos;
* evita comparar string solta como `"enter"` ou `"clear"`;
* reduz erro de digitação e melhora legibilidade.

## 5. `final` em atributos de classe (imutabilidade de referência)

Trecho do código:

```dart
class Key {
  final String label;
  final KeyType type;
  final String? value;
  final CalcAction? action;

  const Key({
    required this.label,
    required this.type,
    this.value,
    this.action,
  });
}
```

Leitura correta de `final`:

* atributo `final` deve ser inicializado uma única vez;
* após construção do objeto, a referência não pode apontar para outro valor;
* ajuda a garantir consistência do objeto.

No `CalculatorController`:

```dart
final Display display;
final CalculatorEngine engine;
```

Aqui o controller sempre usa as mesmas dependências durante sua vida útil.

## 6. `const` no construtor e instâncias constantes

O construtor da tecla é `const`, então podemos criar teclas constantes:

```dart
const Key(label: "2", type: KeyType.digit)
```

Conceitos:

* `const` cria valores de tempo de compilação quando possível;
* objetos constantes são imutáveis;
* reforça a ideia de “tecla como dado fixo”.

## 7. Atributo privado com `_` (encapsulamento em Dart)

Trecho do `Display`:

```dart
class Display {
  String _text;

  Display({String initialText = ""}) : _text = initialText;

  String get text => _text;
  void setText(String value) => _text = value;
  void clear() => _text = "";
  void append(String value) => _text += value;
}
```

Conceitos importantes:

* em Dart, o prefixo `_` torna o membro **privado ao arquivo (library)**;
* `_text` não deve ser acessado diretamente de fora do arquivo;
* acesso controlado via métodos (`get`, `setText`, `append`, `clear`, `backspace`) caracteriza encapsulamento.

Benefício direto: regras de alteração do estado ficam centralizadas na própria classe.

## 8. Parsing com RegExp e validação de entrada

Trecho do `CalculatorEngine`:

```dart
final regex = RegExp(
  r'^\s*([+-]?\d+(?:\.\d+)?)\s*([+\-*/x])\s*([+-]?\d+(?:\.\d+)?)\s*$',
);
```

Resumo da regra:

* número (com sinal opcional), operador, número (com sinal opcional);
* aceita espaços extras;
* aceita decimal com ponto.

Se não casar com a regex:

```dart
throw FormatException("Expressão inválida: '$expression'");
```

Ou seja, entrada inválida é tratada explicitamente.

## 9. `switch`, fluxo de ações e tratamento de erro

O controlador processa o tipo da tecla:

```dart
switch (key.type) {
  case KeyType.digit:
  case KeyType.operator:
    display.append(key.value ?? key.label);
    break;
  case KeyType.action:
    _handleAction(key.action);
    break;
}
```

Pontos-chave:

* `switch` com `enum` deixa o fluxo claro;
* `??` usa valor alternativo quando `value` é `null`;
* no cálculo final, `try/catch` evita quebra do programa e mostra `"Erro"` no display.

## 10. Injeção de dependência no construtor

Trecho:

```dart
CalculatorController({Display? display, CalculatorEngine? engine})
    : display = display ?? Display(),
      engine = engine ?? CalculatorEngine();
```

Conceito:

* o controller aceita dependências externas (útil para teste);
* se não receber nada, cria implementações padrão;
* padrão simples e muito útil para evolução do projeto.

## 11. Execução simulada no `main`

No `main`, o código monta listas de teclas e chama `press(...)` para cada uma, simulando uso real da calculadora.

Exemplo do fluxo `2 x 2 Enter`:

```dart
final keys1 = <Key>[
  const Key(label: "2", type: KeyType.digit),
  const Key(label: "x", type: KeyType.operator, value: "x"),
  const Key(label: "2", type: KeyType.digit),
  const Key(label: "Enter", type: KeyType.action, action: CalcAction.enter),
];
```

Esse estilo é útil para depuração e para transformar depois em testes automatizados.

## 12. Fechamento da aula

Com este estudo de caso, você praticou conceitos centrais de Dart OO:

* encapsulamento com `_`;
* imutabilidade de referência com `final`;
* objetos constantes com `const`;
* modelagem com `enum`;
* validação com regex;
* tratamento de erro com exceções;
* separação de responsabilidades entre classes.

Esses fundamentos aparecem continuamente em apps Flutter reais, principalmente em camadas de domínio e controle de estado.

---

**Aula 05 — TPDM / Mobile 2026**
