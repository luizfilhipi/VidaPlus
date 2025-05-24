import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/domain/usecases/habit_usecases.dart';
import 'package:flutter_vidaplus/presentation/controllers/auth_controller.dart';

class HabitController extends GetxController {
  final AddHabitUseCase _addHabitUseCase;
  final GetHabitsUseCase _getHabitsUseCase;
  final UpdateHabitUseCase _updateHabitUseCase;
  
  // Form fields controllers
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<HabitFrequency> selectedFrequency = HabitFrequency.daily.obs;
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final RxList<HabitEntity> habits = <HabitEntity>[].obs;

  late final AuthController _authController;

  HabitController({
    required AddHabitUseCase addHabitUseCase,
    required GetHabitsUseCase getHabitsUseCase,
    required UpdateHabitUseCase updateHabitUseCase,
  })  : _addHabitUseCase = addHabitUseCase,
        _getHabitsUseCase = getHabitsUseCase,
        _updateHabitUseCase = updateHabitUseCase {
    _authController = Get.find<AuthController>();
  }

  String? get _userId => _authController.user.value?.id;

  @override
  void onInit() {
    super.onInit();
    // Start listening to habits stream when the controller is initialized
    if (_userId != null) {
      _loadHabits();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void _loadHabits() {
    if (_userId == null) {
      errorMessage.value = 'No authenticated user found';
      return;
    }
    
    _getHabitsUseCase(_userId!).listen(
      (habitList) => habits.value = habitList,
      onError: (error) => errorMessage.value = error.toString(),
    );
  }

  Future<void> addHabit() async {
    if (!formKey.currentState!.validate()) return;
    if (_userId == null) {
      errorMessage.value = 'No authenticated user found';
      Get.snackbar(
        'Error',
        'Please login to add habits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final habit = HabitEntity(
        userId: _userId!,
        name: nameController.text.trim(),
        frequency: selectedFrequency.value,
        recommendedTime: selectedTime.value,
        createdAt: DateTime.now(),
      );

      await _addHabitUseCase(habit);
      
      // Clear form after successful addition
      _resetForm();
      
      Get.snackbar(
        'Sucesso',
        'Hábito adicionado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Falha ao adicionar hábito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setFrequency(HabitFrequency frequency) {
    selectedFrequency.value = frequency;
  }

  Future<void> setRecommendedTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    
    if (time != null) {
      selectedTime.value = time;
    }
  }

  void _resetForm() {
    nameController.clear();
    selectedFrequency.value = HabitFrequency.daily;
    selectedTime.value = null;
  }

  String? validateHabitName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Habit name is required';
    }
    if (value.length < 3) {
      return 'Habit name must be at least 3 characters';
    }
    return null;
  }
}
