import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/camera_source.dart';
import '../models/analysis_record.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collections
  static const String _camerasCollection = 'cameras';
  static const String _analysesCollection = 'analyses';
  static const String _settingsCollection = 'settings';

  /// Salvar câmera IP no Firestore
  Future<void> saveCameraIP(CameraSource camera) async {
    try {
      await _firestore
          .collection(_camerasCollection)
          .doc(camera.id)
          .set(camera.toJson());
    } catch (e) {
      print('Erro ao salvar câmera: $e');
      rethrow;
    }
  }

  /// Carregar câmeras IP do Firestore
  Future<List<CameraSource>> loadCamerasIP() async {
    try {
      final snapshot = await _firestore
          .collection(_camerasCollection)
          .where('type', isEqualTo: 'CameraSourceType.ip')
          .get();

      return snapshot.docs
          .map((doc) => CameraSource.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Erro ao carregar câmeras: $e');
      return [];
    }
  }

  /// Deletar câmera IP
  Future<void> deleteCameraIP(String cameraId) async {
    try {
      await _firestore
          .collection(_camerasCollection)
          .doc(cameraId)
          .delete();
    } catch (e) {
      print('Erro ao deletar câmera: $e');
      rethrow;
    }
  }

  /// Salvar análise da IA
  Future<void> saveAnalysis(AnalysisRecord analysis) async {
    try {
      await _firestore
          .collection(_analysesCollection)
          .doc(analysis.id)
          .set(analysis.toJson());
    } catch (e) {
      print('Erro ao salvar análise: $e');
      rethrow;
    }
  }

  /// Carregar histórico de análises
  Future<List<AnalysisRecord>> loadAnalyses({
    int limit = 50,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection(_analysesCollection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => AnalysisRecord.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao carregar análises: $e');
      return [];
    }
  }

  /// Deletar análise
  Future<void> deleteAnalysis(String analysisId) async {
    try {
      await _firestore
          .collection(_analysesCollection)
          .doc(analysisId)
          .delete();
    } catch (e) {
      print('Erro ao deletar análise: $e');
      rethrow;
    }
  }

  /// Limpar histórico antigo (mais de X dias)
  Future<void> clearOldAnalyses({int daysToKeep = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      final snapshot = await _firestore
          .collection(_analysesCollection)
          .where('timestamp', isLessThan: cutoffDate)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Erro ao limpar análises antigas: $e');
      rethrow;
    }
  }

  /// Salvar configurações localmente (SharedPreferences)
  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', apiKey);
  }

  /// Carregar API Key
  Future<String?> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('gemini_api_key');
  }

  /// Salvar configuração de grid
  Future<void> saveGridColumns(int columns) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('grid_columns', columns);
  }

  /// Carregar configuração de grid
  Future<int> loadGridColumns() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('grid_columns') ?? 2;
  }

  /// Estatísticas de uso
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final analysesSnapshot = await _firestore
          .collection(_analysesCollection)
          .get();

      final camerasSnapshot = await _firestore
          .collection(_camerasCollection)
          .get();

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      final todayAnalyses = await _firestore
          .collection(_analysesCollection)
          .where('timestamp', isGreaterThanOrEqualTo: todayStart)
          .get();

      return {
        'totalAnalyses': analysesSnapshot.size,
        'totalCameras': camerasSnapshot.size,
        'todayAnalyses': todayAnalyses.size,
        'lastUpdate': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Erro ao obter estatísticas: $e');
      return {};
    }
  }
}
