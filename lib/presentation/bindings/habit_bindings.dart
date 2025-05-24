import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vidaplus/data/datasources/habit_datasource.dart';
import 'package:flutter_vidaplus/data/repositories_impl/habit_repository_impl.dart';
import 'package:flutter_vidaplus/domain/usecases/habit_usecases.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';

class HabitBindings extends Bindings {
  @override
  void dependencies() {
    // DataSource
    Get.lazyPut<HabitRemoteDataSource>(
      () => FirebaseHabitDataSource(firestore: FirebaseFirestore.instance),
    );

    // Repository
    Get.lazyPut(
      () => HabitRepositoryImpl(Get.find<HabitRemoteDataSource>()),
    );

    // UseCases
    Get.lazyPut(
      () => AddHabitUseCase(Get.find<HabitRepositoryImpl>()),
    );
    Get.lazyPut(
      () => GetHabitsUseCase(Get.find<HabitRepositoryImpl>()),
    );
    Get.lazyPut(
      () => UpdateHabitUseCase(Get.find<HabitRepositoryImpl>()),
    );

    // Controller
    Get.lazyPut(
      () => HabitController(
        addHabitUseCase: Get.find<AddHabitUseCase>(),
        getHabitsUseCase: Get.find<GetHabitsUseCase>(),
        updateHabitUseCase: Get.find<UpdateHabitUseCase>(),
      ),
    );
  }
}
