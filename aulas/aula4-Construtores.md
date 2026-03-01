# Aula 04 - Construtores e problemas reais

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração:** 2h/a

## 1. Objetivos da aula

O objetivo desta aula é aprender sobre construtores, entender sobre polimorfismo e aprimorar o raciocínio sobre orientação a objetos. 

## 2. O problema de classes mal elaboradas

Vamos iniciar com este código de exemplo hoje: 

```dart
class Carro {
  String? modelo;
  int? ano;

  void imprimir() {
    print('Modelo: $modelo');
    print('Ano: $ano');
  }
}

void main() {
  Carro c1 = Carro();
  c1.imprimir();
}
```

> Pergunta: O que vai sair ao executar o imprimir? Esse carro existe? Nasceu completo? 

## 3. Construtores

Agora observe esse código: 

```dart
class Carro {
  String modelo;
  int ano;

  // Construtor
  Carro(this.modelo, this.ano);

  void imprimir() {
    print('Modelo: $modelo');
    print('Ano: $ano');
  }
}

void main() {
  Carro c1 = Carro("Fusca", 1974);
  c1.imprimir();
}
```

> Pergunta: O que aconteceu diferente ao executar o código? 

### 3.1 Construtor - definição simples e direta:

Construtor é um método especial que tem o mesmo nome da classe;
Ele é executado automaticamente quando instanciamos o Carro;
Ele define como o objeto nasce (com quais dados tem que nascer).

```dart
Carro c1 = Carro("Fusca", 1978);
Carro c2 = Carro("Ferrari", 2023);
```

## Exercício em sala de aula

Uma grande empresa de logística atua no transporte terrestre, aéreo e marítimo.

Ela possui uma frota composta por diferentes tipos de meios de transporte.

Todos os meios de transporte da empresa possuem:

- Identificador interno
- Fabricante
- Modelo
- Capacidade de carga (em toneladas)
- Tipo de combustível

A empresa opera com os seguintes tipos específicos:

- Automóvel
- Motocicleta
- Aeronave
- Embarcação

Sabendo que:

- Automóvel e Motocicleta são veículos terrestres.
- Veículos terrestres possuem: placa, chassi e renavam.
- Automóvel possui número de portas.
- Motocicleta possui cilindradas.
- Aeronave possui envergadura das asas.
- Embarcação possui número de containers que pode carregar.

Tarefa: 

- Modele as classes necessárias.
- Defina corretamente a hierarquia de herança.
- Identifique qual(is) classe(s) devem ser abstratas.
- Indique quais atributos pertencem a cada classe.
- Indique onde deve existir método imprimir().