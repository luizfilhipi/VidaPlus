import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/domain/usecases/habit_usecases.dart';
import 'package:flutter_vidaplus/presentation/controllers/auth_controller.dart';

class HabitController extends GetxController {
  final GetHabitsUseCase _getHabitsUseCase;
  final UpdateHabitUseCase _updateHabitUseCase;
  final AddHabitUseCase _addHabitUseCase;
  final AuthController _authController;

  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<HabitFrequency> selectedFrequency = HabitFrequency.daily.obs;
  final Rx<HabitType> selectedType = HabitType.binary.obs;
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final RxInt targetValue = 1.obs;
  final RxList<HabitEntity> habits = <HabitEntity>[].obs;

  StreamSubscription? _habitsSubscription;

  HabitController({
    required GetHabitsUseCase getHabitsUseCase,
    required UpdateHabitUseCase updateHabitUseCase,
    required AddHabitUseCase addHabitUseCase,
  })  : _getHabitsUseCase = getHabitsUseCase,
        _updateHabitUseCase = updateHabitUseCase,
        _addHabitUseCase = addHabitUseCase,
        _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    ever(_authController.user, (user) {
      if (user != null) {
        _loadHabits();
      } else {
        habits.clear();
      }
    });

    if (_authController.user.value != null) {
      _loadHabits();
    }
  }

  @override
  void onClose() {
    _habitsSubscription?.cancel();
    nameController.dispose();
    super.onClose();
  }

  void _loadHabits() {
    try {
      final userId = _authController.user.value?.id;
      if (userId == null) {
        errorMessage.value = 'Usuário não autenticado';
        return;
      }

      _habitsSubscription?.cancel();
      _habitsSubscription = _getHabitsUseCase(userId).listen(
        (habitList) {
          habits.value = habitList.map((habit) {
            if (habit.shouldReset()) {
              return habit.copyWith(
                isCompleted: false,
                currentValue: 0,
                lastCompletedDate: null,
              );
            }
            return habit;
          }).toList();
        },
        onError: (error) {
          errorMessage.value = 'Erro ao carregar hábitos: $error';
          print('Erro ao carregar hábitos: $error');
        },
      );
    } catch (e) {
      errorMessage.value = 'Erro ao carregar hábitos: $e';
      print('Erro ao carregar hábitos: $e');
    }
  }

  Future<bool> addHabit() async {
    if (!formKey.currentState!.validate()) return false;

    final userId = _authController.user.value?.id;
    if (userId == null) {
      errorMessage.value = 'Usuário não autenticado';
      Get.snackbar(
        'Erro',
        'Faça login para adicionar hábitos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final habit = HabitEntity(
        userId: userId,
        name: nameController.text.trim(),
        frequency: selectedFrequency.value,
        type: selectedType.value,
        recommendedTime: selectedTime.value,
        targetValue: selectedType.value == HabitType.incremental ? targetValue.value : null,
        currentValue: 0,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _addHabitUseCase(habit);
      _resetForm();
      
      await Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[400], size: 28),
              const SizedBox(width: 8),
              const Text('Sucesso!'),
            ],
          ),
          content: const Text('Hábito adicionado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Fecha o dialog
                Get.back(); // Volta para a tela de tracking
              },
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Falha ao adicionar hábito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleHabitCompletion(HabitEntity habit) async {
    try {
      final updatedHabit = habit.copyWith(
        isCompleted: !habit.isCompleted,
        lastCompletedDate: !habit.isCompleted ? DateTime.now() : null,
        type: habit.type,
      );
      await _updateHabitUseCase(updatedHabit);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao atualizar hábito: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateHabitValue(HabitEntity habit, int newValue) async {
    if (habit.type != HabitType.incremental) return;
    if (newValue < 0 || (habit.targetValue != null && newValue > habit.targetValue!)) return;

    try {
      final isCompleted = habit.targetValue != null && newValue >= habit.targetValue!;
      final updatedHabit = habit.copyWith(
        currentValue: newValue,
        isCompleted: isCompleted,
        lastCompletedDate: isCompleted ? DateTime.now() : habit.lastCompletedDate,
        type: habit.type,
      );
      await _updateHabitUseCase(updatedHabit);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao atualizar valor: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _resetForm() {
    nameController.clear();
    selectedFrequency.value = HabitFrequency.daily;
    selectedType.value = HabitType.binary;
    selectedTime.value = null;
    targetValue.value = 1;
  }

  void setFrequency(HabitFrequency frequency) {
    selectedFrequency.value = frequency;
  }

  void setType(HabitType type) {
    selectedType.value = type;
  }

  void setTargetValue(int value) {
    if (value > 0) {
      targetValue.value = value;
    }
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

  String? validateHabitName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome do hábito é obrigatório';
    }
    if (value.length < 3) {
      return 'Nome do hábito deve ter pelo menos 3 caracteres';
    }
    return null;
  }
}
