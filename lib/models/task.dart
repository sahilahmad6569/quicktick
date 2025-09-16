import 'package:flutter/material.dart';

enum TaskLabel { urgent, important }

class Task {
  final String id;
  final String name;
  final TaskLabel label;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.name,
    required this.label,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? name,
    TaskLabel? label,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  String get labelText {
    return label == TaskLabel.urgent ? 'Urgent' : 'Important';
  }

  Color get labelColor {
    return label == TaskLabel.urgent ? Colors.red : Colors.blue;
  }
}
