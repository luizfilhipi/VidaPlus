import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/habit_entity.dart';

class HabitModel {
  final String? id;
  final String userId;
  final String name;
  final HabitType type;
  final HabitFrequency frequency;
  final TimeOfDay? recommendedTime;
  final int? targetValue;
  final int? currentValue;
  final bool isCompleted;
  final DateTime? lastCompletedDate;
  final String? notes;
  final DateTime createdAt;

  HabitModel({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.frequency,
    this.recommendedTime,
    this.targetValue,
    this.currentValue,
    required this.isCompleted,
    this.lastCompletedDate,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'type': type.toString(),
      'frequency': frequency.toString(),
      'recommendedTime': recommendedTime != null
          ? {'hour': recommendedTime!.hour, 'minute': recommendedTime!.minute}
          : null,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isCompleted': isCompleted,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    TimeOfDay? recommendedTime;
    if (map['recommendedTime'] != null) {
      final timeMap = map['recommendedTime'] as Map<String, dynamic>;
      recommendedTime = TimeOfDay(
        hour: timeMap['hour'] as int,
        minute: timeMap['minute'] as int,
      );
    }

    return HabitModel(
      id: map['id'] as String?,
      userId: map['userId'] as String,
      name: map['name'] as String,
      type: HabitType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => HabitType.binary,
      ),
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.toString() == map['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      recommendedTime: recommendedTime,
      targetValue: map['targetValue'] as int?,
      currentValue: map['currentValue'] as int?,
      isCompleted: map['isCompleted'] as bool? ?? false,
      lastCompletedDate: map['lastCompletedDate'] != null
          ? (map['lastCompletedDate'] is Timestamp
              ? (map['lastCompletedDate'] as Timestamp).toDate()
              : DateTime.parse(map['lastCompletedDate']))
          : null,
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'type': type.toString(),
      'frequency': frequency.toString(),
      'recommendedTime': recommendedTime != null
          ? {'hour': recommendedTime!.hour, 'minute': recommendedTime!.minute}
          : null,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isCompleted': isCompleted,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    TimeOfDay? recommendedTime;
    if (data['recommendedTime'] != null) {
      final timeMap = data['recommendedTime'] as Map<String, dynamic>;
      recommendedTime = TimeOfDay(
        hour: timeMap['hour'] as int,
        minute: timeMap['minute'] as int,
      );
    }

    return HabitModel(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      type: HabitType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => HabitType.binary,
      ),
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.toString() == data['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      recommendedTime: recommendedTime,
      targetValue: data['targetValue'] as int?,
      currentValue: data['currentValue'] as int?,
      isCompleted: data['isCompleted'] as bool? ?? false,
      lastCompletedDate: data['lastCompletedDate'] != null
          ? (data['lastCompletedDate'] is Timestamp
              ? (data['lastCompletedDate'] as Timestamp).toDate()
              : DateTime.parse(data['lastCompletedDate']))
          : null,
      notes: data['notes'] as String?,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      type: entity.type,
      frequency: entity.frequency,
      recommendedTime: entity.recommendedTime,
      targetValue: entity.targetValue,
      currentValue: entity.currentValue,
      isCompleted: entity.isCompleted,
      lastCompletedDate: entity.lastCompletedDate,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      userId: userId,
      name: name,
      type: type,
      frequency: frequency,
      recommendedTime: recommendedTime,
      targetValue: targetValue,
      currentValue: currentValue,
      isCompleted: isCompleted,
      lastCompletedDate: lastCompletedDate,
      notes: notes,
      createdAt: createdAt,
    );
  }

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    HabitType? type,
    HabitFrequency? frequency,
    TimeOfDay? recommendedTime,
    int? targetValue,
    int? currentValue,
    bool? isCompleted,
    DateTime? lastCompletedDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      recommendedTime: recommendedTime ?? this.recommendedTime,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
