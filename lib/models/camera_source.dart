import 'package:camera/camera.dart';

enum CameraSourceType {
  physical, // Câmera física do dispositivo
  ip,       // Câmera IP (RTSP/HTTP)
}

class CameraSource {
  final String id;
  final String name;
  final CameraSourceType type;
  final String description;
  final CameraDescription? cameraDescription;
  final String? streamUrl;
  final bool isActive;

  CameraSource({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.cameraDescription,
    this.streamUrl,
    this.isActive = true,
  });

  CameraSource copyWith({
    String? id,
    String? name,
    CameraSourceType? type,
    String? description,
    CameraDescription? cameraDescription,
    String? streamUrl,
    bool? isActive,
  }) {
    return CameraSource(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      cameraDescription: cameraDescription ?? this.cameraDescription,
      streamUrl: streamUrl ?? this.streamUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'description': description,
      'streamUrl': streamUrl,
      'isActive': isActive,
    };
  }

  factory CameraSource.fromJson(Map<String, dynamic> json) {
    return CameraSource(
      id: json['id'],
      name: json['name'],
      type: json['type'] == 'CameraSourceType.physical'
          ? CameraSourceType.physical
          : CameraSourceType.ip,
      description: json['description'],
      streamUrl: json['streamUrl'],
      isActive: json['isActive'] ?? true,
    );
  }
}
