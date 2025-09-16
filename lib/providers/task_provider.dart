import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  // Dummy data for initial testing
  TaskProvider() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _tasks = [
      Task(
        id: '1',
        name: 'Complete Flutter project',
        label: TaskLabel.urgent,
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Task(
        id: '2',
        name: 'Review pull requests',
        label: TaskLabel.important,
        createdAt: DateTime.now().subtract(Duration(hours: 1)),
      ),
      Task(
        id: '3',
        name: 'Fix critical bug in production',
        label: TaskLabel.urgent,
        createdAt: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      Task(
        id: '4',
        name: 'Update documentation',
        label: TaskLabel.important,
        createdAt: DateTime.now().subtract(Duration(minutes: 15)),
      ),
    ];
    
    _completedTasks = [
      Task(
        id: '5',
        name: 'Design mockups',
        label: TaskLabel.important,
        isCompleted: true,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        completedAt: DateTime.now().subtract(Duration(hours: 3)),
      ),
    ];
  }

  List<Task> get tasks {
    // Sort tasks: Urgent first, then Important
    List<Task> sortedTasks = [..._tasks];
    sortedTasks.sort((a, b) {
      if (a.label == TaskLabel.urgent && b.label == TaskLabel.important) {
        return -1;
      } else if (a.label == TaskLabel.important && b.label == TaskLabel.urgent) {
        return 1;
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });
    return sortedTasks;
  }

  List<Task> get completedTasks => [..._completedTasks];

  int get activeTaskCount => _tasks.length;
  int get completedTaskCount => _completedTasks.length;

  void addTask(String name, TaskLabel label) {
    if (name.trim().isEmpty) return;

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      label: label,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);
    notifyListeners();
  }

  void completeTask(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    final completedTask = task.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    _tasks.removeAt(taskIndex);
    _completedTasks.insert(0, completedTask);
    notifyListeners();
  }

  void deleteTask(String taskId, {bool isCompleted = false}) {
    if (isCompleted) {
      _completedTasks.removeWhere((task) => task.id == taskId);
    } else {
      _tasks.removeWhere((task) => task.id == taskId);
    }
    notifyListeners();
  }

  void clearCompletedTasks() {
    _completedTasks.clear();
    notifyListeners();
  }

  void updateTask(String taskId, String newName, TaskLabel newLabel) {
  final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
  if (taskIndex == -1) return;

  final updatedTask = _tasks[taskIndex].copyWith(
    name: newName,
    label: newLabel,
  );

  _tasks[taskIndex] = updatedTask;
  notifyListeners();
}

void uncompleteTask(String taskId) {
  final taskIndex = _completedTasks.indexWhere((task) => task.id == taskId);
  if (taskIndex == -1) return;

  final task = _completedTasks[taskIndex];
  final activeTask = task.copyWith(
    isCompleted: false,
    completedAt: null,
  );

  _completedTasks.removeAt(taskIndex);
  _tasks.add(activeTask);
  notifyListeners();
}
}
