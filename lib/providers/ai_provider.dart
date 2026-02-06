import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

class AIProvider with ChangeNotifier {
  GenerativeModel? _model;
  bool _isProcessing = false;
  String? _lastResponse;
  String? _error;

  bool get isProcessing => _isProcessing;
  String? get lastResponse => _lastResponse;
  String? get error => _error;

  /// Inicializa o modelo Gemini
  void initializeGemini(String apiKey) {
    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao inicializar Gemini: $e';
      notifyListeners();
    }
  }

  /// Analisa uma imagem com contexto textual
  Future<String?> analyzeImage({
    required Uint8List imageBytes,
    String? prompt,
    String? cameraName,
  }) async {
    if (_model == null) {
      _error = 'Modelo Gemini não inicializado';
      notifyListeners();
      return null;
    }

    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      final imagePart = DataPart('image/jpeg', imageBytes);
      
      final contextPrompt = prompt ?? '''
Você é um assistente de segurança inteligente analisando imagens de câmeras de monitoramento.
${cameraName != null ? 'Esta imagem vem da câmera: $cameraName' : ''}

Analise a imagem e forneça:
1. Descrição geral da cena
2. Pessoas detectadas (quantidade, atividades)
3. Objetos importantes identificados
4. Possíveis alertas de segurança
5. Recomendações (se aplicável)

Seja conciso e objetivo.
''';

      final content = [
        Content.multi([
          TextPart(contextPrompt),
          imagePart,
        ])
      ];

      final response = await _model!.generateContent(content);
      _lastResponse = response.text;
      
      return _lastResponse;
    } catch (e) {
      _error = 'Erro ao analisar imagem: $e';
      print(_error);
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Processa comando de texto
  Future<String?> processTextCommand(String command) async {
    if (_model == null) {
      _error = 'Modelo Gemini não inicializado';
      notifyListeners();
      return null;
    }

    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      final content = [Content.text(command)];
      final response = await _model!.generateContent(content);
      _lastResponse = response.text;
      
      return _lastResponse;
    } catch (e) {
      _error = 'Erro ao processar comando: $e';
      print(_error);
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Analisa múltiplas câmeras simultaneamente
  Future<Map<String, String>> analyzeMultipleCameras(
    Map<String, Uint8List> cameraImages,
  ) async {
    final results = <String, String>{};

    for (final entry in cameraImages.entries) {
      final response = await analyzeImage(
        imageBytes: entry.value,
        cameraName: entry.key,
      );
      
      if (response != null) {
        results[entry.key] = response;
      }
    }

    return results;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
