import 'package:flutter/material.dart';

void main() {
  runApp(const IMCApp());
}

class IMCApp extends StatelessWidget {
  const IMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TelaPrincipal(title: 'Calculadora de IMC'),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key, required this.title});

  final String title;

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // O TextEditingController controla o texto digitado em um TextField.
  // Com ele, conseguimos ler o valor atual do campo usando ".text",
  // alterar esse valor por codigo e, se necessario, observar mudancas.
  // Aqui ele sera usado para acessar a altura informada pelo usuario.
  final TextEditingController _alturaController = TextEditingController();

  // Este segundo controller faz o mesmo papel para o campo de peso.
  // Ou seja: ele guarda e gerencia o texto digitado nesse TextField.
  final TextEditingController _pesoController = TextEditingController();

  @override
  void dispose() {
    // O metodo dispose e chamado quando este State vai ser destruido
    // pelo Flutter, por exemplo quando a tela deixa de existir.
    // Esse e o lugar correto para liberar recursos que foram criados
    // durante a vida da tela e que nao devem ficar ocupando memoria.
    //
    // Como os TextEditingControllers ficam ligados aos campos de texto,
    // precisamos descartá-los manualmente para evitar desperdicio de
    // memoria e comportamentos inesperados.
    _alturaController.dispose();
    _pesoController.dispose();

    // Chama o dispose da classe pai para que o Flutter finalize
    // corretamente a limpeza interna desse objeto State.
    super.dispose();
  }

  void _calcularImc() {
    final String alturaTexto =
        _alturaController.text.trim().replaceAll(',', '.');
    final String pesoTexto = _pesoController.text.trim().replaceAll(',', '.');

    if (alturaTexto.isEmpty || pesoTexto.isEmpty) {
      _mostrarResultado('Preencha os campos de altura e peso.');
      return;
    }

    final double? altura = double.tryParse(alturaTexto);
    final double? peso = double.tryParse(pesoTexto);

    if (altura == null || peso == null) {
      _mostrarResultado('Informe valores numericos validos nos dois campos.');
      return;
    }

    if (altura <= 0 || peso <= 0) {
      _mostrarResultado('Altura e peso devem ser maiores que zero.');
      return;
    }

    if (peso > 600) {
      _mostrarResultado('O peso maximo permitido e 600 kg.');
      return;
    }

    if (altura > 3.0) {
      _mostrarResultado('A altura maxima permitida e 3.00 m.');
      return;
    }

    final double imc = peso / (altura * altura);

    _mostrarResultado(
      'Seu IMC é ${imc.toStringAsFixed(2)}.\n'
      'Altura: ${altura.toStringAsFixed(2)} m\n'
      'Peso: ${peso.toStringAsFixed(2)} kg',
    );
  }

  void _mostrarResultado(String mensagem) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado do IMC'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold e a estrutura visual basica de uma tela no Material Design.
    // Digamos que seja uma estrutura pronta de uma interface, composta por appBar, body,
    // floatingActionButton, drawer e outras partes comuns de uma pagina.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Padding adiciona um espaco ao redor do widget filho.
            // Aqui ele cria uma margem interna ao redor do TextField,
            // evitando que o campo fique colado nas bordas da tela.
            Padding(
              // EdgeInsets e a classe usada para definir espacos.
              // O metodo symmetric cria espacos iguais em lados opostos:
              // horizontal: 24 -> 24 px na esquerda e 24 px na direita
              // vertical: 8 -> 8 px em cima e 8 px embaixo
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                controller: _alturaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Altura (m)',
                  hintText: 'Ex.: 1.75',
                ),
              ),
            ),
            // Repetimos o Padding no segundo campo para manter o mesmo
            // espacamento visual e deixar a interface mais organizada.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                controller: _pesoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Peso (kg)',
                  hintText: 'Ex.: 70.5',
                ),
              ),
            ),
            // SizedBox e um widget simples usado para reservar espaco.
            // Neste caso, ele cria uma separacao vertical fixa de 12 px
            // entre o ultimo campo de texto e o botao Calcular.
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _calcularImc,
              child: const Text('Calcular'),
            ),
          ],
        ),
      ),
      
    );
  }
}
