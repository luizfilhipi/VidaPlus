import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vidaplus/core/errors/app_exceptions.dart';

enum HabitFrequency {
  daily,
  weekly,
}

enum HabitType {
  binary,
  incremental,
}

class HabitEntity extends Equatable {
  final String? id; // Opcional, será gerado pelo Firestore ao criar
  final String userId;
  final String name;
  final HabitFrequency frequency;
  final HabitType type;
  final TimeOfDay? recommendedTime; // Opcional, para lembretes
  final DateTime createdAt; // Data de criação do hábito
  final DateTime? lastCompletedDate; // Data da última conclusão
  final bool isCompleted; // Estado atual de conclusão
  final int? targetValue; // Meta para hábitos incrementais
  final int? currentValue; // Valor atual para hábitos incrementais
  final String? notes; // Notas opcionais

  const HabitEntity({
    this.id,
    required this.userId,
    required this.name,
    required this.frequency,
    this.type = HabitType.binary,
    this.recommendedTime,
    required this.createdAt,
    this.lastCompletedDate,
    this.isCompleted = false,
    this.targetValue,
    this.currentValue,
    this.notes,
  });

  HabitEntity copyWith({
    String? id,
    String? userId,
    String? name,
    HabitFrequency? frequency,
    HabitType? type,
    TimeOfDay? recommendedTime,
    DateTime? createdAt,
    DateTime? lastCompletedDate,
    bool? isCompleted,
    int? targetValue,
    int? currentValue,
    String? notes,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      type: type ?? this.type,
      recommendedTime: recommendedTime ?? this.recommendedTime,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      notes: notes ?? this.notes,
    );
  }

  bool isValid() {
    if (name.isEmpty || name.length < 3) {
      throw ValidationException('O nome do hábito deve ter pelo menos 3 caracteres');
    }
    
    if (userId.isEmpty) {
      throw ValidationException('ID do usuário é obrigatório');
    }

    if (type == HabitType.incremental && (targetValue == null || targetValue! <= 0)) {
      throw ValidationException('Hábitos incrementais precisam de uma meta válida maior que zero');
    }

    return true;
  }

  bool shouldReset() {
    if (lastCompletedDate == null) return false;
    
    final now = DateTime.now();
    final lastCompleted = DateTime(lastCompletedDate!.year, lastCompletedDate!.month, lastCompletedDate!.day);
    final today = DateTime(now.year, now.month, now.day);
    
    if (frequency == HabitFrequency.daily) {
      return lastCompleted.isBefore(today);
    } else {
      // Para hábitos semanais, verifica se a última conclusão foi em uma semana diferente
      return lastCompleted.difference(today).inDays >= 7;
    }
  }

  // Extension method para formatação do horário recomendado
  String get formattedRecommendedTime {
    if (recommendedTime == null) return 'Sem horário definido';
    return '${recommendedTime!.hour.toString().padLeft(2, '0')}:${recommendedTime!.minute.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (type != HabitType.incremental || targetValue == null || targetValue! <= 0) return 0;
    return (currentValue ?? 0) / targetValue!;
  }

  // Equatable para comparação de objetos
  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    frequency,
    type,
    recommendedTime,
    createdAt,
    lastCompletedDate,
    isCompleted,
    targetValue,
    currentValue,
    notes,
  ];
}