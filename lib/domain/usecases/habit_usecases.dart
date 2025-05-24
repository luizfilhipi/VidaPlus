import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

/// AddHabitUseCase follows Single Responsibility Principle by only handling habit creation
class AddHabitUseCase {
  final HabitRepository _repository;

  AddHabitUseCase(this._repository);

  Future<HabitEntity> call(HabitEntity habit) async {
    return await _repository.addHabit(habit);
  }
}

/// GetHabitsUseCase follows Single Responsibility Principle by only handling habit retrieval
class GetHabitsUseCase {
  final HabitRepository _repository;

  GetHabitsUseCase(this._repository);

  Stream<List<HabitEntity>> call(String userId) {
    return _repository.getHabits(userId);
  }
}

/// UpdateHabitUseCase follows Single Responsibility Principle by only handling habit updates
class UpdateHabitUseCase {
  final HabitRepository _repository;

  UpdateHabitUseCase(this._repository);

  Future<void> call(HabitEntity habit) async {
    await _repository.updateHabit(habit);
  }
}

