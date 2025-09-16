import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/app_theme.dart';

class TaskInputWidget extends StatefulWidget {
  const TaskInputWidget({Key? key}) : super(key: key);

  @override
  _TaskInputWidgetState createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  final _taskController = TextEditingController();
  TaskLabel? _selectedLabel;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.trim().isEmpty) {
      _showAlert('Please enter a task name');
      return;
    }
    
    if (_selectedLabel == null) {
      _showAlert('Please select a priority (Urgent or Important)');
      return;
    }
    
    context.read<TaskProvider>().addTask(_taskController.text, _selectedLabel!);
    _taskController.clear();
    setState(() {
      _selectedLabel = null;
    });
    FocusScope.of(context).unfocus();
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Information'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Task input field
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Add a new task...',
              prefixIcon: Icon(Icons.add_task, color: AppTheme.primaryColor),
            ),
            onSubmitted: (_) => _addTask(),
          ),
          
          const SizedBox(height: 16),
          
          // Consistent button row
          Row(
            children: [
              // Urgent button
              Expanded(
                child: _buildConsistentButton(
                  label: 'Urgent',
                  color: AppTheme.urgentColor,
                  isSelected: _selectedLabel == TaskLabel.urgent,
                  onTap: () => setState(() => _selectedLabel = TaskLabel.urgent),
                ),
              ),
              const SizedBox(width: 12),
              
              // Important button
              Expanded(
                child: _buildConsistentButton(
                  label: 'Important',
                  color: AppTheme.importantColor,
                  isSelected: _selectedLabel == TaskLabel.important,
                  onTap: () => setState(() => _selectedLabel = TaskLabel.important),
                ),
              ),
              const SizedBox(width: 12),
              
              // Add button
              Expanded(
                child: _buildConsistentButton(
                  label: 'Add',
                  color: AppTheme.primaryColor,
                  isSelected: true, // Always "selected" style for Add button
                  onTap: _addTask,
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsistentButton({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 48, // Consistent height
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isSelected ? Colors.white : color,
                  size: 18,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}