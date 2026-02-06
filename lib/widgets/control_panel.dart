import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final int gridColumns;
  final Function(int) onGridColumnsChanged;
  final VoidCallback onAnalyzeAll;
  final VoidCallback onToggleAIPanel;

  const ControlPanel({
    super.key,
    required this.gridColumns,
    required this.onGridColumnsChanged,
    required this.onAnalyzeAll,
    required this.onToggleAIPanel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Grid Layout Controls
          Text(
            'Layout:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          ...List.generate(4, (index) {
            final columns = index + 1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildGridButton(
                columns: columns,
                isSelected: gridColumns == columns,
                onTap: () => onGridColumnsChanged(columns),
              ),
            );
          }),
          
          const SizedBox(width: 24),
          
          // Analyze Button
          ElevatedButton.icon(
            onPressed: onAnalyzeAll,
            icon: Icon(Icons.analytics),
            label: Text('Analisar Todas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // AI Panel Toggle
          ElevatedButton.icon(
            onPressed: onToggleAIPanel,
            icon: Icon(Icons.smart_toy),
            label: Text('Painel IA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Status Indicators
          _buildStatusIndicator(
            icon: Icons.wifi,
            label: 'Conectado',
            color: Colors.green,
          ),
          const SizedBox(width: 16),
          _buildStatusIndicator(
            icon: Icons.memory,
            label: 'IA Ativa',
            color: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton({
    required int columns,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '${columns}x${columns}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
