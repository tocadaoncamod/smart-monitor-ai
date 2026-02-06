import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/camera_provider.dart';
import '../providers/ai_provider.dart';
import '../providers/voice_provider.dart';
import '../widgets/camera_grid.dart';
import '../widgets/control_panel.dart';
import '../widgets/ai_response_panel.dart';
import '../widgets/voice_control_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _gridColumns = 2;
  bool _showAIPanel = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final cameraProvider = context.read<CameraProvider>();
    final voiceProvider = context.read<VoiceProvider>();
    final aiProvider = context.read<AIProvider>();

    // Inicializar câmeras
    await cameraProvider.initializeCameras();

    // Inicializar voz
    await voiceProvider.initialize();

    // Inicializar IA (você deve substituir pela sua API Key)
    aiProvider.initializeGemini('AIzaSyDLaR3WJffeV8yDmHid6PsuCuobTy5VipgS_');
  }

  void _handleVoiceCommand(String command) {
    final voiceProvider = context.read<VoiceProvider>();
    final parsedCommand = voiceProvider.parseVoiceCommand(command);

    if (parsedCommand != null) {
      _executeCommand(parsedCommand);
    }
  }

  void _executeCommand(String command) {
    switch (command) {
      case 'analyze_all':
        _analyzeAllCameras();
        break;
      case 'analyze_current':
        _analyzeCurrentCamera();
        break;
      case 'grid_2':
        setState(() => _gridColumns = 2);
        break;
      case 'grid_3':
        setState(() => _gridColumns = 3);
        break;
      case 'grid_4':
        setState(() => _gridColumns = 4);
        break;
    }
  }

  Future<void> _analyzeAllCameras() async {
    final cameraProvider = context.read<CameraProvider>();
    final aiProvider = context.read<AIProvider>();
    final voiceProvider = context.read<VoiceProvider>();

    setState(() => _showAIPanel = true);

    final images = <String, Uint8List>{};

    for (var i = 0; i < cameraProvider.controllers.length; i++) {
      final frame = await cameraProvider.captureFrame(i);
      if (frame != null) {
        final bytes = await frame.readAsBytes();
        images[cameraProvider.cameraSources[i].name] = bytes;
      }
    }

    final results = await aiProvider.analyzeMultipleCameras(images);
    
    final summary = results.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n\n');

    await voiceProvider.speak('Análise concluída. $summary');
  }

  Future<void> _analyzeCurrentCamera() async {
    final cameraProvider = context.read<CameraProvider>();
    final aiProvider = context.read<AIProvider>();
    final voiceProvider = context.read<VoiceProvider>();

    if (cameraProvider.controllers.isEmpty) return;

    setState(() => _showAIPanel = true);

    final frame = await cameraProvider.captureFrame(0);
    if (frame == null) return;

    final bytes = await frame.readAsBytes();
    final response = await aiProvider.analyzeImage(
      imageBytes: bytes,
      cameraName: cameraProvider.cameraSources[0].name,
    );

    if (response != null) {
      await voiceProvider.speak(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
              const Color(0xFF334155),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Main Content
              Expanded(
                child: Row(
                  children: [
                    // Camera Grid
                    Expanded(
                      flex: 3,
                      child: CameraGrid(
                        columns: _gridColumns,
                        onCameraSelected: (index) {
                          // Implementar seleção de câmera
                        },
                      ),
                    ),
                    
                    // Side Panel
                    if (_showAIPanel)
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          border: Border(
                            left: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: const AIResponsePanel(),
                      ),
                  ],
                ),
              ),
              
              // Control Panel
              ControlPanel(
                gridColumns: _gridColumns,
                onGridColumnsChanged: (columns) {
                  setState(() => _gridColumns = columns);
                },
                onAnalyzeAll: _analyzeAllCameras,
                onToggleAIPanel: () {
                  setState(() => _showAIPanel = !_showAIPanel);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: VoiceControlButton(
        onVoiceCommand: _handleVoiceCommand,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1),
                  const Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Monitor AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Sistema de Monitoramento Inteligente',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer<VoiceProvider>(
            builder: (context, voice, _) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: voice.isListening
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: voice.isListening
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      voice.isListening
                          ? Icons.mic
                          : Icons.mic_none,
                      color: voice.isListening
                          ? Colors.red
                          : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      voice.isListening ? 'Ouvindo...' : 'Pronto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
