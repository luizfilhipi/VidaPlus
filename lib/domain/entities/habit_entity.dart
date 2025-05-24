import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HabitFrequency {
  daily,
  weekly,
}

class HabitEntity extends Equatable {
  final String? id; // Opcional, será gerado pelo Firestore ao criar
  final String userId;
  final String name;
  final HabitFrequency frequency;
  final TimeOfDay? recommendedTime; // Opcional, para lembretes
  final DateTime createdAt; // Data de criação do hábito

  const HabitEntity({
    this.id,
    required this.userId,
    required this.name,
    required this.frequency,
    this.recommendedTime,
    required this.createdAt,
  });

  HabitEntity copyWith({
    String? id,
    String? userId,
    String? name,
    HabitFrequency? frequency,
    TimeOfDay? recommendedTime,
    DateTime? createdAt,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      recommendedTime: recommendedTime ?? this.recommendedTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Equatable para comparação de objetos
  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    frequency,
    recommendedTime,
    createdAt,
  ];
}