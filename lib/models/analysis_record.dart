import 'package:uuid/uuid.dart';

class AnalysisRecord {
  final String id;
  final String cameraId;
  final String cameraName;
  final String analysis;
  final DateTime timestamp;
  final List<String> detectedObjects;
  final List<String> alerts;
  final int peopleCount;
  final String? imageUrl;

  AnalysisRecord({
    String? id,
    required this.cameraId,
    required this.cameraName,
    required this.analysis,
    DateTime? timestamp,
    this.detectedObjects = const [],
    this.alerts = const [],
    this.peopleCount = 0,
    this.imageUrl,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cameraId': cameraId,
      'cameraName': cameraName,
      'analysis': analysis,
      'timestamp': timestamp.toIso8601String(),
      'detectedObjects': detectedObjects,
      'alerts': alerts,
      'peopleCount': peopleCount,
      'imageUrl': imageUrl,
    };
  }

  factory AnalysisRecord.fromJson(Map<String, dynamic> json) {
    return AnalysisRecord(
      id: json['id'],
      cameraId: json['cameraId'],
      cameraName: json['cameraName'],
      analysis: json['analysis'],
      timestamp: DateTime.parse(json['timestamp']),
      detectedObjects: List<String>.from(json['detectedObjects'] ?? []),
      alerts: List<String>.from(json['alerts'] ?? []),
      peopleCount: json['peopleCount'] ?? 0,
      imageUrl: json['imageUrl'],
    );
  }

  AnalysisRecord copyWith({
    String? id,
    String? cameraId,
    String? cameraName,
    String? analysis,
    DateTime? timestamp,
    List<String>? detectedObjects,
    List<String>? alerts,
    int? peopleCount,
    String? imageUrl,
  }) {
    return AnalysisRecord(
      id: id ?? this.id,
      cameraId: cameraId ?? this.cameraId,
      cameraName: cameraName ?? this.cameraName,
      analysis: analysis ?? this.analysis,
      timestamp: timestamp ?? this.timestamp,
      detectedObjects: detectedObjects ?? this.detectedObjects,
      alerts: alerts ?? this.alerts,
      peopleCount: peopleCount ?? this.peopleCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
