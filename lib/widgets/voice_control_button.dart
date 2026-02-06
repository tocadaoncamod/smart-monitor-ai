import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_provider.dart';

class VoiceControlButton extends StatelessWidget {
  final Function(String) onVoiceCommand;

  const VoiceControlButton({
    super.key,
    required this.onVoiceCommand,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, _) {
        return GestureDetector(
          onTap: () {
            if (voiceProvider.isListening) {
              voiceProvider.stopListening();
            } else {
              voiceProvider.startListening(
                onResult: (command) {
                  onVoiceCommand(command);
                },
              );
            }
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: voiceProvider.isListening
                    ? [
                        Colors.red,
                        Colors.red.shade700,
                      ]
                    : [
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                      ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: voiceProvider.isListening
                      ? Colors.red.withOpacity(0.5)
                      : const Color(0xFF6366F1).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulsing animation when listening
                if (voiceProvider.isListening)
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, double value, child) {
                      return Container(
                        width: 70 + (value * 20),
                        height: 70 + (value * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red.withOpacity(1 - value),
                            width: 2,
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      // Restart animation
                      if (voiceProvider.isListening) {
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                
                // Icon
                Icon(
                  voiceProvider.isListening
                      ? Icons.mic
                      : Icons.mic_none,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
