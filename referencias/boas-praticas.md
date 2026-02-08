# Boas Práticas — Desenvolvimento Mobile com Flutter

Este documento reúne **boas práticas adotadas ao longo da disciplina** e serve como referência para organização, escrita de código e evolução dos projetos em Flutter.

> 📌 **Importante:** estas boas práticas não são regras absolutas. Elas representam **diretrizes recomendadas**, alinhadas com o que será cobrado e observado ao longo do semestre.

---

## 🧠 Mentalidade de Desenvolvimento

* Priorize **clareza** antes de complexidade.
* Faça o aplicativo **funcionar primeiro**, depois melhore.
* Evite copiar código sem compreender o que ele faz.
* Erros fazem parte do processo — investigue, leia mensagens de erro e teste hipóteses.

---

## 📁 Organização de Projeto Flutter

* Mantenha a estrutura de pastas organizada e consistente.
* Separe **UI**, **lógica** e **dados** sempre que possível.
* Evite arquivos muito grandes ("God files").
* Use nomes de arquivos e pastas **claros e autoexplicativos**.

Exemplo de organização inicial:

```text
lib/
├── main.dart
├── pages/
├── widgets/
├── services/
└── models/
```

---

## 🧩 Widgets e Interface

* Prefira **widgets pequenos e reutilizáveis**.
* Evite lógica de negócio diretamente dentro de widgets de UI.
* Use `const` sempre que possível para melhorar performance.
* Utilize `StatelessWidget` sempre que não houver estado.

---

## 🔁 Estado e Lógica

* Mantenha o estado o mais **local possível**.
* Comece com gerenciamento de estado simples.
* Evite soluções complexas de estado sem necessidade.
* Compreenda bem o ciclo de vida de widgets antes de abstrair.

---

## 🌐 Consumo de APIs e Dados

* Trate erros de requisição (timeout, erro de rede, status HTTP).
* Nunca assuma que a API sempre responderá corretamente.
* Separe a lógica de acesso a dados em **services**.
* Utilize modelos para representar dados (models).

---

## ☁️ Firebase e Persistência

* Nunca exponha chaves sensíveis em repositórios públicos.
* Organize regras de segurança com cuidado.
* Valide dados antes de salvar no banco.
* Pense em estrutura de dados antes de implementar.

---

## 🧪 Testes e Debug

* Use `print` e logs de forma consciente durante o desenvolvimento.
* Aprenda a usar o **Debugger** da IDE.
* Teste fluxos principais do aplicativo.
* Corrija erros pequenos antes que eles se acumulem.

---

## 🔧 Git e Versionamento

* Faça commits pequenos e frequentes.
* Escreva mensagens de commit claras.
* Não versionar arquivos gerados automaticamente.
* Utilize o repositório individual para suas entregas.

Exemplo de mensagem de commit:

```
feat: adiciona tela inicial com navegação básica
```

---

## 🎓 Postura Acadêmica e Profissional

* Respeite prazos e orientações da disciplina.
* Trabalhe em equipe de forma colaborativa.
* Documente decisões importantes do projeto.
* Busque ajuda quando estiver bloqueado.

---

## 📌 Observação Final

Estas boas práticas serão **reforçadas continuamente** ao longo das aulas, exemplos, laboratórios e projetos.

O objetivo é formar não apenas desenvolvedores que fazem aplicativos funcionarem, mas **engenheiros capazes de evoluir e manter sistemas**.

---

**Boas Práticas — Flutter 2026**
