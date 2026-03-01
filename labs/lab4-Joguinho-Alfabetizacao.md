# Lab 04 — Treinando classes e instâncias

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2h/a

## 🎯 Objetivos do Lab

Ao final deste laboratório, o estudante deverá ser capaz de:

* Reforçar o entendimento do lab anterior (Lab 3);
* Entender a importância das classes abstratas; 
* Se divertir com esse exemplo tradicional aplicado nas aulas até hoje de OOP no MIT.

## ✅ Pré-requisitos

* Acesso ao DartPad online ou VS Code com Flutter e Dart devidamente configurados;

> 📌 Dica: mantenha aberto `referencias/links.md` para acesso rápido à documentação oficial.

## Atenção

A explicação da construção evolutiva desse joguinho foi ensinada em laboratório prático. Não será explicada novamente passo-a-passo em texto neste laboratório e os motivos de ter construído dessa forma e não de outra. Tudo isso foi discutido durante a aula de laboratório.

## Código Completo

```dart
// Arquitetura de um game para crianças em alfabetização.
// Objetivo: treinar criar Superclasse, herança e reimplementar/adaptar comportamentos.
// entender o que é classe abstrata e porquê não faz sentido ser instanciada. 
abstract class Animal{
  void show(){
    print('Animação: Música tocando... suspense... som de tambores...'); 
  }
  void hide(){
    print('Animação: Bichinho desaparece na fumaça ... puffff...');
  }
}

class Dog extends Animal{
  @override
  void show(){
    super.show();
    print('Animação: Cachorro caminha até o centro da tela.');
  }
  void bark(){
    print('Au Au ...');
  }
}

class Cat extends Animal {
  @override
  void show(){
    super.show();
    print('Animação: Gato vem pulando pelos galhos das árvores da floresta...');
  }
  void meow(){
    print('Meeeeeeooooowwww ...');
  }
}

// funcao principal - ponto de entrada do jogo. 
void main(){
  print('Cenário pronto...');
  
  Dog d1 = Dog();
  d1.show();
  d1.bark();
  d1.hide();
  
  print('Lista de palavras para a criança escolher a grafia correta...');
  print('Criança escolhe a palavra, espera um tempo... e outro animal surge...');
  
  Cat c1 = Cat();
  c1.show();
  c1.meow();
  c1.hide();
  
  print('Lista de palavras para a criança escolher a grafia correta...');
  print('Criança escolhe a palavra, espera um tempo... e outro animal surge...');
  
}
```

## Nota importante sobre a proposta pedagógica desta aula

Este exemplo é **propositalmente simples e incremental**.

O objetivo não é apresentar a modelagem mais sofisticada possível, nem abordar interfaces, contratos avançados ou padrões arquiteturais completos. Não é esse o tema desta disciplina.

Trata-se de uma abordagem pedagógica evolutiva, amplamente utilizada em cursos introdutórios de computação em instituições de referência internacional, incluindo o MIT.

O foco é permitir que o estudante:
- compreenda herança de forma concreta
- experimente sobrescrita de métodos
- perceba limitações do modelo inicial
- evolua gradualmente a arquitetura e aprenda novos conceitos naturalmente

**Erros e simplificações fazem parte intencional do processo de aprendizagem**.

Se você já possui sólida experiência profissional em orientação a objetos, este repositório não foi pensado para você. O público-alvo dele é estudantes em formação. 

## Tarefas: 

Criar Horse que terá o método relinchar e o show é totalmente diferente, não tem música nem tambores, som de cavalaria. 

Criar Bird que show() “voa e pousa” e tem chirp().

Criar Cow com moo() e um show() diferente.

Pergunta de reflexão e lembrar do conceito de classe abstrata: por que Animal não faz sentido ser instanciada?

(Bônus) Crie uma lista: List<Animal> animals = [Dog(), Cat(), Bird()]; e chamar show() em loop (isso introduz polimorfismo de forma natural).

**Lab 04 — TPDM / Mobile 2026**