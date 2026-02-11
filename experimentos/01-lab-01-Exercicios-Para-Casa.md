# Lista de Exercícios — Dart (Casa) — Lab 01

> Execute os exercícios preferencialmente no **DartPad** (https://dartpad.dev) ou em um projeto local Dart no VSCode ou em qualquer ambiente que você queira. 

> Em todos os exercícios, use `print()` para mostrar resultados.

> **Nota do professor**: Dessa vez, não use IA para te apoiar nesses exercícios. Faça-os com calma, sem pressa, ERRAR é importante. Sem erro não há aprendizado. A ideia é simplesmente se familiarizar com Dart! Se não conseguir, insista. Sem apoio de IA. 

---

## 1) Olá, Dart
Crie um programa que imprima (não é necessário ler nada de entrada - os dados estarão em variáveis):
- seu nome
- sua idade
- sua turma

---

## 2) Soma simples
Declare dois inteiros `a` e `b` e imprima a soma, em seguida, imprima qual o maior entre eles.

---

## 3) Par ou ímpar
Dado um número inteiro `n`, imprima `par` se for par, ou `ímpar` caso contrário.

---

## 4) Maior de três
Dados três números `a`, `b`, `c`, imprima qual o maior deles. Faça do seu jeito.

---

## 5) Média e conceito
Dadas duas notas `n1` e `n2`, calcule a média e imprima:
(Atenção, valide se as notas estão entre zero e 10)
- `Parabéns` se média = 10
- `Ótimo` se média >= 8
- `Aprovado` se média >= 5
- `Reprovado` caso contrário

---

## 6) Contagem de 1 a N
Dado um inteiro `n`, imprima todos os números de 1 até `n`.

---

## 7) Tabuada
Dado um inteiro `n`, imprima a tabuada completa de `n` de 1 a 10, linha por linha.

---

## 8) Soma de uma lista
Dada uma lista de inteiros, calcule e imprima a soma dos elementos.

---

## 9) Filtrar pares
Dada uma lista de inteiros, crie uma nova lista contendo apenas os números pares e imprima.

---

## 10) Contar palavras
Dada uma lista de strings (palavras), imprima:
- quantas palavras existem
- qual a maior palavra (maior comprimento)

---

## 11) Map de aluno
Crie um `Map<String, dynamic>` chamado `aluno` com:
- `nome`, `ra`, `curso`, `turma`
Imprima uma frase formatada com esses dados.
(Estude o que é um Map)

---

## 12) Frequência de letras
Dada uma string `texto`, conte quantas vezes cada letra aparece e imprima um mapa de frequências.
(Considere apenas letras minúsculas e ignore espaços.)

---

## 13) Função `ehPrimo`
Crie uma função `bool ehPrimo(int n)` que retorne `true` se `n` for primo, senão `false`.
Teste com alguns valores.

---

## 14) Função `maximo`
Crie uma função `int maximo(List<int> nums)` que retorne o maior valor da lista.

---

## 15) Função de ordem superior
Crie uma função `List<int> aplicar(List<int> nums, int Function(int) f)`
que aplique `f` em cada item e retorne a lista transformada.
Teste duplicando valores e depois elevando ao quadrado.

---

## 16) Null Safety (prática)
Crie uma função `int tamanhoOuZero(String? s)` que retorne:
- `0` se `s` for `null`
- o tamanho da string caso contrário

---

> DESTAQUE: do 17 ao 20, estude os conceitos nas documentações do Dart e do Flutter.

## 17) Classe `Produto`
Crie uma classe `Produto` com:
- `nome` (String)
- `preco` (double)
Crie um método `String etiqueta()` que retorne `"NOME - R$ PRECO"`.
Crie 2 produtos e imprima as etiquetas.
(Tente estudar sobre Classes - Será nosso próximo tema)

---

## 18) Classe `Carrinho`
Crie uma classe `Carrinho` com uma lista de `Produto` e métodos:
- `adicionar(Produto p)`
- `double total()`
Teste adicionando produtos e imprimindo o total.

---

## 19) Enum de status
Crie um enum `StatusPedido { aberto, pago, enviado, entregue }`
Crie uma função que recebe um `StatusPedido` e imprime uma mensagem apropriada.

---

## 20) Async/Await (simulação)
Crie uma função `Future<String> buscarDados()` que espere 1 segundo e retorne `"OK"`.
No `main`, use `await` para chamar e imprimir o resultado.

---