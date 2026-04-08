# Aula 06 — Listas com `ListView`, `Card`, `Dismissible` e navegação com retorno

📘 **Disciplina:** Tecnologia e Programação para Dispositivos Móveis (TPDM) \
🎓 **Curso:** Engenharia de Software — PUC-Campinas \
👨‍🏫 **Professor:** Prof. Me. Mateus Dias \
⏱️ **Duração:** 2h/a

## 1. Objetivos da aula

Ao final desta aula, espera-se que o estudante:

* Entenda como exibir coleções de dados com **`ListView.builder`**;
* Compreenda o uso de **`Card`** para organização visual dos itens;
* Entenda como remover elementos com **`Dismissible`**;
* Veja como navegar entre telas com **`Navigator.push`** e **`Navigator.pop`**;
* Compreenda o papel do **`Future`** no retorno de dados da tela de cadastro;
* Relacione atualização de interface com **`setState`**.

## 2. Contexto do exemplo

Nesta aula, vamos estudar o projeto:

* `exemplos/Lista/exemplo_lista_card`

O aplicativo permite:

* cadastrar times de futebol;
* listar os times na tela principal;
* remover um time com gesto de arrastar;
* desfazer a remoção com `SnackBar`.

Esse exemplo é muito útil porque reúne conceitos importantes de interface e navegação em Flutter em um único fluxo.

## 3. Estrutura geral do aplicativo

O arquivo principal define três partes importantes:

* a classe `SoccerTeam`, que representa o modelo de dados;
* a tela `SoccerTeamList`, que mostra a lista de times;
* a tela `SoccerTeamAdd`, responsável pelo cadastro de um novo time.

Trecho do modelo:

```dart
class SoccerTeam {
  final String name;
  final int foundationYear;

  SoccerTeam({required this.name, required this.foundationYear});
}
```

Aqui temos um objeto simples para guardar os dados que serão exibidos na lista.

## 4. Estado da lista e atualização da interface

Na tela principal, os times cadastrados ficam armazenados em uma lista:

```dart
final List<SoccerTeam> _teams = [];
```

Conceitos importantes:

* `_teams` guarda os dados exibidos na interface;
* o `_` indica que o atributo é privado ao arquivo;
* quando a lista muda, é necessário chamar `setState(...)` para reconstruir a interface.

Exemplo:

```dart
setState(() {
  _teams.add(newTeam);
});
```

Sem o `setState`, o dado até pode ser alterado em memória, mas a tela não será atualizada automaticamente.

## 5. Exibição de listas com `ListView.builder`

Quando existem times cadastrados, a tela usa:

```dart
ListView.builder(
  itemCount: _teams.length,
  padding: const EdgeInsets.all(12),
  itemBuilder: (context, index) {
    final team = _teams[index];
    ...
  },
)
```

Pontos principais sobre `ListView.builder`:

* é indicado para listas dinâmicas;
* constrói os itens sob demanda;
* evita criar todos os widgets de uma vez;
* usa `itemCount` para saber quantos elementos existem;
* usa `itemBuilder` para montar cada item conforme o índice.

Esse padrão é melhor do que criar manualmente vários widgets quando a quantidade de elementos pode variar.

## 6. O que aparece quando a lista está vazia

Antes de mostrar a `ListView`, o código verifica se a lista está vazia:

```dart
body: _teams.isEmpty
    ? const Padding(
        child: Center(
          child: Text('Nenhum time cadastrado ainda...'),
        ),
      )
    : ListView.builder(...)
```

Esse uso do operador ternário permite dois comportamentos:

* se `_teams.isEmpty` for verdadeiro, a interface mostra uma mensagem;
* caso contrário, exibe a lista de times.

Esse cuidado melhora bastante a experiência do usuário, pois evita uma tela vazia sem contexto.

## 7. Organização visual de cada item com `Card`

Cada time é exibido dentro de um `Card`:

```dart
Card(
  margin: const EdgeInsets.symmetric(vertical: 8),
  child: ListTile(
    title: Text(team.name),
    subtitle: Text('Fundado em ${team.foundationYear}'),
    leading: const Icon(Icons.sports_soccer),
  ),
)
```

Função do `Card`:

* destacar visualmente cada item;
* criar separação entre os elementos da lista;
* deixar a interface com aparência mais organizada e legível.

No exemplo, o `Card` encapsula um `ListTile`, que já oferece uma estrutura pronta com:

* `leading`: ícone à esquerda;
* `title`: texto principal;
* `subtitle`: texto secundário.

Essa combinação é muito comum em listas no Flutter.

## 8. Remoção com gesto usando `Dismissible`

Cada item da lista é envolvido por um `Dismissible`:

```dart
Dismissible(
  key: ValueKey('${team.name}-${team.foundationYear}-$index'),
  direction: DismissDirection.startToEnd,
  background: Container(
    color: Colors.green,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.archive, color: Colors.white),
  ),
  onDismissed: (direction) {
    ...
  },
  child: Card(...),
)
```

Papel do `Dismissible`:

* permite remover um item arrastando-o horizontalmente;
* associa uma ação visual ao gesto de deslizar;
* facilita interações modernas em listas.

Conceitos importantes:

* `key` identifica unicamente o item;
* `direction` limita a direção do gesto;
* `background` define o fundo exibido durante o arraste;
* `onDismissed` executa a lógica após a remoção.

O uso de chave é importante porque o Flutter precisa distinguir corretamente cada item quando a lista muda.

## 9. Removendo e desfazendo com `SnackBar`

Quando o usuário desliza um item, o código remove o time da lista:

```dart
setState(() {
  _teams.removeAt(index);
});
```

Em seguida, exibe uma `SnackBar` com ação de desfazer:

```dart
ScaffoldMessenger.of(context)
  ..clearSnackBars()
  ..showSnackBar(
    SnackBar(
      content: Text('Time "${removedTeam.name}" removido.'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            _teams.insert(removedIndex, removedTeam);
          });
        },
      ),
    ),
  );
```

Aqui vemos um fluxo interessante:

* o item é removido da lista;
* a interface é reconstruída;
* o usuário recebe feedback visual;
* existe a possibilidade de restaurar o item na posição original.

Esse é um bom exemplo de interação amigável e tolerante a erro.

## 10. Navegação para a tela de cadastro

O botão flutuante chama o método:

```dart
onPressed: _navigateToAddTeam,
```

Esse método faz a navegação para a segunda tela:

```dart
Future<void> _navigateToAddTeam() async {
  final SoccerTeam? newTeam = await Navigator.push<SoccerTeam>(
    context,
    MaterialPageRoute(builder: (context) => const SoccerTeamAdd()),
  );

  if (newTeam != null) {
    setState(() {
      _teams.add(newTeam);
    });
  }
}
```

## 11. Como funciona o `Future` do método de navegação

Esse é um dos pontos mais importantes do exemplo.

Quando usamos:

```dart
Navigator.push<SoccerTeam>(...)
```

o Flutter empilha uma nova tela na navegação e devolve um **`Future<SoccerTeam?>`**.

Interpretação correta:

* `push` não retorna imediatamente um time;
* ele retorna uma promessa de valor futuro;
* esse valor só chega quando a tela aberta for encerrada com `Navigator.pop(...)`;
* o tipo `SoccerTeam?` indica que o retorno pode ser um objeto `SoccerTeam` ou `null`.

Por isso o método foi declarado como assíncrono:

```dart
Future<void> _navigateToAddTeam() async
```

E por isso usamos:

```dart
final SoccerTeam? newTeam = await Navigator.push<SoccerTeam>(...);
```

O `await` pausa a execução desse método até a tela de cadastro ser fechada.

Depois que a navegação termina:

* se o usuário salvou um time, `newTeam` recebe o objeto criado;
* se o usuário apenas voltou sem salvar, `newTeam` será `null`.

## 12. Retornando dados da tela de cadastro com `Navigator.pop`

Na tela `SoccerTeamAdd`, quando o formulário é válido, o código cria um objeto e o devolve:

```dart
final team = SoccerTeam(name: name, foundationYear: foundationYear);
Navigator.pop(context, team);
```

Esse trecho faz duas coisas ao mesmo tempo:

* fecha a tela atual;
* envia um valor de volta para a tela anterior.

Ou seja:

* `Navigator.push(...)` abre a tela e espera um resultado;
* `Navigator.pop(context, team)` fecha a tela e entrega esse resultado.

Esse padrão é extremamente comum em formulários, telas de seleção e cadastros.

## 13. Validação antes de retornar o objeto

O botão de salvar chama:

```dart
void _saveTeam() {
  if (_formKey.currentState?.validate() ?? false) {
    final String name = _nameController.text.trim();
    final int foundationYear = int.parse(_yearController.text.trim());

    final team = SoccerTeam(name: name, foundationYear: foundationYear);
    Navigator.pop(context, team);
  }
}
```

Conceitos importantes:

* o retorno só acontece se o formulário for válido;
* `trim()` remove espaços extras;
* `int.parse(...)` converte o ano digitado para inteiro;
* o objeto retornado é usado pela tela anterior para atualizar a lista.

Assim, a navegação não serve apenas para trocar de tela, mas também para transportar dados entre telas.

## 14. Fechamento da aula

Com este exemplo, você praticou um fluxo muito comum em aplicativos Flutter:

* exibir dados com `ListView.builder`;
* organizar visualmente cada item com `Card`;
* remover elementos com `Dismissible`;
* navegar para outra tela com `Navigator.push`;
* receber dados de volta com `Future` e `await`;
* atualizar a interface com `setState`.

Esse conjunto de conceitos forma uma base importante para aplicações com cadastro, listagem e manipulação de dados em memória.
