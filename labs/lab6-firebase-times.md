# Lab 06 — Firebase Functions com app de times

## 🔗 Para consultar durante o laboratório

* [Firebase Functions — Callable Functions](https://firebase.google.com/docs/functions/callable)
* [Adicionar Firebase ao app Flutter / `firebase_core`](https://firebase.google.com/docs/flutter/setup)
* [Repositório de apoio: `SI-Estudos-BD-2/experimentos_firebase`](https://github.com/mateusdias/SI-Estudos-BD-2/tree/main/experimentos_firebase)

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2 h/a a 3 h/a

## 🎯 Objetivos do Lab

Ao final deste laboratório, o estudante deverá ser capaz de:

* Entender a proposta de separar o frontend em Flutter da lógica de backend no Firebase;
* Preparar um projeto Firebase com `functions` em TypeScript;
* Criar a function `addNewSoccerTeam`;
* Criar a function `getSoccerTeams`;
* Integrar o app da pasta `exemplos/Lista/exemplo_lista_card` com essas functions;
* Compreender o fluxo completo: app Flutter -> Cloud Function -> Firestore.

## 🧭 O que este experimento propõe

Até aqui, o app de times funciona com uma lista em memória: ao adicionar um time, ele aparece na tela, mas os dados não ficam salvos permanentemente.

Neste experimento, a proposta é dar um passo além:

* o app Flutter continuará sendo a interface com o usuário;
* o Firebase Functions será o backend da aplicação;
* o Firestore será usado como banco de dados para persistir os times.

Em outras palavras, o aluno vai transformar um app local em um app conectado a serviços na nuvem.

> 📌 Ideia central do lab: em vez de salvar os times apenas na variável `_teams`, o aplicativo passará a enviar e buscar dados usando funções escritas em TypeScript dentro da pasta `functions` do Firebase.

## ✅ Pré-requisitos

* Ter o Flutter configurado e funcionando;
* Ter conta no Firebase;
* Ter Node.js e npm instalados;
* Ter o Firebase CLI instalado;
* Conhecer o app da pasta `exemplos/Lista/exemplo_lista_card`;
* Saber executar comandos básicos de terminal.

Comando útil para instalar o Firebase CLI:

```bash
npm install -g firebase-tools
```

Login no Firebase:

```bash
firebase login
```

## 📁 App base deste laboratório

Use como ponto de partida o app:

```text
exemplos/Lista/exemplo_lista_card
```

Esse app já possui:

* uma tela de listagem de times;
* uma tela de cadastro;
* o modelo `SoccerTeam` com `name` e `foundationYear`.

Neste lab, o comportamento atual deverá evoluir de:

* lista local em memória

para:

* cadastro remoto via Firebase Function;
* carregamento remoto via Firebase Function.

## Parte A — Entendendo a arquitetura proposta

Antes de codificar, leia o fluxo abaixo:

1. O usuário abre o app Flutter;
2. O app chama a function `getSoccerTeams`;
3. A function consulta o Firestore;
4. O backend devolve a lista de times;
5. O app exibe os times na tela;
6. Quando o usuário cadastra um novo time, o app chama `addNewSoccerTeam`;
7. A function valida os dados e salva no Firestore;
8. O app recarrega a lista.

### Tarefa conceitual

Responda com suas palavras:

* Qual é o papel do Flutter neste fluxo?
* Qual é o papel das Cloud Functions?
* Qual é o papel do Firestore?

## Parte B — Criando o projeto Firebase com Functions

No terminal, crie ou acesse a pasta do projeto que será usada com Firebase.

Inicialize o Firebase:

```bash
firebase init
```

Durante a configuração:

* selecione `Functions` e `Firestore`;
* escolha `TypeScript`;
* aceite instalar as dependências;
* associe o projeto a um projeto Firebase já criado no console.

Após a inicialização, você deverá ter algo semelhante a:

```text
functions/
  src/
    index.ts
  package.json
firestore.rules
firebase.json
```

## Parte C — Estrutura de dados esperada

Cada time poderá ser salvo com a seguinte estrutura no Firestore:

```json
{
  "name": "Guarani",
  "foundationYear": 1911,
  "createdAt": "timestamp do servidor"
}
```

Coleção sugerida:

```text
soccerTeams
```

## Parte D — Criando a function `addNewSoccerTeam`

### Objetivo

Criar uma function que receba os dados de um time e grave esse time no Firestore.

### Regras esperadas

A function deve:

* receber `name` e `foundationYear`;
* validar se o nome não está vazio;
* validar se o ano é numérico;
* validar se o ano está em uma faixa aceitável;
* salvar o documento na coleção `soccerTeams`;
* retornar uma mensagem de sucesso e o `id` do documento criado.

### Exemplo em TypeScript

Arquivo sugerido: `functions/src/index.ts`

```ts
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

initializeApp();

const db = getFirestore();

export const addNewSoccerTeam = onCall(async (request) => {
  const { name, foundationYear } = request.data;

  if (!name || typeof name !== "string" || name.trim().length === 0) {
    throw new HttpsError("invalid-argument", "O nome do time é obrigatório.");
  }

  if (typeof foundationYear !== "number") {
    throw new HttpsError("invalid-argument", "O ano de fundação deve ser numérico.");
  }

  if (foundationYear < 1850 || foundationYear > new Date().getFullYear()) {
    throw new HttpsError("invalid-argument", "O ano de fundação é inválido.");
  }

  const docRef = await db.collection("soccerTeams").add({
    name: name.trim(),
    foundationYear,
    createdAt: FieldValue.serverTimestamp(),
  });

  logger.info("Novo time cadastrado", { id: docRef.id, name, foundationYear });

  return {
    message: "Time cadastrado com sucesso.",
    id: docRef.id,
  };
});
```

### Tarefa

Implemente a function e explique:

* o que entra em `request.data`;
* por que usamos `HttpsError`;
* por que `FieldValue.serverTimestamp()` é útil.

## Parte E — Criando a function `getSoccerTeams`

### Objetivo

Criar uma function que leia os times salvos no Firestore e devolva uma lista para o app Flutter.

### Regras esperadas

A function deve:

* consultar a coleção `soccerTeams`;
* ordenar por `foundationYear` ou `createdAt`;
* retornar uma lista com os dados dos times.

### Exemplo em TypeScript

```ts
export const getSoccerTeams = onCall(async () => {
  const snapshot = await db
    .collection("soccerTeams")
    .orderBy("foundationYear", "asc")
    .get();

  const teams = snapshot.docs.map((doc) => ({
    id: doc.id,
    name: doc.data().name,
    foundationYear: doc.data().foundationYear,
  }));

  logger.info("Lista de times consultada", { total: teams.length });

  return { teams };
});
```

### Tarefa

Implemente a function e responda:

* por que o retorno é um array de objetos;
* por que o `id` do documento pode ser útil no app.

## Parte F — Publicando ou emulando as functions

Para testar localmente com emulador:

```bash
firebase emulators:start
```

Para publicar:

```bash
firebase deploy --only functions
```

### Tarefa

Explique a diferença entre:

* testar com emulador;
* publicar na nuvem.

## Parte G — Integrando o Flutter com o Firebase

Agora, o aluno deverá adaptar o app `exemplos/Lista/exemplo_lista_card` para consumir as functions.

### Passo 1 — Adicionar dependências

No `pubspec.yaml`, adicione dependências como:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: versão compatível com a turma
  cloud_functions: versão compatível com a turma
```

Depois:

```bash
flutter pub get
```

### Passo 2 — Inicializar o Firebase no app

No `main.dart`, inicialize o Firebase antes do `runApp`.

Exemplo:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

> 📌 Se o projeto estiver configurado com FlutterFire CLI, o arquivo `firebase_options.dart` também deverá ser usado.

### Passo 3 — Criar um serviço para chamar as functions

Sugestão de classe:

```dart
import 'package:cloud_functions/cloud_functions.dart';

class SoccerTeamService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> addNewSoccerTeam({
    required String name,
    required int foundationYear,
  }) async {
    final callable = _functions.httpsCallable('addNewSoccerTeam');
    await callable.call({
      'name': name,
      'foundationYear': foundationYear,
    });
  }

  Future<List<Map<String, dynamic>>> getSoccerTeams() async {
    final callable = _functions.httpsCallable('getSoccerTeams');
    final result = await callable.call();
    final data = result.data as Map<String, dynamic>;
    final teams = List<Map<String, dynamic>>.from(data['teams']);
    return teams;
  }
}
```

## Parte H — Adaptando o app de lista

O código atual mantém os times apenas em:

```dart
final List<SoccerTeam> _teams = [];
```

A proposta deste lab é substituir a dependência exclusiva dessa lista local por carregamento remoto.

### O que o aluno deverá fazer

* carregar os times ao abrir a tela;
* chamar `getSoccerTeams` no início;
* converter os dados recebidos em objetos `SoccerTeam`;
* chamar `addNewSoccerTeam` ao salvar um novo time;
* atualizar a lista após o cadastro.

### Sugestão de reflexão

Compare os dois cenários:

* lista local em memória;
* lista carregada do backend.

Responda:

* o que melhora?
* o que fica mais complexo?

## Parte I — Entrega esperada

Ao final deste laboratório, o estudante deve entregar:

1. As duas functions implementadas em TypeScript:
   * `addNewSoccerTeam`
   * `getSoccerTeams`
2. O app Flutter adaptado para consumir as functions;
3. Evidência de funcionamento com pelo menos:
   * cadastro de 2 times;
   * listagem dos times vindos do backend;
   * explicação do fluxo completo da requisição.

## ✅ Critérios de sucesso

Considere o experimento concluído se:

* o app conseguir cadastrar um time usando `addNewSoccerTeam`;
* o app conseguir listar os times usando `getSoccerTeams`;
* os dados permanecerem salvos mesmo após reiniciar o app;
* o aluno conseguir explicar a diferença entre frontend, function e banco.

## 🧯 Troubleshooting rápido

### Erro de inicialização do Firebase no Flutter

* Verifique se o projeto foi configurado com `flutterfire configure`;
* Confirme se `Firebase.initializeApp()` foi chamado antes do `runApp`.

### Function não aparece no deploy

* Verifique se ela foi exportada corretamente em `functions/src/index.ts`;
* Rode `npm run build` dentro de `functions`, se necessário.

### App chama a function, mas recebe erro de permissão

* Revise as regras, configuração do projeto e autenticação, se estiver sendo exigida;
* Teste primeiro com uma function simples e sem regras adicionais de autenticação.

### Dados não aparecem na lista

* Verifique se a function `getSoccerTeams` realmente retorna `{ teams: [...] }`;
* Confirme se o app Flutter está convertendo corretamente `result.data`.

## 🔜 Desafio complementar

* Criar uma terceira function chamada `deleteSoccerTeam`;
* Integrar o gesto de remover item da lista com exclusão real no Firestore;
* Exibir mensagens de sucesso e erro usando `SnackBar`.

---

**Lab 06 — TPDM / Mobile 2026**
