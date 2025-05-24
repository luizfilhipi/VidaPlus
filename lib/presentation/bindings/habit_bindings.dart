import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/habit_datasource.dart';
import '../../data/repositories_impl/habit_repository_impl.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/usecases/habit_usecases.dart';
import '../controllers/habit_controller.dart';

class HabitBindings extends Bindings {
  @override
  void dependencies() {
    // Firestore instance
    Get.lazyPut(() => FirebaseFirestore.instance);

    // DataSource
    Get.lazyPut<HabitRemoteDataSource>(
      () => FirebaseHabitDataSource(firestore: Get.find<FirebaseFirestore>()),
    );

    // Repository
    Get.lazyPut<HabitRepository>(
      () => HabitRepositoryImpl(Get.find<HabitRemoteDataSource>()),
    );

    // UseCases
    Get.lazyPut(
      () => GetHabitsUseCase(Get.find<HabitRepository>()),
    );
    Get.lazyPut(
      () => UpdateHabitUseCase(Get.find<HabitRepository>()),
    );
    Get.lazyPut(
      () => AddHabitUseCase(Get.find<HabitRepository>()),
    );

    // Controller
    Get.lazyPut(
      () => HabitController(
        getHabitsUseCase: Get.find(),
        updateHabitUseCase: Get.find(),
        addHabitUseCase: Get.find(),
      ),
    );
  }
}
