import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vidaplus/core/errors/app_exceptions.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';

void main() {
  group('HabitEntity', () {
    test('should be valid with correct data', () {
      final habit = HabitEntity(
        id: '1',
        userId: 'user123',
        name: 'Exercise',
        frequency: HabitFrequency.daily,
        recommendedTime: const TimeOfDay(hour: 8, minute: 0),
        createdAt: DateTime.now(),
      );

      expect(habit.isValid(), true);
    });

    test('should throw ValidationException when name is too short', () {
      final habit = HabitEntity(
        userId: 'user123',
        name: 'Ex',  // Less than 3 characters
        frequency: HabitFrequency.daily,
        createdAt: DateTime.now(),
      );

      expect(
        () => habit.isValid(),
        throwsA(isA<ValidationException>()),
      );
    });

    test('should throw ValidationException when userId is empty', () {
      final habit = HabitEntity(
        userId: '',
        name: 'Exercise',
        frequency: HabitFrequency.daily,
        createdAt: DateTime.now(),
      );

      expect(
        () => habit.isValid(),
        throwsA(isA<ValidationException>()),
      );
    });

    test('formattedRecommendedTime returns correct format', () {
      final habit = HabitEntity(
        userId: 'user123',
        name: 'Exercise',
        frequency: HabitFrequency.daily,
        recommendedTime: const TimeOfDay(hour: 8, minute: 5),
        createdAt: DateTime.now(),
      );

      expect(habit.formattedRecommendedTime, '08:05');
    });

    test('formattedRecommendedTime returns default message when time is null', () {
      final habit = HabitEntity(
        userId: 'user123',
        name: 'Exercise',
        frequency: HabitFrequency.daily,
        createdAt: DateTime.now(),
      );

      expect(habit.formattedRecommendedTime, 'Sem horário definido');
    });
  });
}
