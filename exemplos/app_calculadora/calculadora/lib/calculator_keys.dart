import 'calculadora.dart';

/// Definições das teclas da calculadora, mapeadas para os botões do layout.
const Map<String, Key> calculatorKeys = {
  '0': Key(label: '0', type: KeyType.digit),
  '1': Key(label: '1', type: KeyType.digit),
  '2': Key(label: '2', type: KeyType.digit),
  '3': Key(label: '3', type: KeyType.digit),
  '4': Key(label: '4', type: KeyType.digit),
  '5': Key(label: '5', type: KeyType.digit),
  '6': Key(label: '6', type: KeyType.digit),
  '7': Key(label: '7', type: KeyType.digit),
  '8': Key(label: '8', type: KeyType.digit),
  '9': Key(label: '9', type: KeyType.digit),
  '+': Key(label: '+', type: KeyType.operator),
  '-': Key(label: '-', type: KeyType.operator),
  '*': Key(label: '*', type: KeyType.operator),
  '/': Key(label: '/', type: KeyType.operator),
  '=': Key(label: '=', type: KeyType.action, action: CalcAction.enter),
  'C': Key(label: 'C', type: KeyType.action, action: CalcAction.clear),
};