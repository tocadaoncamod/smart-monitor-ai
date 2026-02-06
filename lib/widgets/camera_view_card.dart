import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/camera_source.dart';

class CameraViewCard extends StatelessWidget {
  final CameraSource source;
  final CameraController? controller;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const CameraViewCard({
    super.key,
    required this.source,
    this.controller,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview
              _buildCameraPreview(),
              
              // Overlay Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Camera Info Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(),
              ),
              
              // Camera Info Footer
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildFooter(),
              ),
              
              // Remove Button (for IP cameras)
              if (source.type == CameraSourceType.ip && onRemove != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: onRemove,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (source.type == CameraSourceType.physical && controller != null) {
      if (!controller!.value.isInitialized) {
        return Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF6366F1),
          ),
        );
      }
      return CameraPreview(controller!);
    }

    if (source.type == CameraSourceType.ip && source.streamUrl != null) {
      // Aqui você implementaria o player de stream RTSP/HTTP
      // Por exemplo, usando flutter_vlc_player ou similar
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              color: Colors.white.withOpacity(0.3),
              size: 64,
            ),
            const SizedBox(height: 8),
            Text(
              'Stream IP',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Icon(
        Icons.videocam_off,
        color: Colors.white.withOpacity(0.3),
        size: 64,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1),
                  const Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  source.type == CameraSourceType.physical
                      ? Icons.camera_alt
                      : Icons.wifi,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  source.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'AO VIVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white.withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            source.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
          const Spacer(),
          Text(
            DateTime.now().toString().substring(11, 19),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
