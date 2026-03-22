import 'package:flutter/material.dart';
import 'calculadora.dart';
import 'calculator_keys.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const TelaPrincipal(title: 'Calculadora'),
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
  late CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController();
    _controller.display.setText('0');
  }

  void _onButtonPressed(String value) {
    final key = calculatorKeys[value];
    if (key != null) {
      _controller.press(key);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(
                _controller.display.text,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                '7', '8', '9', '/',
                '4', '5', '6', '*',
                '1', '2', '3', '-',
                'C', '0', '=', '+'
              ].map((e) => Padding(
                padding: EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(60, 60),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => _onButtonPressed(e),
                  child: Text(e, style: TextStyle(fontSize: 30)),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
