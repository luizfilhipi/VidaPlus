import 'package:mockito/annotations.dart';
import 'package:flutter_vidaplus/domain/repositories/habit_repository.dart';
import 'package:flutter_vidaplus/presentation/controllers/auth_controller.dart';
import 'package:flutter_vidaplus/domain/usecases/habit_usecases.dart';

@GenerateMocks([
  HabitRepository,
  AuthController,
  AddHabitUseCase,
  GetHabitsUseCase,
  UpdateHabitUseCase,
])
void main() {}
