import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/camera_source.dart';

class CameraProvider with ChangeNotifier {
  List<CameraSource> _cameraSources = [];
  List<CameraController> _controllers = [];
  bool _isInitializing = false;
  String? _error;

  List<CameraSource> get cameraSources => _cameraSources;
  List<CameraController> get controllers => _controllers;
  bool get isInitializing => _isInitializing;
  String? get error => _error;

  /// Inicializa todas as câmeras disponíveis
  Future<void> initializeCameras() async {
    _isInitializing = true;
    _error = null;
    notifyListeners();

    try {
      // Solicitar permissões
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (!cameraStatus.isGranted || !micStatus.isGranted) {
        throw Exception('Permissões de câmera/microfone negadas');
      }

      // Listar câmeras físicas
      final cameras = await availableCameras();
      
      _cameraSources.clear();
      _controllers.clear();

      for (var i = 0; i < cameras.length; i++) {
        final camera = cameras[i];
        
        // Criar fonte de câmera
        final source = CameraSource(
          id: 'physical_$i',
          name: _getCameraName(camera),
          type: CameraSourceType.physical,
          description: camera.lensDirection.toString(),
          cameraDescription: camera,
        );

        _cameraSources.add(source);

        // Criar controller
        final controller = CameraController(
          camera,
          ResolutionPreset.high,
          enableAudio: true,
        );

        await controller.initialize();
        _controllers.add(controller);
      }

      // Adicionar slot para câmera IP
      _cameraSources.add(
        CameraSource(
          id: 'ip_slot',
          name: 'Adicionar Câmera IP',
          type: CameraSourceType.ip,
          description: 'RTSP/HTTP Stream',
        ),
      );

    } catch (e) {
      _error = e.toString();
      print('Erro ao inicializar câmeras: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Adiciona uma câmera IP
  Future<void> addIPCamera(String name, String url, String protocol) async {
    try {
      final source = CameraSource(
        id: 'ip_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        type: CameraSourceType.ip,
        description: protocol,
        streamUrl: url,
      );

      _cameraSources.insert(_cameraSources.length - 1, source);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Remove uma câmera IP
  void removeIPCamera(String id) {
    _cameraSources.removeWhere((source) => source.id == id);
    notifyListeners();
  }

  /// Obtém o nome amigável da câmera
  String _getCameraName(CameraDescription camera) {
    if (kIsWeb) {
      // Na web, usar o nome real do dispositivo
      return camera.name;
    } else {
      // No mobile, usar descrição da direção
      switch (camera.lensDirection) {
        case CameraLensDirection.front:
          return 'Câmera Frontal';
        case CameraLensDirection.back:
          return 'Câmera Traseira';
        case CameraLensDirection.external:
          return 'Câmera Externa';
        default:
          return 'Câmera ${camera.name}';
      }
    }
  }

  /// Captura frame de uma câmera específica
  Future<XFile?> captureFrame(int index) async {
    if (index >= _controllers.length) return null;
    
    try {
      final controller = _controllers[index];
      if (!controller.value.isInitialized) return null;
      
      return await controller.takePicture();
    } catch (e) {
      print('Erro ao capturar frame: $e');
      return null;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
