import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/domain/repositories/habit_repository.dart';
import 'package:flutter_vidaplus/domain/usecases/habit_usecases.dart';
import 'habit_usecases_test.mocks.dart';

@GenerateMocks([HabitRepository])
void main() {
  late AddHabitUseCase addHabitUseCase;
  late GetHabitsUseCase getHabitsUseCase;
  late UpdateHabitUseCase updateHabitUseCase;
  late MockHabitRepository mockRepository;

  setUp(() {
    mockRepository = MockHabitRepository();
    addHabitUseCase = AddHabitUseCase(mockRepository);
    getHabitsUseCase = GetHabitsUseCase(mockRepository);
    updateHabitUseCase = UpdateHabitUseCase(mockRepository);
  });

  group('AddHabitUseCase', () {
    final habit = HabitEntity(
      userId: 'test_user',
      name: 'Exercise',
      frequency: HabitFrequency.daily,
      recommendedTime: const TimeOfDay(hour: 8, minute: 0),
      createdAt: DateTime.now(),
    );

    test('should add habit successfully', () async {
      // arrange
      when(mockRepository.addHabit(habit))
          .thenAnswer((_) async => habit);

      // act
      final result = await addHabitUseCase(habit);

      // assert
      expect(result, habit);
      verify(mockRepository.addHabit(habit)).called(1);
    });
  });

  group('GetHabitsUseCase', () {
    final habits = [
      HabitEntity(
        userId: 'test_user',
        name: 'Exercise',
        frequency: HabitFrequency.daily,
        createdAt: DateTime.now(),
      ),
      HabitEntity(
        userId: 'test_user',
        name: 'Read',
        frequency: HabitFrequency.weekly,
        createdAt: DateTime.now(),
      ),
    ];

    test('should get habits stream successfully', () {
      // arrange
      when(mockRepository.getHabits('test_user'))
          .thenAnswer((_) => Stream.value(habits));

      // act
      final result = getHabitsUseCase('test_user');

      // assert
      expect(result, emits(habits));
      verify(mockRepository.getHabits('test_user')).called(1);
    });
  });

  group('UpdateHabitUseCase', () {
    final habit = HabitEntity(
      id: '1',
      userId: 'test_user',
      name: 'Exercise',
      frequency: HabitFrequency.daily,
      recommendedTime: const TimeOfDay(hour: 8, minute: 0),
      createdAt: DateTime.now(),
    );

    test('should update habit successfully', () async {
      // arrange
      when(mockRepository.updateHabit(habit))
          .thenAnswer((_) async => {});

      // act
      await updateHabitUseCase(habit);

      // assert
      verify(mockRepository.updateHabit(habit)).called(1);
    });
  });
}
