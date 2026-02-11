# Lab 01 — Setup do Ambiente + Dart (online) + Primeiro App Flutter

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2h/a (pode virar 3h se necessário) 

## 🎯 Objetivos do Lab

Ao final deste laboratório, o estudante deverá ser capaz de:

* Executar pequenos programas em **Dart** (online) e compreender a sintaxe mínima e básica;
* Instalar e validar o ambiente Flutter com `flutter doctor`;
* Criar e executar o primeiro aplicativo Flutter (**Hello App**) em emulador/dispositivo;
* Entender o ciclo básico: **editar → hot reload → testar**.

## ✅ Pré-requisitos

* Conta no GitHub (se possível, já criada)
* Computador com pelo menos 8 GB RAM (recomendado)
* Acesso à internet

> 📌 **Dica:** mantenha aberto o arquivo `referencias/links.md` para atalhos de instalação.


## Parte A — Dart (online) — 30 a 40 min

### A1) Abrir o DartPad

Acesse: [https://dartpad.dev](https://dartpad.dev)

> Vamos usar o DartPad para praticar Dart **sem instalar nada**.

### A2) Exercício 1 — Variáveis e impressão

Cole e rode:

```dart
void main() {
  var nome = 'Nick';
  var idade = 3;

  print('Nome: $nome');
  print('Idade: $idade');
}
```

**Tarefa:**

* Troque `nome` e `idade` pelos seus.

### A3) Exercício 2 — Funções

```dart
int soma(int a, int b) {
  return a + b;
}

void main() {
  print(soma(2, 3));
}
```

**Tarefa:**

* Crie uma função `multiplica(int a, int b)` e imprima o resultado.

### A4) Exercício 3 — Condicionais

```dart
void main() {
  int nota = 7;

  if (nota >= 5) {
    print('Aprovado');
  } else {
    print('Reprovado');
  }
}
```

**Tarefa:**

* Ajuste para:

  * `>= 8`: "Ótimo"
  * `>= 6`: "Aprovado"
  * senão: "Reprovado"

### A5) Exercício 4 — Listas e laços

```dart
void main() {
  final frutas = ['maçã', 'banana', 'uva'];

  for (final f in frutas) {
    print(f);
  }
}
```
**Tarefa:**

* Adicione mais 2 frutas e imprima também o total de itens.

### A6) Exercício 5 — Map (chave/valor)

```dart
void main() {
  final aluno = {
    'nome': 'Mateus',
    'curso': 'Engenharia de Software',
  };

  print(aluno['nome']);
  print(aluno['curso']);
}
```

**Tarefa:**

* Adicione uma chave `ra` e uma chave `turma`.

### A7) Exercício 6 — Null Safety (conceito)

```dart
void main() {
  String? apelido; // pode ser null
  print(apelido);

  apelido = 'Dias';
  print(apelido);
}
```

**Tarefa:**

* Explique (em 1 frase) por que `String?` existe.

## Parte B — Setup do Flutter — 40 a 60 min

> O objetivo aqui é **instalar e validar**, não é customizar tudo.

### B1) Instalação

Siga o guia oficial conforme seu sistema:

* Instalação do Flutter SDK: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

> 📌 Durante o semestre, priorize sempre documentação oficial.

### B2) Verificação do ambiente

No terminal, rode:

```bash
flutter --version
flutter doctor
```

**Meta:**

* Deixar o `flutter doctor` com o máximo de checks verdes.

### B3) Emulador / dispositivo

Escolha 1 opção:

**Opção 1 — Emulador Android (recomendado)**

* Android Studio → Device Manager → criar e iniciar um emulador

**Opção 2 — Celular Android**

* Ativar "Opções do desenvolvedor" e "Depuração USB"

> iOS exige macOS + Xcode (vamos falar disso mais para frente).

## Parte C — Primeiro app Flutter (Hello App) — 30 a 40 min

### C1) Criar um projeto

Escolha uma pasta no seu computador e execute:

```bash
flutter create hello_flutter
cd hello_flutter
```

### C2) Abrir no editor

Opções comuns:

* VS Code
* Android Studio

### C3) Executar o app

Com emulador ligado (ou celular conectado), rode:

```bash
flutter run
```

Você deve ver o app padrão do Flutter rodando.


### C4) Primeira alteração + Hot Reload

Abra `lib/main.dart` e faça uma alteração simples no título (ex.: "Hello Flutter").

Salve o arquivo e observe o **Hot Reload** atualizando.

**Tarefa:**

* Trocar o texto da tela inicial para: `Meu primeiro app em Flutter`.


## ✅ Entregável do Lab 01

Ao final, o estudante deve:

1. Ter rodado os exercícios A1–A7 no DartPad (pelo menos até A5);
2. Ter o `flutter doctor` executado;
3. Ter o app `hello_flutter` rodando no emulador/celular.

> 📌 Se faltar tempo, finalize em casa e traga a evidência na próxima aula.


## 🧯 Troubleshooting rápido

### Erro: `flutter` não encontrado

* Flutter SDK não está no `PATH` (revisar instalação)

### `flutter doctor` reclama de Android toolchain

* Instalar Android Studio
* Instalar SDK Platform + Command-line Tools
* Aceitar licenças:

```bash
flutter doctor --android-licenses
```

### Emulador não aparece / não inicia

* Verificar se existe o Android Emulator no computador.

## 🔜 Próximo aula

* **Aula/Lab 02:** Widgets, layout e navegação — início do App A

---

**Lab 01 — TPDM / Mobile 2026**
