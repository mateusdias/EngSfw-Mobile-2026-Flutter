# Aula 02 — Introdução ao Android Studio e preparação do ambiente Flutter

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração:** 2h/a

## 1. Objetivos da aula

Ao final desta aula, espera-se que o estudante:

* Entenda o papel do **Android Studio** no ecossistema Flutter;
* Saiba **baixar e instalar** o Android Studio;
* Configure corretamente o **Android SDK**;
* Instale os **Command-line Tools** necessários para integração com Flutter;
* Instale os plugins **Flutter** e **Dart**;
* Deixe o ambiente pronto para executar apps Flutter;
* Compreenda quando usar **Android Studio** e quando usar **VS Code**.

## 2. O que é o Android Studio no contexto Flutter?

O Android Studio é a IDE oficial para desenvolvimento Android e funciona muito bem com Flutter, principalmente porque já integra:

* Gerenciamento de SDK Android;
* Emuladores (AVD);
* Ferramentas de build e debug;
* Integração nativa com plugins Flutter e Dart.

Para Flutter, ele pode ser usado tanto como IDE principal quanto como suporte de emuladores e toolchain, mesmo quando o desenvolvimento é feito no VS Code.

## 3. Como baixar o Android Studio

Use sempre a fonte oficial:

* [https://developer.android.com/studio](https://developer.android.com/studio)

Selecione o instalador compatível com seu sistema operacional:

* **Windows:** `.exe`
* **macOS:** `.dmg`
* **Linux:** `.tar.gz`

> 📌 Dica: prefira versões estáveis e mantenha o Android Studio atualizado ao longo do semestre.

## 4. Como instalar o Android Studio

### 4.1 Windows

1. Execute o instalador `.exe`.
2. Mantenha os componentes padrão selecionados (Android Studio + Android Virtual Device).
3. Finalize a instalação e abra o Android Studio.
4. No primeiro assistente, escolha configuração padrão (*Standard*), se disponível.

### 4.2 macOS

1. Abra o arquivo `.dmg`.
2. Arraste o Android Studio para a pasta `Applications`.
3. Execute o Android Studio e conclua o assistente inicial.
4. Aceite instalação dos componentes sugeridos.

### 4.3 Linux

1. Extraia o arquivo `.tar.gz`.
2. Entre na pasta extraída e execute o script `bin/studio.sh`.
3. Conclua o assistente inicial com a instalação padrão.
4. Opcional: crie atalho/menu de aplicação durante o setup.

## 5. Como configurar o Android SDK

No Android Studio:

1. Abra **More Actions** → **SDK Manager** (ou **Settings** → **Android SDK**).
2. Em **SDK Platforms**, instale pelo menos uma versão recente do Android (API estável atual do laboratório).
3. Em **SDK Tools**, marque:
   * **Android SDK Build-Tools**
   * **Android SDK Platform-Tools**
   * **Android Emulator**
   * **Android SDK Command-line Tools (latest)**
4. Clique em **Apply** e aguarde concluir.

Após isso, valide no terminal:

```bash
flutter doctor
```

## 6. Como instalar Command-line Tools para funcionar com Flutter

Os Command-line Tools são essenciais para que o Flutter consiga interagir corretamente com o toolchain Android.

Passo a passo:

1. Android Studio → **SDK Manager** → aba **SDK Tools**.
2. Marque **Android SDK Command-line Tools (latest)**.
3. Clique em **Apply**.
4. No terminal, execute:

```bash
flutter doctor --android-licenses
```

5. Aceite todas as licenças e rode novamente:

```bash
flutter doctor
```

Meta: deixar o item **Android toolchain** sem erros bloqueantes.

## 7. Como instalar o plugin Flutter (e Dart)

No Android Studio:

1. Abra **Settings/Preferences** → **Plugins**.
2. Pesquise por **Flutter**.
3. Clique em **Install**.
4. O Android Studio solicitará também o plugin **Dart** (aceite).
5. Reinicie a IDE.

Validação:

* Ao criar projeto novo, a opção **Flutter** deve aparecer.

## 8. Como deixar o ambiente pronto no Android Studio

Checklist mínimo:

1. Flutter SDK instalado no sistema e comando `flutter` funcionando.
2. Android Studio com SDK + Command-line Tools instalados.
3. Plugins Flutter e Dart ativos.
4. Emulador Android criado:
   * **Device Manager** → **Create device** → selecionar modelo e imagem do sistema.
5. Teste final com projeto Flutter:

```bash
flutter create hello_flutter
cd hello_flutter
flutter devices
flutter run
```

Se o app abrir no emulador (ou no celular), o ambiente está pronto.

## 9. Android Studio vs VS Code: vantagens e quando usar

### 9.1 Vantagens do Android Studio

* Setup Android mais integrado (SDK, AVD, logs e profiler);
* Melhor suporte para debug Android profundo;
* Ferramentas visuais e de diagnóstico mais completas.

### 9.2 Vantagens do VS Code

* Mais leve e rápido para abrir projetos;
* Excelente para edição diária e produtividade;
* Boa integração com Flutter via extensões.

### 9.3 Qual usar na prática?

Use **Android Studio** quando:

* For configurar ambiente Android;
* Precisar de emulador, SDK Manager e diagnósticos detalhados;
* Quiser depuração mais completa da stack Android.

Use **VS Code** quando:

* Quiser fluxo mais leve para codar no dia a dia;
* Estiver com ambiente já configurado;
* Preferir uma IDE mais minimalista.

> Estratégia recomendada na disciplina: muitos alunos usam **VS Code para codar** e **Android Studio para SDK/emulador/ajustes Android**.

## 10. Troubleshooting rápido

### Erro: `flutter` não encontrado

* Flutter SDK não está no `PATH` do sistema.

### Erro no `Android toolchain` no `flutter doctor`

* Verificar se SDK Tools estão instaladas;
* Instalar/validar Command-line Tools;
* Executar `flutter doctor --android-licenses`.

### Emulador não inicia

* Conferir se o componente **Android Emulator** está instalado;
* Tentar imagem de sistema mais leve;
* Verificar virtualização de hardware habilitada na máquina.

## 11. Mensagem final ao estudante

Configurar ambiente é parte do trabalho de engenharia. Quanto mais organizado o setup no início do semestre, menos tempo perdido com erro de infraestrutura durante os labs e no Projeto Integrador.

## 12. Próximo passo

* Seguir para o próximo laboratório e iniciar prática com widgets, layout e execução contínua de apps Flutter, independentemente do IDE ou sistema operacional. 

---

**Aula 02 — TPDM / Mobile 2026**
