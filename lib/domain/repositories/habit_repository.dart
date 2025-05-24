import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';

abstract class HabitRepository {
  /// Adds a new habit to the database
  Future<HabitEntity> addHabit(HabitEntity habit);

  /// Gets all habits for a specific user
  Stream<List<HabitEntity>> getHabits(String userId);
  
  /// Updates an existing habit
  Future<void> updateHabit(HabitEntity habit);
}
