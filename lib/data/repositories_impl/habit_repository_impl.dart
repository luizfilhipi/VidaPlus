import 'package:flutter_vidaplus/data/datasources/habit_datasource.dart';
import 'package:flutter_vidaplus/data/models/habit_model.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/domain/repositories/habit_repository.dart';

/// HabitRepositoryImpl follows Dependency Inversion Principle by depending on abstractions
/// It implements HabitRepository and uses HabitRemoteDataSource abstraction
class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource _dataSource;

  HabitRepositoryImpl(this._dataSource);

  @override
  Future<HabitEntity> addHabit(HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    final result = await _dataSource.addHabit(habitModel);
    return result;
  }

  @override
  Stream<List<HabitEntity>> getHabits(String userId) {
    return _dataSource.getHabits(userId);
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    await _dataSource.updateHabit(habitModel);
  }
}
