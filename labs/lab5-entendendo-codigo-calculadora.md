# Lab 05 — Entendendo o código da calculadora em Dart

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2h/a

## 🎯 Objetivos do Lab

Ao final deste laboratório, o estudante deverá ser capaz de:

* Ler e explicar a arquitetura do arquivo `exemplos/calculadora.dart`;
* Identificar responsabilidades de cada classe (`Key`, `Display`, `CalculatorEngine`, `CalculatorController`);
* Entender encapsulamento com `_` e uso de `final` e `const`;
* Compreender o fluxo de entrada de teclas até o resultado;
* Realizar pequenas evoluções no código sem quebrar o funcionamento.

## ✅ Pré-requisitos

* Ter lido a aula: `aulas/aula5-estudo-calculadora-dart.md`;
* Ambiente Dart/Flutter funcional (VS Code ou Android Studio);
* Acesso ao arquivo `exemplos/calculadora.dart`.

> 📌 Dica: faça este lab com o arquivo da calculadora aberto ao lado, lendo e executando cada trecho.

## Parte A — Leitura guiada do código (30 a 40 min)

### A1) Enum e modelagem das teclas

Encontre e explique:

```dart
enum KeyType { digit, operator, action }
enum CalcAction { clear, backspace, enter }
```

Tarefa:

* Escreva em 2 ou 3 linhas: por que `enum` é melhor do que strings soltas neste caso?

### A2) Classe `Key` e imutabilidade

Observe:

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

Tarefas:

* Explique a diferença de papel entre `label` e `value`;
* Explique por que os atributos foram declarados como `final`;
* Explique por que o construtor foi declarado como `const`.

### A3) Encapsulamento no `Display`

Observe:

```dart
class Display {
  String _text;
  Display({String initialText = ""}) : _text = initialText;
  String get text => _text;
}
```

Tarefas:

* Explique o significado do `_` em `_text` no Dart;
* Liste os métodos que alteram `_text` no código completo;
* Responda: por que isso ajuda a controlar o estado da aplicação?

## Parte B — Entendendo o fluxo completo (30 a 40 min)

### B1) Fluxo da tecla pressionada

Leia os métodos `press`, `_handleAction` e `_compute` no `CalculatorController`.

Tarefa:

* Monte um fluxo textual para o cenário `2 x 2 Enter` com no mínimo 6 passos.

Exemplo de início:

1. Usuário pressiona `2` (`KeyType.digit`);
2. Controller chama `display.append(...)`;
3. ...

### B2) Tratamento de erro

Localize o `try/catch` em `_compute`.

Tarefa:

* Explique o que acontece no display quando:
  * a expressão é inválida (ex.: `2++2`);
  * ocorre divisão por zero (ex.: `2/0`).

### B3) Regex de validação

Encontre a regex usada no `CalculatorEngine` e responda:

* Quais formatos ela aceita?
* Por que `"2+2+2"` não funciona nesta versão?

## Parte C — Mãos no código (40 a 50 min)

Faça as alterações abaixo no `exemplos/calculadora.dart`.

### C1) Novo operador `%` (módulo)

Objetivo: permitir expressões como `10%3`.

Passos sugeridos:

1. Incluir `%` na regex;
2. Incluir `%` no `_apply`;
3. Testar no `main` com uma simulação.

### C2) Melhorar mensagem de erro

Hoje o código mostra `"Erro"` no display.

Tarefa:

* Alterar para mostrar:
  * `"Erro: expr"` para expressão inválida;
  * `"Erro: /0"` para divisão por zero.

> Dica: capture exceções específicas (`on FormatException`, `on UnsupportedError`) antes do `catch` genérico.

### C3) Tecla de ponto decimal dedicada

Adicionar uma tecla `.` na simulação para facilitar cenários como `3.5*2`.

Tarefa:

* Criar sequência de teclas no `main` que resulte em `7`.

## ✅ Final do Lab 05

Ao final, você deve saber entregar:

1. Explicações da Parte A e Parte B;
2. Código atualizado com as tarefas C1, C2 e C3;
3. Evidência de execução no terminal com pelo menos 3 casos:
   * `2x2`
   * `10/5`
   * `10%3`

## 🧯 Troubleshooting rápido

### Regex não reconhece o novo operador

* Verifique se `%` foi incluído na classe de caracteres da regex.

### Resultado inteiro aparecendo com `.0`

* Revise a lógica que formata `result` antes de `display.setText(...)`.

### Display não atualiza

* Verifique se o fluxo está passando por `press(...)` e se `display.append(...)` está sendo chamado. Desafio: use o Debug para isso :-) 

## 🔜 Desafio divertido complementar e não obrigatório

* Transformar os cenários do `main` (aquelas expressões) em testes automatizados (introdução a testes unitários em Dart). Procure como fazer.

---

**Lab 05 — TPDM / Mobile 2026**
