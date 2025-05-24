import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    super.id,
    required super.userId,
    required super.name,
    required super.frequency,
    super.recommendedTime,
    required super.createdAt,
  });

  // Factory constructor para criar um HabitModel a partir de um Firestore DocumentSnapshot
  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HabitModel(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      frequency: HabitFrequency.values.firstWhere(
            (e) => e.toString() == 'HabitFrequency.${data['frequency']}',
      ),
      recommendedTime: data['recommendedTime'] != null
          ? TimeOfDay(
        hour: data['recommendedTime']['hour'] as int,
        minute: data['recommendedTime']['minute'] as int,
      )
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Método para converter um HabitModel (ou HabitEntity) para um Map<String, dynamic>
  // pronto para ser salvo no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'frequency': frequency.toString().split('.').last, // Salva como 'daily' ou 'weekly'
      'recommendedTime': recommendedTime != null
          ? {
        'hour': recommendedTime!.hour,
        'minute': recommendedTime!.minute,
      }
          : null,
      'createdAt': Timestamp.fromDate(createdAt), // Salva como Timestamp
    };
  }

  // Factory constructor para criar um HabitModel a partir de um HabitEntity
  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      frequency: entity.frequency,
      recommendedTime: entity.recommendedTime,
      createdAt: entity.createdAt,
    );
  }

  @override
  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    HabitFrequency? frequency,
    TimeOfDay? recommendedTime,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      recommendedTime: recommendedTime ?? this.recommendedTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}