import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../providers/camera_provider.dart';
import '../models/camera_source.dart';
import 'camera_view_card.dart';
import 'add_ip_camera_dialog.dart';

class CameraGrid extends StatelessWidget {
  final int columns;
  final Function(int)? onCameraSelected;

  const CameraGrid({
    super.key,
    required this.columns,
    this.onCameraSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, _) {
        if (cameraProvider.isInitializing) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 16),
                Text(
                  'Inicializando câmeras...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (cameraProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro ao inicializar câmeras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cameraProvider.error!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (cameraProvider.cameraSources.isEmpty) {
          return Center(
            child: Text(
              'Nenhuma câmera disponível',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 16 / 9,
          ),
          itemCount: cameraProvider.cameraSources.length,
          itemBuilder: (context, index) {
            final source = cameraProvider.cameraSources[index];
            
            // Slot para adicionar câmera IP
            if (source.type == CameraSourceType.ip && 
                source.id == 'ip_slot') {
              return _buildAddIPCameraCard(context);
            }

            // Câmera física
            if (source.type == CameraSourceType.physical) {
              final controller = cameraProvider.controllers[index];
              return CameraViewCard(
                source: source,
                controller: controller,
                onTap: () => onCameraSelected?.call(index),
              );
            }

            // Câmera IP
            return CameraViewCard(
              source: source,
              onTap: () => onCameraSelected?.call(index),
              onRemove: () {
                cameraProvider.removeIPCamera(source.id);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAddIPCameraCard(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const AddIPCameraDialog(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.3),
                    const Color(0xFF8B5CF6).withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Adicionar Câmera IP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'RTSP / HTTP',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
