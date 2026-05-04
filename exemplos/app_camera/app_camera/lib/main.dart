import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: home ?? const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  XFile? imageFile;
  String? uploadedImageUrl;
  String? _cameraError;
  bool _isUploading = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _cameraError = 'Nenhuma camera encontrada neste dispositivo.';
        });
        return;
      }

      _controller = CameraController(cameras.first, ResolutionPreset.high);
      await _controller!.initialize();

      if (!mounted) return;
      setState(() {});
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Erro ao iniciar a camera: ${e.description ?? e.code}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Erro ao iniciar a camera: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      setState(() {
        imageFile = file;
        uploadedImageUrl = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao tirar foto: ${e.description ?? e.code}'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  Future<void> _uploadToFirebase() async {
    if (imageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref('images/$fileName');
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha no upload: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera App')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_cameraError!, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera App')),
      body: Column(
        children: [
          Expanded(
            child: imageFile == null
                ? CameraPreview(_controller!)
                : Image.file(File(imageFile!.path)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (imageFile == null)
                ElevatedButton(
                  onPressed: _isTakingPicture ? null : _takePicture,
                  child: _isTakingPicture
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Tirar Foto'),
                )
              else ...[
                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () => setState(() {
                          imageFile = null;
                          uploadedImageUrl = null;
                        }),
                  child: const Text('Tirar Outra'),
                ),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadToFirebase,
                  child: _isUploading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Upload'),
                ),
              ],
            ],
          ),
          if (uploadedImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                uploadedImageUrl!,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
