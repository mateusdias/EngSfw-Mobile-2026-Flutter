# Lab 07 — Firebase Storage com autenticação no app de câmera

## 🔗 Para consultar durante o laboratório

* [Adicionar Firebase ao app Flutter](https://firebase.google.com/docs/flutter/setup)
* [Firebase Authentication com Flutter](https://firebase.google.com/docs/auth/flutter/start)
* [Firebase Storage com Flutter](https://firebase.google.com/docs/storage/flutter/start)
* [Regras de segurança do Cloud Storage](https://firebase.google.com/docs/storage/security)

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2 h/a a 3 h/a

## 🎯 Objetivos do Lab

Ao final deste laboratório, o estudante deverá ser capaz de:

* Configurar um app Flutter Android para usar Firebase;
* Entender o papel do arquivo `google-services.json`;
* Habilitar autenticação por e-mail e senha no Firebase;
* Fazer login no app Flutter usando `firebase_auth`;
* Enviar imagens para o Firebase Storage;
* Organizar os arquivos enviados por UID do usuário autenticado;
* Criar regras de segurança para impedir acesso indevido a fotos de outros usuários.

## 🧭 O que este experimento propõe

Neste lab, vamos evoluir o app:

```text
exemplos/app_camera/app_camera
```

Esse app já consegue:

* abrir a câmera;
* tirar uma foto;
* mostrar a foto na tela;
* enviar a foto para o Firebase Storage.

A evolução proposta é tornar esse envio mais próximo de um cenário real:

* o app deverá estar conectado corretamente a um projeto Firebase;
* o Firebase Authentication deverá ter um usuário de teste;
* o app Flutter deverá autenticar esse usuário automaticamente;
* cada foto enviada deverá ser salva dentro de uma pasta com o UID do usuário autenticado;
* as regras do Storage deverão permitir acesso apenas ao próprio usuário.

> 📌 Ideia central do lab: não basta enviar arquivos para `images/`. Em uma aplicação com usuários, os dados precisam ser organizados e protegidos de acordo com quem está autenticado.

## ✅ Pré-requisitos

* Ter o Flutter configurado e funcionando;
* Ter uma conta Google com acesso ao Firebase Console;
* Ter o app `exemplos/app_camera/app_camera` abrindo no VS Code ou Android Studio;
* Conseguir executar o app em um emulador Android ou dispositivo físico;
* Saber acessar o terminal dentro da pasta do projeto.

## Parte A — Preparando o Firebase no app Android

### A1) Criar ou acessar um projeto Firebase

Acesse:

```text
https://console.firebase.google.com/
```

Crie um novo projeto ou use um projeto existente para este laboratório.

### A2) Registrar o app Android

No Firebase Console:

1. Acesse as configurações do projeto;
2. Clique em adicionar app Android;
3. Informe o package name do app.

No exemplo deste laboratório, o package name está em:

```text
exemplos/app_camera/app_camera/android/app/build.gradle.kts
```

Procure por:

```kotlin
applicationId = "br.pro.mateus.appcamera"
```

Use exatamente esse valor ao registrar o app Android no Firebase.

### A3) Baixar o `google-services.json`

Depois de registrar o app Android, baixe o arquivo:

```text
google-services.json
```

Coloque esse arquivo em:

```text
exemplos/app_camera/app_camera/android/app/google-services.json
```

> Atenção: esse arquivo conecta o app Flutter ao projeto Firebase correto. Se ele estiver ausente, no lugar errado ou associado a outro package name, o app pode falhar ao inicializar o Firebase.

### A4) Conferir a configuração Gradle

O exemplo já deve possuir o plugin do Google Services no arquivo:

```text
exemplos/app_camera/app_camera/android/app/build.gradle.kts
```

Confira se existe:

```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
```

Também confira se o arquivo abaixo possui o plugin disponível:

```text
exemplos/app_camera/app_camera/android/settings.gradle.kts
```

Trecho esperado:

```kotlin
id("com.google.gms.google-services") version "4.4.4" apply false
```

### A5) Testar dependências

Dentro da pasta do app:

```bash
cd exemplos/app_camera/app_camera
flutter pub get
```

Depois, tente executar:

```bash
flutter run
```

### A6) Habilitar o Firebase Storage

No Firebase Console:

1. Acesse **Storage**;
2. Clique em **Get started** ou **Primeiros passos**;
3. Escolha a região do bucket;
4. Conclua a criação do Storage.

Neste primeiro momento, não se preocupe em deixar as regras finais prontas. As regras serão ajustadas na Parte F, depois que o app já estiver autenticando o usuário.

## Parte B — Habilitando Authentication no Firebase

### B1) Ativar o provider e-mail/senha

No Firebase Console:

1. Acesse **Authentication**;
2. Clique em **Get started** ou **Primeiros passos**;
3. Acesse a aba **Sign-in method**;
4. Habilite o provider **Email/Password**;
5. Salve a configuração.

### B2) Criar usuário de teste

Ainda em **Authentication**, acesse a aba **Users** e crie um usuário:

```text
E-mail: admin@teste.com.br
Senha: 123456
```

> Importante: essa senha simples e o login hardcoded são apenas para fins didáticos neste laboratório. Em um app real, o usuário deveria digitar suas credenciais em uma tela de login, e a senha nunca ficaria escrita diretamente no código.

### Tarefa conceitual

Responda com suas palavras:

* O que é um provider de autenticação?
* Qual é a diferença entre o e-mail do usuário e o UID do usuário?
* Por que o UID é melhor do que o e-mail para nomear pastas e documentos internos?

## Parte C — Adicionando `firebase_auth` ao app Flutter

O app já usa:

* `firebase_core`;
* `firebase_storage`;
* `camera`.

Agora precisamos adicionar:

```yaml
firebase_auth: ^6.1.0
```

No arquivo:

```text
exemplos/app_camera/app_camera/pubspec.yaml
```

Inclua a dependência:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  camera: ^0.12.0+1
  firebase_core: ^4.7.0
  firebase_storage: ^13.3.0
  firebase_auth: ^6.1.0
```

Depois execute:

```bash
flutter pub get
```

## Parte D — Autenticando o usuário no `main.dart`

Abra o arquivo:

```text
exemplos/app_camera/app_camera/lib/main.dart
```

### D1) Importar o Firebase Auth

No topo do arquivo, adicione:

```dart
import 'package:firebase_auth/firebase_auth.dart';
```

### D2) Criar uma função de login didático

Abaixo do `main`, crie uma função para autenticar o usuário de teste:

```dart
Future<UserCredential> _loginAsAdmin() {
  return FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'admin@teste.com.br',
    password: '123456',
  );
}
```

### D3) Chamar o login durante a inicialização

Altere o `main` para inicializar o Firebase e autenticar o usuário antes de abrir o app:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _loginAsAdmin();
  runApp(const MyApp());
}
```

### D4) Tratar erro de login

Uma versão um pouco melhor para laboratório é capturar erro e exibir no console:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await _loginAsAdmin();
  } on FirebaseAuthException catch (e) {
    debugPrint('Erro ao autenticar: ${e.code} - ${e.message}');
  }

  runApp(const MyApp());
}
```

> Pergunta para reflexão: se o login falhar e o app abrir mesmo assim, o upload deveria funcionar? Por quê?

## Parte E — Enviando fotos para a pasta do UID

Hoje o código envia a imagem para:

```dart
final storageRef = FirebaseStorage.instance.ref('images/$fileName');
```

A proposta é trocar a pasta fixa `images` pelo UID do usuário autenticado.

### E1) Obter o usuário autenticado

Dentro do método `_uploadToFirebase`, antes de criar o `storageRef`, obtenha o usuário atual:

```dart
final user = FirebaseAuth.instance.currentUser;

if (user == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Usuario nao autenticado.')),
  );
  return;
}
```

### E2) Montar o caminho usando o UID

Substitua o caminho antigo:

```dart
final storageRef = FirebaseStorage.instance.ref('images/$fileName');
```

Por:

```dart
final storageRef = FirebaseStorage.instance.ref('${user.uid}/$fileName');
```

Com isso, se o UID do usuário for:

```text
abc123
```

A imagem será salva em:

```text
abc123/1710000000000.jpg
```

### E3) Versão esperada do trecho de upload

O método `_uploadToFirebase` deverá ficar parecido com este trecho:

```dart
Future<void> _uploadToFirebase() async {
  if (imageFile == null) return;

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario nao autenticado.')),
    );
    return;
  }

  setState(() {
    _isUploading = true;
  });

  try {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref('${user.uid}/$fileName');

    await storageRef.putFile(
      File(imageFile!.path),
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final downloadUrl = await storageRef.getDownloadURL();

    if (!mounted) return;
    setState(() {
      uploadedImageUrl = downloadUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Upload concluido com sucesso!')),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Falha no upload: $e')),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
```

### Tarefa prática

Altere o código e execute o app. Depois:

1. Tire uma foto;
2. Faça upload;
3. Acesse o Firebase Console;
4. Abra o Storage;
5. Confirme que a foto apareceu dentro de uma pasta com o UID do usuário.

## Parte F — Ajustando as regras do Firebase Storage

Agora vamos proteger os arquivos.

No Firebase Console:

1. Acesse **Storage**;
2. Abra a aba **Rules**;
3. Substitua as regras por:

```text
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    match /{userId}/{allPaths=**} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

Clique em **Publish**.

### O que essa regra significa?

```text
match /{userId}/{allPaths=**}
```

Representa qualquer arquivo salvo dentro de uma pasta cujo primeiro nível é o `userId`.

Exemplo permitido:

```text
UID_DO_ADMIN/foto.jpg
```

Exemplo bloqueado para outro usuário:

```text
UID_DE_OUTRA_PESSOA/foto.jpg
```

A condição:

```text
request.auth != null && request.auth.uid == userId
```

exige que:

* exista um usuário autenticado;
* o UID autenticado seja igual ao nome da pasta acessada.

## Parte G — Testes obrigatórios

Realize os testes abaixo e registre evidências.

### G1) Upload autenticado

Com o login hardcoded funcionando:

* tire uma foto;
* faça upload;
* confirme que o arquivo foi salvo em `UID_DO_USUARIO/nome-do-arquivo.jpg`.

### G2) Upload sem autenticação

Para simular o app sem autenticação, altere temporariamente o `main` para sair da conta e não chamar o login:

```dart
await FirebaseAuth.instance.signOut();
// await _loginAsAdmin();
```

Execute o app novamente e tente fazer upload.

Resultado esperado:

* o app não deve conseguir enviar a foto;
* a mensagem de usuário não autenticado ou erro de permissão deve aparecer;
* nenhuma foto nova deve aparecer no Storage.

Depois do teste, volte o `main` para chamar:

```dart
await _loginAsAdmin();
```

### G3) Caminho antigo `images`

Troque temporariamente o caminho para:

```dart
final storageRef = FirebaseStorage.instance.ref('images/$fileName');
```

Tente fazer upload.

Resultado esperado:

* o upload deve falhar;
* as regras não permitem escrita em `images`, pois a pasta não corresponde ao UID autenticado.

Depois do teste, volte para:

```dart
final storageRef = FirebaseStorage.instance.ref('${user.uid}/$fileName');
```

## ✅ Entrega do Lab 07

Este laboratório não requer entrega de nenhum arquivo, print ou relatório ao professor.

Ele não vale nota. A proposta é praticar, experimentar e ganhar segurança com Firebase Authentication, Firebase Storage e regras de segurança.

Use a lista abaixo apenas como checklist pessoal:

* app rodando com Firebase configurado;
* usuário `admin@teste.com.br` criado no Authentication;
* foto salva no Storage dentro da pasta do UID;
* `main.dart` ajustado para autenticar e enviar para o caminho correto;
* testes G1, G2 e G3 realizados.

## 🧯 Troubleshooting rápido

### Erro: Firebase não inicializa

Verifique:

* se o arquivo `google-services.json` está em `android/app`;
* se o `applicationId` é o mesmo cadastrado no Firebase;
* se o plugin `com.google.gms.google-services` está no Gradle.

### Erro: usuário não encontrado

Verifique:

* se o provider Email/Password foi habilitado;
* se o usuário `admin@teste.com.br` foi criado;
* se a senha no código é exatamente a mesma senha cadastrada.

### Erro: permission-denied no upload

Verifique:

* se o login foi realizado antes do upload;
* se o caminho do Storage começa com `${user.uid}`;
* se as regras foram publicadas no Firebase Console.

### Upload funciona, mas cai em `images`

Revise esta linha:

```dart
final storageRef = FirebaseStorage.instance.ref('${user.uid}/$fileName');
```

Não deve restar nenhum uso de:

```dart
images/$fileName
```

## 🔜 Desafio complementar

Depois que o fluxo básico funcionar, evolua o app para:

* exibir na tela o e-mail e o UID do usuário autenticado;
* criar uma tela de login em vez de usar credenciais hardcoded;
* listar as fotos já enviadas pelo usuário;
* adicionar botão de logout.

---

**Lab 07 — TPDM / Mobile 2026**
