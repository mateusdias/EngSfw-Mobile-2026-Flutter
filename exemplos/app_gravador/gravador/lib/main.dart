// Usado para controlar o cronometro da gravacao.
// Timer (classe do pacote dart:async)
import 'dart:async';

// Usado para copiar o arquivo temporario 
// para uma pasta permanente do app.
import 'dart:io';

// Pacote responsavel por reproduzir 
// arquivos de audio.
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

// Pacote que descobre pastas do sistema, 
// como temporaria e documentos do app.
import 'package:path_provider/path_provider.dart';

// Pacote usado para solicitar permissao de microfone em tempo de execucao.
import 'package:permission_handler/permission_handler.dart';

// Pacote responsavel por capturar audio do microfone.
import 'package:record/record.dart';

// Ponto de entrada do aplicativo Flutter.
void main() {
  runApp(const GravadorApp());
}

// Widget raiz do app.
//
// Ele configura o MaterialApp, o tema visual e define qual sera a primeira
// tela exibida ao usuario.
class GravadorApp extends StatelessWidget {
  const GravadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gravador de Audio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const GravadorPage(),
    );
  }
}

// Tela principal do gravador.
//
// Ela precisa ser StatefulWidget 
// porque a interface 
// muda conforme o usuario
// grava, reproduz, salva ou inicia uma nova gravacao.
class GravadorPage extends StatefulWidget {
  const GravadorPage({super.key});

  @override
  State<GravadorPage> createState() => _GravadorPageState();
}

class _GravadorPageState extends State<GravadorPage> {
  // Objeto que conversa com o microfone e cria o arquivo de audio.
  AudioRecorder? _recorder;

  // Objeto que toca o arquivo de audio gravado.
  AudioPlayer? _player;

  // Timer usado para atualizar 
  // o contador de tempo da gravacao na tela.
  Timer? _timer;

  // Caminho do arquivo temporario
  // gerado ao parar a gravacao.
  String? _recordingPath;

  // Caminho do arquivo salvo de forma permanente na pasta de documentos do app.
  String? _savedPath;

  // Duracao exibida enquanto o usuario esta gravando.
  Duration _recordingDuration = Duration.zero;

  // Controla se o app esta capturando audio neste momento.
  bool _isRecording = false;

  // Controla se o app esta reproduzindo o audio gravado neste momento.
  bool _isPlaying = false;

  @override
  void dispose() {
    // Sempre liberamos recursos externos quando a tela sai da memoria.
    // Isso evita timer rodando em segundo plano e libera microfone/player.
    _timer?.cancel();
    _recorder?.dispose();
    _player?.dispose();
    super.dispose();
  }

  // Inicia uma nova gravacao.
  //
  // Fluxo:
  // 1. pede permissao do microfone;
  // 2. cria um caminho de arquivo temporario;
  // 3. inicia o gravador;
  // 4. liga o cronometro;
  // 5. atualiza o estado visual da tela.
  Future<void> _startRecording() async {
    
    // obtendo permissao do mic.
    final permission = await Permission.microphone.request();

    if (!permission.isGranted) {
      _showMessage('Permissao do microfone negada.');
      return;
    }

    // Se um audio estiver tocando, paramos antes de gravar outro.
    await _player?.stop();

    // getTemporaryDirectory cria um local ideal para arquivos que podem ser
    // substituidos depois, como a gravacao antes de clicar em "Salvar".
    final directory = await getTemporaryDirectory();
    final filePath =
        '${directory.path}/gravacao_${DateTime.now().millisecondsSinceEpoch}.m4a';

    // Criamos o AudioRecorder apenas uma vez 
    // e reaproveitamos nas proximas
    // gravacoes. 
    // O operador ??= so atribui se ainda estiver nulo.
    _recorder ??= AudioRecorder();
    
    await _recorder!.start(
      const RecordConfig(
        // AAC em arquivo .m4a funciona bem em Android e iOS.
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );

    // O pacote grava o audio, 
    // mas o cronometro da tela e responsabilidade do
    // nosso app. Por isso usamos um Timer separado.
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });

    setState(() {
      _isRecording = true;
      _isPlaying = false;
      _recordingPath = null;
      _savedPath = null;
      _recordingDuration = Duration.zero;
    });
  }

  // Para a gravacao atual.
  //
  // O metodo stop() devolve o caminho do arquivo 
  // criado pelo pacote record.
  // Guardamos esse caminho 
  // em _recordingPath para poder reproduzir ou salvar.
  Future<void> _stopRecording() async {
    final path = await _recorder?.stop();

    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _recordingPath = path;
    });

    if (path != null) {
      _showMessage('Gravacao pronta para reproduzir.');
    }
  }

  // Reproduz o arquivo gravado.
  //
  // DeviceFileSource informa ao audioplayers 
  // que a origem do audio e um
  // arquivo local do dispositivo, 
  // nao uma URL da internet ou asset do projeto.
  Future<void> _playRecording() async {
    final path = _recordingPath;
    if (path == null) return;

    _player ??= AudioPlayer();
    await _player!.stop();
    await _player!.play(DeviceFileSource(path));

    setState(() => _isPlaying = true);

    // Quando o audio terminar sozinho, 
    // atualizamos a tela para voltar o botao
    // para o estado "Reproduzir".
    _player!.onPlayerComplete.first.then((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  // Para a reproducao manualmente quando o usuario toca em "Parar reproducao".
  Future<void> _stopPlayback() async {
    await _player?.stop();
    setState(() => _isPlaying = false);
  }

  // Salva a gravacao atual em uma pasta permanente do aplicativo.
  //
  // A gravacao nasce na pasta temporaria. Ao salvar, copiamos o arquivo para
  // getApplicationDocumentsDirectory(), que e uma pasta privada e persistente.
  Future<void> _saveRecording() async {
    final path = _recordingPath;
    if (path == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final savedFile = File(
      '${directory.path}/audio_salvo_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    await File(path).copy(savedFile.path);

    setState(() => _savedPath = savedFile.path);
    _showMessage('Audio salvo no armazenamento do app.');
  }

  // Limpa a tela para permitir outra tentativa de gravacao.
  //
  // Se o usuario tocar em "Nova gravacao" enquanto ainda esta gravando,
  // cancelamos a captura atual e descartamos o arquivo parcial.
  Future<void> _newRecording() async {
    if (_isRecording) {
      await _recorder?.cancel();
    }

    await _player?.stop();
    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _isPlaying = false;
      _recordingPath = null;
      _savedPath = null;
      _recordingDuration = Duration.zero;
    });
  }

  // Exibe uma mensagem curta na parte inferior da tela.
  //
  // mounted garante que a tela ainda existe antes de usar o context.
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Converte Duration para o 
  // formato mm:ss, mais amigavel para exibir na tela.
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // Facilita a leitura das condicoes usadas pelos botoes.
    final hasRecording = _recordingPath != null;

    // Pega a paleta de cores do tema configurado no MaterialApp.
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gravador de Audio'),
        centerTitle: true,
        backgroundColor: colors.primaryContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Icon(
                // Durante a gravacao mostramos microfone em vermelho. Fora da
                // gravacao, mostramos um icone de audio na cor principal.
                _isRecording ? Icons.mic : Icons.graphic_eq,
                size: 96,
                color: _isRecording ? colors.error : colors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                // Texto principal muda conforme o estado atual da tela.
                _isRecording
                    ? 'Gravando...'
                    : hasRecording
                    ? 'Gravacao finalizada'
                    : 'Toque para iniciar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                // O cronometro mostra quanto tempo a gravacao atual durou.
                _formatDuration(_recordingDuration),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                // O mesmo botao inicia ou para a gravacao, dependendo do estado.
                onPressed: _isRecording ? _stopRecording : _startRecording,
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(_isRecording ? 'Parar gravacao' : 'Gravar audio'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                // O botao fica desabilitado ate existir uma gravacao.
                // Depois alterna entre reproduzir e parar a reproducao.
                onPressed: hasRecording
                    ? (_isPlaying ? _stopPlayback : _playRecording)
                    : null,
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? 'Parar reproducao' : 'Reproduzir'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                // Salvar so faz sentido depois que existe uma gravacao pronta.
                onPressed: hasRecording ? _saveRecording : null,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                // Nova gravacao fica disponivel quando ha algo para limpar ou
                // quando uma gravacao esta em andamento.
                onPressed: (_isRecording || hasRecording)
                    ? _newRecording
                    : null,
                icon: const Icon(Icons.refresh),
                label: const Text('Nova gravacao'),
              ),
              const Spacer(),
              if (_savedPath != null)
                // Mostra para fins didaticos onde o arquivo foi salvo.
                Text(
                  'Salvo em:\n$_savedPath',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
