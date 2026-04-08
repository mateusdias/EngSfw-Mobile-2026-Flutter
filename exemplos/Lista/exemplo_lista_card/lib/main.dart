import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class SoccerTeam {
  final String name;
  final int foundationYear;

  SoccerTeam({required this.name, required this.foundationYear});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer Teams',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SoccerTeamList(),
    );
  }
}

class SoccerTeamList extends StatefulWidget {
  const SoccerTeamList({super.key});

  @override
  State<SoccerTeamList> createState() => _SoccerTeamListState();
}

class _SoccerTeamListState extends State<SoccerTeamList> {
  final List<SoccerTeam> _teams = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Times de Futebol'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _teams.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Center(
                child: Text(
                  'Nenhum time cadastrado ainda. Toque no botão + para adicionar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              ),
            )
          : ListView.builder(
              itemCount: _teams.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final team = _teams[index];
                return Dismissible(
                  key: ValueKey('${team.name}-${team.foundationYear}-$index'),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.archive, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    final removedTeam = team;
                    final removedIndex = index;

                    setState(() {
                      _teams.removeAt(index);
                    });

                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Time "${removedTeam.name}" removido.'),
                          duration: const Duration(seconds: 10),
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
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(team.name),
                      subtitle: Text('Fundado em ${team.foundationYear}'),
                      leading: const Icon(Icons.sports_soccer),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTeam,
        tooltip: 'Adicionar time',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SoccerTeamAdd extends StatefulWidget {
  const SoccerTeamAdd({super.key});

  @override
  State<SoccerTeamAdd> createState() => _SoccerTeamAddState();
}

class _SoccerTeamAddState extends State<SoccerTeamAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  void _saveTeam() {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text.trim();
      final int foundationYear = int.parse(_yearController.text.trim());

      final team = SoccerTeam(name: name, foundationYear: foundationYear);
      Navigator.pop(context, team);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do time.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Ano de fundação',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o ano de fundação.';
                  }
                  final year = int.tryParse(value);
                  if (year == null ||
                      year < 1850 ||
                      year > DateTime.now().year) {
                    return 'Informe um ano válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTeam,
                child: const Text('Salvar time'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
