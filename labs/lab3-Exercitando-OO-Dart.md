# Lab 03 — Treinando classes e instâncias

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2h/a

## 🎯 Objetivos do Lab

Entender conceitos básicos de orientação a objetos em Dart, indispensáveis para programar usando Flutter.

## ✅ Pré-requisitos

* Acesso ao DartPad online ou VS Code com Flutter e Dart devidamente configurados;

> 📌 Dica: mantenha aberto `referencias/links.md` para acesso rápido à documentação oficial.


## Código 1: Classe Pessoa e os atributos (nullable types = desligando o null safety) 

```dart
// Definição de uma classe para representar uma pessoa. 
class Pessoa{
  String? nome; 
  String? dataNascimento;
  double? peso; 
  double? altura;
}

void main(){
  Pessoa p1 = Pessoa();
  p1.nome = 'João';
  p1.dataNascimento = '2000-11-12';
  p1.peso = 100.2;
  p1.altura = 1.82;
}
```

Importante: no exemplo acima, foi o primeiro contato com a criação de uma classe (sem construtor específico), o objetivo foi o de: vou fazer minha primeira classe e, todos os atributos de uma pessoa são opcionais (podem aceitar nulo = null) para entender o uso do '?' ao final da definição do tipo, por exemplo: String? ao invés de String. 

Exercício 1: usando o exemplo acima, complemente o código com uma nova instância de pessoa e, sem atribuir nenhum dado, faça o programa imprimir o nome. Deverá sair null. 
Um dos nomes que damos para esse problema é: Estado inconsistente. 

Exercício 2: Crie uma instância completa de pessoa, chamada p2 e atribua os dados que desejar, para que fique semelhante ao exemplo de p1. 

## Código 2: Imprimindo os dados de Pessoa (com uma função fora da classe)

Faça o código: 

```dart
// Definição de uma classe para representar alguns dados de uma pessoa. 
// Exemplo estritamente didático para iniciantes.
class Pessoa{
  String? nome; 
  String? dataNascimento;
  double? peso; 
  double? altura;
}

// A função imprimir.
void imprimir(Pessoa p){
  print('\nNome: ${p.nome}');
  print('Data de nascimento: ${p.dataNascimento}');
  print('Peso: ${p.peso}');
  print('Altura: ${p.altura}');
}

// função principal, ponto de entrada do programa em Dart.
void main(){
  Pessoa p1 = Pessoa();
  p1.nome = 'João';
  p1.dataNascimento = '2000-11-12';
  p1.peso = 100.2;
  p1.altura = 1.82;
  
  Pessoa p2 = Pessoa();
  p2.nome = 'Alice';
  p2.dataNascimento = '1999-07-03';
  p2.peso = 50.0;
  p2.altura = 1.70;
  
  imprimir(p1);
  imprimir(p2);
}
```
Observe: 
- A função imprimir está fora da classe pessoa. 
- Para usar a função imprimir, devemos passar uma instância de Pessoa como parâmetro.


## Criando uma classe estudante que herda de Pessoa (uso do extends)

Após a definição da classe Pessoa, defina a classe Estudante conforme o código: 

```dart
class Estudante extends Pessoa {
  String? registroAcademico; 
}
```

> Nota: Estudante é uma Pessoa. Podemos ler dessa forma ou: Estudante herda da classe Pessoa. A superclasse de Estudante é a classe Pessoa. "POR ENQUANTO", podemos dizer que tudo que pessoa é ou faz, estudante também terá e fará. Ou seja, Estudante terá os atributos nome, dataNascimento, peso e altura por herançam e também o atributo específico: registroAcadademico (RA). 

Crie uma instância de estudante, após a instância p2 (Pessoa):

```dart
Estudante e1 = Estudante();
e1.nome = 'Matheus';
e1.dataNascimento = '2005-02-22'; 
e1.peso = 82.2;
e1.altura = 1.77;
e1.registroAcademico = '25010101';
```

Já temos uma função imprimir que mostra os dados de uma pessoa. Como estudante é uma pessoa, a função imprimir aceita ser chamada normalmente. Teste: 

```dart
imprimir(e1);
```

> Exercício Rápido: Pare uns minutos e pense um pouco: Como você faria a implementação de uma função imprimir estudante? 

### Resposta do exercício rápido: 

Muito provavelmente, um iniciante sem experiência em programação orientada a objetos e que programa há pouco tempo, tentaria fazer alguma coisa do tipo: 


```dart 

// TENTARIA ESSA SOLUÇÃO (vamos chamar de A)
// Tentaria: dar o mesmo nome para as funções, ao perceber que isso não seria possível, 
// nomearia: imprimirPessoa e imprimirEstudante.

// A função imprimir (agora chamada imprimirPessoa, pois não podemos ter, duas funções com o mesmo nome - a princípio -)
void imprimirPessoa(Pessoa p){
  print('\nNome: ${p.nome}');
  print('Data de nascimento: ${p.dataNascimento}');
  print('Peso: ${p.peso}');
  print('Altura: ${p.altura}');
}

// A função imprimirEstudante
void imprimirEstudante(Estudante e){
  print('\nNome: ${e.nome}');
  print('Data de nascimento: ${e.dataNascimento}');
  print('Peso: ${e.peso}');
  print('Altura: ${e.altura}');
  print('Registro acadêmico: ${e.registroAcademico}');
}

// ---------- Após um tempo --------------
// O iniciante programador, perceberia que
// poderia chamar a função imprimirPessoa, visto que Estudante herda de Pessoa:
void imprimirEstudante(Estudante e){
  imprimirPessoa(e);
  print('Registro acadêmico: ${e.registroAcademico}');
}

```

## Solução quase final

Mas, com a ajuda dos conceitos de orientação a objetos, temos uma solução melhor para o problema. 

Considerando que este seja um exemplo para inciantes que ainda estão exercitando a abstração de objetos, comportamentos e atributos, o exemplo a seguir pode parecer complexo, mas na verdade não é. 

Pense que:

- Ambas as classes possuem o comportamento de imprimir, mas diferem em conteúdo: O estudante precisa ter o RA impresso, enquanto para pessoa, RA não existe, afinal é a superclasse conforme explicado pelo professor em sala de aula. 

- Você gostaria que ambas as funções chamassem imprimir e, que fossem invocadas a partir da instância e não ficassem flutuando fora das classes, para que a classe tivesse todo o comportamento necessário. 

```dart 

// Incluimos o imprimir na classe pessoa, 
// passou a ser um comportamento de pessoa, ou seja: método.
class Pessoa{
  String? nome; 
  String? dataNascimento;
  double? peso; 
  double? altura;
  
  void imprimir(){
    print('\nNome: ${nome}');
    print('Data de nascimento: ${dataNascimento}');
    print('Peso: ${peso}');
    print('Altura: ${altura}');
  }
}

class Estudante extends Pessoa {
  String? registroAcademico; 
  
  /*
   * Como a classe Pessoa já tem um imprimir, 
   * queremos que o imprimir da classe Estudante, seja diferente, mas não tanto.
   * partindo do ponto que a classe Estudante já tem o método imprimir (porque herdou de Pessoa)
   * precisamos sobrescreve-lo (override) para que o comportamento seja específico, quando uma instancia
   * de estudante for impressa. Isso significa, que no método imprimir de estudante, 
   * chamaremos o imprimir de Pessoa e APÓS isso, imprimiremos o único atributo que falta: registroAcadêmico.
   */ 
  
  @override
  void imprimir(){
    super.imprimir();
    print('RA: ${registroAcademico}');
  }
}

// função principal, ponto de entrada do programa em Dart.
void main(){
  Pessoa p1 = Pessoa();
  p1.nome = 'João';
  p1.dataNascimento = '2000-11-12';
  p1.peso = 100.2;
  p1.altura = 1.82;
  
  Pessoa p2 = Pessoa();
  p2.nome = 'Alice';
  p2.dataNascimento = '1999-07-03';
  p2.peso = 50.0;
  p2.altura = 1.70;
  
  Estudante e1 = Estudante();
  e1.nome = 'Matheus';
  e1.dataNascimento = '2005-02-22'; 
  e1.peso = 82.2;
  e1.altura = 1.77;
  e1.registroAcademico = '25010101';
  
  // note como fica interessante: 
  p1.imprimir();
  p2.imprimir();
  e1.imprimir();
    
}
```

## Fechamento conceitual da aula prática

Com este laboratório, você: 

- Programou suas duas primeiras classes: Pessoa e Estudante;
- Aprendeu a instanciar objetos reais. Duas instâncias de Pessoa (p1 e p2) e uma instância de Estudante (e1);
- Entendeu na prática como fazer herança. Estudante é Pessoa. Então terá todos os atributos e comportamentos que Pessoa tem.
- Percebeu que precisou adaptar o imprimir para que funcionasse especificamente para Estudante.
- Notou que mesmo assim, esse código ainda tem melhorias, pois poderíamos criar uma instancia de p3 ou uma de estudante e2 e não colocar NENHUM dado e pedir para imprimir, o que resultaria na impressão de uma série de dados nulos. 

**Lab 03 — TPDM / Mobile 2026**
