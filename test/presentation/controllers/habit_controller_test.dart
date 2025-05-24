import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/domain/usecases/habit_usecases.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';
import 'package:flutter_vidaplus/presentation/controllers/auth_controller.dart';

@GenerateMocks([AddHabitUseCase, GetHabitsUseCase, UpdateHabitUseCase, AuthController])
void main() {
  late HabitController habitController;
  late MockAddHabitUseCase mockAddHabitUseCase;
  late MockGetHabitsUseCase mockGetHabitsUseCase;
  late MockUpdateHabitUseCase mockUpdateHabitUseCase;
  late MockAuthController mockAuthController;

  setUp(() {
    mockAddHabitUseCase = MockAddHabitUseCase();
    mockGetHabitsUseCase = MockGetHabitsUseCase();
    mockUpdateHabitUseCase = MockUpdateHabitUseCase();
    mockAuthController = MockAuthController();

    Get.put(mockAuthController);

    habitController = HabitController(
      addHabitUseCase: mockAddHabitUseCase,
      getHabitsUseCase: mockGetHabitsUseCase,
      updateHabitUseCase: mockUpdateHabitUseCase,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('HabitController', () {
    test('should initialize with default values', () {
      expect(habitController.isLoading.value, false);
      expect(habitController.errorMessage.value, '');
      expect(habitController.selectedFrequency.value, HabitFrequency.daily);
      expect(habitController.selectedTime.value, null);
      expect(habitController.habits, isEmpty);
    });

    test('should validate habit name correctly', () {
      expect(habitController.validateHabitName(''), isNotNull); // Error message
      expect(habitController.validateHabitName('ab'), isNotNull); // Error message
      expect(habitController.validateHabitName('Exercise'), isNull); // Valid
    });

    test('should set frequency correctly', () {
      habitController.setFrequency(HabitFrequency.weekly);
      expect(habitController.selectedFrequency.value, HabitFrequency.weekly);
    });

    test('should add habit successfully', () async {
      // arrange
      when(mockAuthController.user.value?.id).thenReturn('test_user');
      when(mockAddHabitUseCase(any)).thenAnswer((_) async => HabitEntity(
        userId: 'test_user',
        name: 'Exercise',
        frequency: HabitFrequency.daily,
        createdAt: DateTime.now(),
      ));

      // act
      habitController.nameController.text = 'Exercise';
      await habitController.addHabit();

      // assert
      verify(mockAddHabitUseCase(any)).called(1);
      expect(habitController.isLoading.value, false);
      expect(habitController.errorMessage.value, '');
      expect(habitController.nameController.text, '');
    });

    test('should handle error when adding habit', () async {
      // arrange
      when(mockAuthController.user.value?.id).thenReturn('test_user');
      when(mockAddHabitUseCase(any)).thenThrow(Exception('Error adding habit'));

      // act
      habitController.nameController.text = 'Exercise';
      await habitController.addHabit();

      // assert
      verify(mockAddHabitUseCase(any)).called(1);
      expect(habitController.isLoading.value, false);
      expect(habitController.errorMessage.value.isNotEmpty, true);
    });
  });
}
