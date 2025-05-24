import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';
import 'package:flutter_vidaplus/presentation/widgets/habit_form_widget.dart';

import '../controllers/habit_controller_test.mocks.dart';

void main() {
  late MockAddHabitUseCase mockAddHabitUseCase;
  late MockGetHabitsUseCase mockGetHabitsUseCase;
  late MockUpdateHabitUseCase mockUpdateHabitUseCase;
  late MockAuthController mockAuthController;
  late HabitController habitController;

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

    Get.put(habitController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HabitFormWidget displays all required fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitFormWidget(),
        ),
      ),
    );

    // Verify presence of form fields
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(RadioListTile<HabitFrequency>), findsNWidgets(2));
    expect(find.text('Diário'), findsOneWidget);
    expect(find.text('Semanal'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('HabitFormWidget validates empty name field', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitFormWidget(),
        ),
      ),
    );

    // Try to submit without entering a name
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error message is shown
    expect(find.text('Por favor, insira um nome para o hábito'), findsOneWidget);
  });

  testWidgets('HabitFormWidget submits form successfully', (WidgetTester tester) async {
    when(mockAuthController.user.value?.id).thenReturn('test_user');
    when(mockAddHabitUseCase(any)).thenAnswer((_) async => HabitEntity(
      userId: 'test_user',
      name: 'Exercise',
      frequency: HabitFrequency.daily,
      createdAt: DateTime.now(),
    ));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitFormWidget(),
        ),
      ),
    );

    // Fill form
    await tester.enterText(find.byType(TextFormField), 'Exercise');
    await tester.pump();

    // Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify form submission
    verify(mockAddHabitUseCase(any)).called(1);
  });
}
