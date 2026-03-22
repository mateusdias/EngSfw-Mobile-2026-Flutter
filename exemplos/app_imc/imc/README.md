# App IMC

Este projeto é um exemplo simples em Flutter de uma calculadora de IMC
(Indice de Massa Corporal). O aplicativo foi pensado como material de apoio
para iniciantes, mostrando como montar uma tela com widgets básicos,
capturar dados digitados pelo usuário, validar entradas, realizar um cálculo
e exibir o resultado em um diálogo.

## O que o aplicativo faz

Na tela principal, o usuário informa:

- a altura em metros
- o peso em quilogramas

Ao tocar no botao `Calcular`, o aplicativo:

1. verifica se os dois campos foram preenchidos
2. valida se os valores digitados são numéricos (tryParse)
3. valida se altura e peso são maiores que zero
4. valida se o peso e menor ou igual a `600`
5. valida se a altura e menor ou igual a `3.00`
6. calcula o IMC com a fórmula `peso / (altura * altura)`
7. mostra o resultado em um componente `AlertDialog`

## Estrutura principal do codigo

O arquivo principal do projeto esta em `lib/main.dart`.

As partes mais importantes são:

- `IMCApp`: widget raiz da aplicacão, responsável por criar o `MaterialApp`
- `TelaPrincipal`: widget com estado que representa a tela principal
- `_TelaPrincipalState`: onde ficam os controllers, as validações, o clculo e a interface

### Widgets e conceitos usados

- `MaterialApp`: configura a app Flutter no estilo Material Design
- `Scaffold`: fornece a estrutura visual basica da tela, como `appBar` e `body`
- `TextField`: recebe os dados de altura e peso
- `TextEditingController`: permite acessar o texto digitado nos `TextField`s
- `ElevatedButton`: dispara a acao de calcular o IMC
- `AlertDialog`: exibe mensagens de erro ou o resultado final do calculo
- `Padding`: adiciona espaço ao redor dos campos
- `SizedBox`: cria um espaço vertical entre componentes

## Validacoes implementadas

O metodo `_calcularImc()` faz as validacoes antes de calcular:

- campos obrigatórios
- conversão de texto para número
- valores maiores que zero
- peso máximo de `600 kg`
- altura máxima de `3.00 m`

Se alguma validacao falhar, o usuário recebe uma mensagem explicando o problema.
Se tudo estiver correto, o valor do IMC é calculado e mostrado em tela.

## Controle de estado

O projeto usa `StatefulWidget` porque a tela precisa manter objetos que vivem enquanto ela esta ativa, como os `TextEditingController`s.

No metodo `dispose()`, esses controllers sao liberados corretamente. Isso é uma boa pratica importante em Flutter, pois evita manter recursos em memória depois que a tela deixa de existir.

## Testes criados

O arquivo `test/widget_test.dart` contém exemplos de testes para quem está aprendendo pela primeira vez. Confira como são realizados os testes unitários. 

Os testes mostram como:

- montar a aplicacao no ambiente de teste com `pumpWidget`
- localizar widgets com `find`
- simular digitacao com `enterText`
- simular clique no botao com `tap`
- aguardar a interface terminar de atualizar com `pumpAndSettle`
- verificar se um texto ou diálogo apareceu com `expect`

### Cenários cobertos

- renderização dos componentes principais da tela
- validação de campos vazios
- calculo correto do IMC com dados validos
- validação do limite máximo de peso

Esses testes sao testes de widget, muito usados em Flutter para validar comportamento da interface e regras simples de telas.

## Como executar

Para executar o aplicativo:

```bash
flutter run
```

Para executar os testes:

```bash
flutter test
```

## Referencias da documentacao

As principais referencias oficiais usadas neste exemplo sao:

- Flutter docs, visao geral e aprendizado: https://docs.flutter.dev/
- `Scaffold`: https://api.flutter.dev/flutter/material/Scaffold-class.html
- `TextField`: https://api.flutter.dev/flutter/material/TextField-class.html
- `TextEditingController`: https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
- `AlertDialog`: https://api.flutter.dev/flutter/material/AlertDialog-class.html
- Testes de widgets em Flutter: https://docs.flutter.dev/cookbook/testing/widget/introduction
- Pacote `flutter_test`: https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

## Objetivo didático

Este projeto não tenta ser uma calculadora de IMC completa do ponto de vista clínico. O foco principal e didatico: ajudar alunos a entenderem como ligar entrada de dados, validacao, estado, interface e testes em um app Flutter pequeno e fácil de acompanhar.
