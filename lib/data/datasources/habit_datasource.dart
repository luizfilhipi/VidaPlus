import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vidaplus/data/models/habit_model.dart';

/// HabitRemoteDataSource handles all Firebase Firestore operations
/// Following Single Responsibility Principle by only handling data access
abstract class HabitRemoteDataSource {
  Future<HabitModel> addHabit(HabitModel habit);
  Stream<List<HabitModel>> getHabits(String userId);
  Future<void> updateHabit(HabitModel habit);
}

class FirebaseHabitDataSource implements HabitRemoteDataSource {
  final FirebaseFirestore _firestore;
  
  FirebaseHabitDataSource({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference for user's habits
  CollectionReference<Map<String, dynamic>> _userHabitsCollection(String userId) =>
      _firestore.collection('users').doc(userId).collection('habits');

  @override
  Future<HabitModel> addHabit(HabitModel habit) async {
    try {
      final docRef = await _userHabitsCollection(habit.userId).add(habit.toFirestore());
      return habit.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to add habit: $e');
    }
  }

  @override
  Stream<List<HabitModel>> getHabits(String userId) {
    return _userHabitsCollection(userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HabitModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    if (habit.id == null) throw Exception('Habit ID cannot be null for update');
    try {
      await _userHabitsCollection(habit.userId)
          .doc(habit.id)
          .update(habit.toFirestore());
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }
}
