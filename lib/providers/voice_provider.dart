import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceProvider with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isListening = false;
  bool _isSpeaking = false;
  String _lastWords = '';
  bool _isInitialized = false;

  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  String get lastWords => _lastWords;
  bool get isInitialized => _isInitialized;

  /// Inicializa os serviços de voz
  Future<void> initialize() async {
    try {
      // Solicitar permissão de microfone
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        throw Exception('Permissão de microfone negada');
      }

      // Inicializar Speech-to-Text
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Erro STT: $error'),
        onStatus: (status) => print('Status STT: $status'),
      );

      // Configurar Text-to-Speech
      await _flutterTts.setLanguage('pt-BR');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        print('Erro TTS: $msg');
        _isSpeaking = false;
        notifyListeners();
      });

      notifyListeners();
    } catch (e) {
      print('Erro ao inicializar voz: $e');
      _isInitialized = false;
      notifyListeners();
    }
  }

  /// Inicia a escuta de comandos de voz
  Future<void> startListening({
    required Function(String) onResult,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isListening) return;

    _isListening = true;
    notifyListeners();

    await _speechToText.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        notifyListeners();
        
        if (result.finalResult) {
          onResult(_lastWords);
          stopListening();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'pt_BR',
    );
  }

  /// Para a escuta
  Future<void> stopListening() async {
    if (!_isListening) return;

    await _speechToText.stop();
    _isListening = false;
    notifyListeners();
  }

  /// Fala um texto
  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    await _flutterTts.speak(text);
  }

  /// Para de falar
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  /// Processa comando de voz
  String? parseVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();

    // Comandos de análise
    if (lowerCommand.contains('analisar') || lowerCommand.contains('analise')) {
      if (lowerCommand.contains('porta')) {
        return 'analyze_door';
      } else if (lowerCommand.contains('entrada')) {
        return 'analyze_entrance';
      } else if (lowerCommand.contains('todas') || lowerCommand.contains('tudo')) {
        return 'analyze_all';
      } else {
        return 'analyze_current';
      }
    }

    // Comandos de câmera
    if (lowerCommand.contains('câmera') || lowerCommand.contains('camera')) {
      if (lowerCommand.contains('1') || lowerCommand.contains('um')) {
        return 'camera_1';
      } else if (lowerCommand.contains('2') || lowerCommand.contains('dois')) {
        return 'camera_2';
      } else if (lowerCommand.contains('3') || lowerCommand.contains('três')) {
        return 'camera_3';
      }
    }

    // Comandos de layout
    if (lowerCommand.contains('grade') || lowerCommand.contains('grid')) {
      if (lowerCommand.contains('2')) {
        return 'grid_2';
      } else if (lowerCommand.contains('3')) {
        return 'grid_3';
      } else if (lowerCommand.contains('4')) {
        return 'grid_4';
      }
    }

    return null;
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }
}
