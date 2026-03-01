# Aula 04 - Construtores, lista literal de valores (Enum), comparações e String Interning

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração:** 2h/a

## 1. Objetivos da aula

O objetivo desta aula é aprender sobre construtores, entender sobre polimorfismo e aprimorar o raciocínio sobre orientação a objetos. 

Além disso conhecer lista de valores literais fixos (ENUM). 

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

## 4. ENUMs

Um enum (enumeration) é um tipo especial que representa um conjunto fixo e limitado de valores possíveis. Em outras palavras, Enum define um conjunto fechado de constantes.

Observe este exemplo: 

```dart
enum DiaSemana {
  segunda,
  terca,
  quarta,
  quinta,
  sexta,
  sabado,
  domingo
}

void main() {
  DiaSemana hoje = DiaSemana.segunda;

  if (hoje == DiaSemana.domingo) {
    print("Descanso!");
  } else {
    print("Dia útil!");
  }
}
```

Em um outro contexto, podemos ter num sistema o seguinte ENUM representativo de estados possíveis de um pedido: 

```dart
enum StatusPedido {
  pendente,
  enviado,
  entregue
}
```

Em Java, existem ENUMs, porém, os valores são escritos em maiúsculo. 

```java
public enum TIPO_COMBUSTIVEL {
    GASOLINA,
    ETANOL,
    DIESEL
}
```

Em linguagem Dart, os nomes de um ENUM devem ser escritos no padrão PascalCase. Ao invés de TIPO_COMBUSTIVEL usar TipoCombustivel. 
Já os valores são no padrão lowerCamelCase.

Exemplo: 

```dart
enum TipoCombustivel {
    gasolina, 
    etanol, 
    queroseneAviacao //padrao lowerCamelCase
}
```

## 5. As incríveis e divertidas façanhas do Dart

Em Java, quando comparamos se uma instância de um objeto é igual a outra em termos de dados ou se são exatamente as mesmas, implementamos um método chamado equals. O equals verifica se o "conteúdo" do objeto a, é igual ao objeto b (não é tão simples assim, mas por hora, essa definição é a melhor). 

Veja um exemplo em Java da classe pessoa, duas instancias a implementação do equals e comparação. 

```Java
public class Pessoa {

    private String nome;
    private int idade;

    public Pessoa(String nome, int idade) {
        this.nome = nome;
        this.idade = idade;
    }

    // Sobrescrevendo equals
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true; // mesma referência
        }

        if (obj == null) {
            return false;
        }

        if (getClass() != obj.getClass()) {
            return false;
        }

        Pessoa outra = (Pessoa) obj;

        return this.nome.equals(outra.nome)
                && this.idade == outra.idade;
    }

    // Sempre que sobrescrevemos equals, devemos sobrescrever hashCode
    // não vamos entrar em detalhes nisso agora.
    @Override
    public int hashCode() {
        return nome.hashCode() + idade;
    }

    public static void main(String[] args) {

        Pessoa p1 = new Pessoa("João", 30);
        Pessoa p2 = new Pessoa("João", 30);

        System.out.println(p1 == p2);        // false (compara referência)
        System.out.println(p1.equals(p2));   // true (compara conteúdo)
    }
}

```

> PARA MEMORIZAR: Em Java, igualdade lógica é feita com o método equals() implementado numa classe. Enquanto no Dart é diferente, usamos == como em JavaScript. 

Mas. E em dart? Escreva esse exemplo: 

```dart
class Pessoa{
  String nome;
  Pessoa(this.nome); 
}

void main(){
  Pessoa p1 = Pessoa('João'); 
  Pessoa p2 = Pessoa('João');
  // os conteúdos são os mesmos. Mas não sabemos ainda comparar conteúdos. 

  if(p1 == p2){
    print('Mesmas instancias');
  }else{
    print('O conteúdo pode ser igual, mas não são as mesmas instancias');
  }
  
  print(identical(p1,p2));
}
```

Como então comparar os conteúdos? Fazendo algo parecido com Java. Neste caso, sobrescrevemos o operador ==. Parece loucura, mas sim, é dessa maneira. 

Veja um exemplo oficial do Dart e adapte para pessoa como exercício: 

```dart
class ValuePoint {
  final int x, y;
  ValuePoint(this.x, this.y);

  // Override the == operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValuePoint &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y);

  // Override the hashCode getter
  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

void main() {
  var vp1 = ValuePoint(1, 2);
  var vp2 = ValuePoint(1, 2);

  print(vp1 == vp2); // Prints 'true' because we defined custom equality
}
```

## String interning em Dart

Em Strings, a comparação é curiosa. Escreva este exemplo: 

```dart
void main(){ 
    String a = "oi"; 
    String b = "oi"; 
    print(a == b); // true 
    print(identical(a,b)); //true!!!!! (MAS COMO???? se b é uma outra instância???)
}
```

O que acontece é que o compilador reaproveita strings para não criar outras e a referência e b aponta para o mesmo endereço de a.

Agora observe:

```dart
void main(){ 
    String a = "oi"; 
    String b = "xpto"; 
    print(a == b); // false 
    print(identical(a,b)); //false
}
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