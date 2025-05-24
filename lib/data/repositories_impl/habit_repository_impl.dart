import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_datasource.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource _dataSource;

  HabitRepositoryImpl(this._dataSource);

  @override
  Stream<List<HabitEntity>> getHabits(String userId) {
    return _dataSource.getHabits(userId).map(
      (habits) => habits.map((habit) => habit.toEntity()).toList(),
    );
  }

  @override
  Future<HabitEntity> addHabit(HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    final addedHabit = await _dataSource.addHabit(habitModel);
    return addedHabit.toEntity();
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    await _dataSource.updateHabit(habitModel);
  }
}
