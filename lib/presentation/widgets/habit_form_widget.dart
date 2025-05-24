import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';

class HabitFormWidget extends GetView<HabitController> {
  const HabitFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Habit Name Field
          TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: 'Nome do Habito',
              hintText: 'Escreva o nome do seu habito',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.edit),
            ),
            validator: controller.validateHabitName,
          ),
          const SizedBox(height: 20),

          // Frequency Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequência',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Column(
                    children: [
                      RadioListTile<HabitFrequency>(
                        title: const Text('Diario'),
                        value: HabitFrequency.daily,
                        groupValue: controller.selectedFrequency.value,
                        onChanged: (value) => controller.setFrequency(value!),
                      ),
                      RadioListTile<HabitFrequency>(
                        title: const Text('Semanal'),
                        value: HabitFrequency.weekly,
                        groupValue: controller.selectedFrequency.value,
                        onChanged: (value) => controller.setFrequency(value!),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Recommended Time Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tempo Recomendado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),                  Obx(() => ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      controller.selectedTime.value != null
                          ? '${controller.selectedTime.value!.hour.toString().padLeft(2, '0')}:${controller.selectedTime.value!.minute.toString().padLeft(2, '0')}'
                          : 'Selecione o horário (formato 24h)',
                    ),
                    subtitle: const Text('Horário recomendado para realizar o hábito'),
                    onTap: () => controller.setRecommendedTime(context),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Submit Button
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.addHabit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text(
                    'Adicione o Habito',
                    style: TextStyle(fontSize: 16),
                  ),
          )),
          
          // Error Message
          Obx(() => controller.errorMessage.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
