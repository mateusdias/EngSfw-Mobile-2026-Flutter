# Lab 02 — Configurando o Flutter no Laboratório (Windows)

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração sugerida:** 2h/a

## 🎯 Objetivos do Lab

Ao final deste laboratório, o estudante deverá ser capaz de:

* Configurar o Flutter manualmente no Windows (sem instaladores automáticos);
* Criar e ajustar variáveis de ambiente (`PATH`) para usar o comando `flutter` em qualquer terminal;
* Validar o ambiente com `flutter doctor` e interpretar os principais avisos;
* Entender diferenças práticas entre Windows, macOS e Linux no desenvolvimento Flutter.

## ✅ Pré-requisitos

* Computador com Windows 10 ou 11;
* Permissão para instalar softwares no laboratório;
* Acesso à internet;
* Terminal disponível (Prompt de Comando ou PowerShell recomendado).

> 📌 Dica: mantenha aberto `referencias/links.md` para acesso rápido à documentação oficial.

## Parte A — Instalação manual do Flutter SDK no Windows — 35 a 50 min

### A1) Baixar o Flutter SDK (zip)

1. Acesse a documentação oficial: [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
2. Baixe o pacote `.zip` do Flutter SDK para Windows.

### A2) Extrair em pasta apropriada

1. Crie (se necessário) a pasta `C:\development` e depois `sdks`.
2. Extraia o zip para `C:\development\sdks\flutter`.

Estrutura esperada:

```txt
C:\development\sdks\flutter\bin
```

> Evite extrair em `C:\Program Files` para reduzir problemas de permissão.

## Parte B — Variáveis de ambiente no Windows — 30 a 40 min

### B1) Configurar `PATH` no sistema

1. Abra o menu iniciar e pesquise por: `variáveis de ambiente para a sua *CONTA*`.
2. Clique em **Editar as variáveis de ambiente do sistema**.
3. Abra **Variáveis de Ambiente...**.
4. Em **Variáveis do usuário** (ou do sistema), selecione `Path` e clique em **Editar**.
5. Adicione a entrada:

```txt
C:\dev\flutter\bin
```

6. Confirme com **OK** em todas as janelas.

### B2) Testar no terminal

Feche e abra o terminal novamente, depois execute:

```bash
flutter --version
where flutter
```

**Resultado esperado:**

* `flutter --version` retorna versão instalada;
* `where flutter` mostra caminho dentro de `C:\development\sdks\flutter`.

### B3) Corrigindo erro comum: `flutter` não reconhecido

Se aparecer mensagem como “comando não reconhecido”:

* Verifique se o caminho no `Path` está correto (`C:\development\sdks\flutter`);
* Feche e abra um novo terminal;
* Teste no PowerShell e no Prompt de Comando.

## Parte C — Validação do ambiente com `flutter doctor` — 25 a 35 min

No terminal:

```bash
flutter doctor
```

Analise os itens principais:

* `Flutter` (SDK instalado corretamente)
* `Android toolchain` (SDK Android e licenças - falaremos disso na próxima aula teórica)
* `Chrome` (opcional para Flutter Web)
* `Visual Studio` (necessário para build Windows desktop)
* `Android Studio` (opcional, mas recomendado)

### C1) Aceitar licenças Android (quando necessário)

```bash
flutter doctor --android-licenses
```

Depois rode novamente:

```bash
flutter doctor
```

## Parte D — Teste rápido de funcionamento — 20 a 30 min

### D1) Criar projeto de teste

```bash
flutter create hello_world
cd hello_world
```

### D2) Listar dispositivos disponíveis

```bash
flutter devices
```

### D3) Executar aplicação

Com emulador Android aberto (ou celular com depuração USB):

```bash
flutter run
```

## ✅ Entregável do Lab 02

Ao final, o estudante deve:

1. Ter o comando `flutter` disponível no terminal via `PATH`;
2. Ter executado `flutter doctor` e corrigido os principais avisos;
3. Ter criado e executado o projeto `lab_flutter_setup`.

## 🧯 Troubleshooting rápido

### Erro de permissão ao extrair/instalar

* Trocar para um diretório que você tenha permissões de leitura e escrita.
* Executar terminal como administrador apenas se necessário.

### `flutter doctor` aponta Android toolchain incompleto

* Instalar Android Studio;
* Instalar Android SDK + Command-line Tools;
* Rodar `flutter doctor --android-licenses`.

### `flutter run` não encontra dispositivo

* Abrir emulador antes do comando;
* Em celular Android, ativar `Depuração USB`.

## Diferenças entre ambientes (Windows, macOS e Linux)

Flutter é multiplataforma, mas o sistema operacional de desenvolvimento muda o que você consegue **compilar e testar localmente**:

* **Windows:** Android, Web e Windows Desktop; não compila app iOS localmente.
* **macOS:** Android, Web, macOS Desktop e **iOS** (com Xcode).
* **Linux:** Android, Web e Linux Desktop; não compila iOS localmente.

Resumo prático para a disciplina:

* Se o foco for Android/Web, Windows atende bem no laboratório;
* Para publicar e validar iOS, é necessário ambiente macOS com Xcode instalado completamente;
* Projetos Flutter podem ser compartilhados entre sistemas, mas cada plataforma exige seu toolchain local.

## Fechamento conceitual da aula prática

No laboratório prático o professor mostrou:

1. Tudo em Flutter é Widget;
2. Um Widget pode manter ou não estado, ou seja, pode ser um Stateless (sem controle de estado) ou Statefull (que prende o estado completo);
3. Dart e flutter usamos o paradigma declarativo;
4. O exemplo do hello world mostra que a classe MyApp é o próprio aplicativo (aprenderemos classes em dart muito em breve).
5. Um app Flutter possui páginas e essas páginas podem ser classes como mostra o próprio exemplo gerado automaticamente.

## Tarefa para a casa

Traduzir os comentários gerados automaticamente pelo exemplo de hello world para tentar entender um pouco mais a estrutura de um aplicativo em flutter. 

---

**Lab 02 — TPDM / Mobile 2026**
