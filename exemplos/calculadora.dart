// Aula: 
// Objetivo: Desenhar uma arquitetura simples de uma calculadora (Dart puro).
// Aprender conceitos como nomeação de atributos com _ (padrão dart para atributos privados).
// Conhecer e aplicar (ainda sem saber como construir) expressões regulares. 
// Entender construtores mais complexos. 
// Uso de const e final. 

// Conceitos exemplificados:
// 1) final -> referências imutáveis (boas práticas de design)
// 2) enum -> tipagem literal (evita strings e melhora desempenho de comparação)
//
// Regras desta versão:
// - Uma expressão por vez: "a op b"
// - Ex.: 2x2 + Enter -> calcula imediatamente
// - Operadores: +, -, *, /, x
// - Ações: C (clear), ⌫ (backspace), Enter (calcular)

enum KeyType { digit, operator, action }

enum CalcAction { clear, backspace, enter }

class Key {
  final String label;
  final KeyType type;
  final String? value;
  final CalcAction? action;

  /// Construtor const:
  /// - permite criar objetos imutáveis (quando todos os campos também forem imutáveis)
  /// - ajuda a reforçar a ideia de "tecla como valor"
  const Key({
    required this.label,
    required this.type,
    this.value,
    this.action,
  });
}

class Display {

  // "ATRIBUTO PRIVADO" (tem efeito real mas, não como o private do Java). 
  String _text;

  /// Construtor define o estado inicial do display.
  Display({String initialText = ""}) : _text = initialText;

  String get text => _text;
  void setText(String value) => _text = value;

  void clear() => _text = "";

  void append(String value) => _text += value;

  void backspace() {
    if (_text.isEmpty) return;
    _text = _text.substring(0, _text.length - 1);
  }
}

class CalculatorEngine {
  double evaluate(String expression) {
    final exp = _normalize(expression);

    // Regex para: numero operador numero
    // - aceita sinal opcional (+/-)
    // - aceita decimal com ponto
    final regex = RegExp(
      r'^\s*([+-]?\d+(?:\.\d+)?)\s*([+\-*/x])\s*([+-]?\d+(?:\.\d+)?)\s*$',
    );

    final match = regex.firstMatch(exp);
    if (match == null) {
      throw FormatException("Expressão inválida: '$expression'");
    }

    final a = double.parse(match.group(1)!);
    final op = match.group(2)!;
    final b = double.parse(match.group(3)!);

    return _apply(a, op, b);
  }

  String _normalize(String s) {
    // Normaliza '×' e 'X' para 'x'
    return s.replaceAll('×', 'x').replaceAll('X', 'x').trim();
  }

  double _apply(double a, String op, double b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
      case 'x':
        return a * b;
      case '/':
        if (b == 0) throw UnsupportedError("Divisão por zero");
        return a / b;
      default:
        throw UnsupportedError("Operador não suportado ou inexistente: $op");
    }
  }
}

class CalculatorController {
  /// `final` é perfeito aqui:
  /// - display e engine são dependências fixas do controller
  /// - a referência não muda (o conteúdo do display pode mudar)
  final Display display;
  final CalculatorEngine engine;

  /// Construtor com injeção de dependência (didático):
  /// Se não passar nada, cria padrões.
  CalculatorController({Display? display, CalculatorEngine? engine})
      : display = display ?? Display(),
        engine = engine ?? CalculatorEngine();

  void press(Key key) {
    switch (key.type) {
      case KeyType.digit:
      case KeyType.operator:
        // Para dígito ou operador: apenas anexa ao display.
        // Se tiver `value`, usa ele; senão usa o `label`.
        display.append(key.value ?? key.label);
        break;

      case KeyType.action:
        _handleAction(key.action);
        break;
    }
  }

  void _handleAction(CalcAction? action) {
    if (action == null) return;

    switch (action) {
      case CalcAction.clear:
        display.clear();
        break;
      case CalcAction.backspace:
        display.backspace();
        break;
      case CalcAction.enter:
        _compute();
        break;
    }
  }

  void _compute() {
    final input = display.text.trim();
    if (input.isEmpty) return;

    try {
      final result = engine.evaluate(input);

      // Se for inteiro, mostra sem ".0"
      final intCandidate = result.toInt();
      final formatted = (result == intCandidate) ? "$intCandidate" : "$result";

      display.setText(formatted);
    } catch (_) {
      display.setText("Erro");
    }
  }
}

void main() {

  final calc = CalculatorController();
  
  // Simulação: 2 x 2 Enter
  final keys1 = <Key>[
    const Key(label: "2", type: KeyType.digit),
    const Key(label: "x", type: KeyType.operator, value: "x"),
    const Key(label: "2", type: KeyType.digit),
    const Key(label: "Enter", type: KeyType.action, action: CalcAction.enter),
  ];

  for (final k in keys1) {
    calc.press(k);
    print("Apertou '${k.label}' -> display: ${calc.display.text}");
  }
  
  print("\n--- Outro exemplo: 10/5 ---");
  const cKey = Key(label: "C", type: KeyType.action, action: CalcAction.clear);
  calc.press(cKey);
  calc.press(const Key(label: "1", type: KeyType.digit));
  calc.press(const Key(label: "0", type: KeyType.digit));
  calc.press(const Key(label: "/", type: KeyType.operator, value: "/"));
  calc.press(const Key(label: "5", type: KeyType.digit));
  calc.press(const Key(label: "Enter", type: KeyType.action, action: CalcAction.enter));
  print("Resultado: ${calc.display.text}");
  
  print("\n--- Erro: 2/0 ---");
  calc.press(const Key(label: "C", type: KeyType.action, action: CalcAction.clear));
  calc.press(const Key(label: "2", type: KeyType.digit));
  calc.press(const Key(label: "/", type: KeyType.operator, value: "/"));
  calc.press(const Key(label: "0", type: KeyType.digit));
  calc.press(const Key(label: "Enter", type: KeyType.action, action: CalcAction.enter));
  print("Resultado: ${calc.display.text}");

  print("\n--- Erro: 2/Enter ---");
  calc.press(const Key(label: "2", type: KeyType.digit));
  calc.press(const Key(label: "/", type: KeyType.operator, value: "/"));
  calc.press(const Key(label: "Enter", type: KeyType.action, action: CalcAction.enter));
  print("Resultado Erro faltando partes: ${calc.display.text}");
  

}


/*
  1 - Baixar a calculadora e 
  ler e analisar o código completo. 
  (com apoio da IA)
  2 - Tentar entender a expressão
  regular que está lá. 
  3 - Usando o prompt vc vai enviar o código
  da calculadora em Dart e pedir
  que a IA gere um app em flutter 
  a partir dele. 
  (sair um projeto... )
  Me explique passo a passo o que foi feito

*/