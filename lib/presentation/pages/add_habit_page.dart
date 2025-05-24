import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';
import '../../domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/presentation/routes/app_routes.dart';

class AddHabitPage extends GetView<HabitController> {
  const AddHabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Hábito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Hábito',
                  border: OutlineInputBorder(),
                ),
                validator: controller.validateHabitName,
              ),
              const SizedBox(height: 24),

              const Text(
                'Tipo de Hábito',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() => SegmentedButton<HabitType>(
                segments: const [
                  ButtonSegment(
                    value: HabitType.binary,
                    label: Text('Binário'),
                    icon: Icon(Icons.check_circle_outline),
                  ),
                  ButtonSegment(
                    value: HabitType.incremental,
                    label: Text('Incremental'),
                    icon: Icon(Icons.trending_up),
                  ),
                ],
                selected: {controller.selectedType.value},
                onSelectionChanged: (Set<HabitType> selection) {
                  controller.setType(selection.first);
                },
              )),

              const SizedBox(height: 24),
              const Text(
                'Frequência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() => SegmentedButton<HabitFrequency>(
                segments: const [
                  ButtonSegment(
                    value: HabitFrequency.daily,
                    label: Text('Diário'),
                  ),
                  ButtonSegment(
                    value: HabitFrequency.weekly,
                    label: Text('Semanal'),
                  ),
                ],
                selected: {controller.selectedFrequency.value},
                onSelectionChanged: (Set<HabitFrequency> selection) {
                  controller.setFrequency(selection.first);
                },
              )),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Horário Recomendado (opcional)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(() => TextButton.icon(
                    icon: Icon(Icons.access_time),
                    label: Text(
                      controller.selectedTime.value == null
                          ? 'Definir'
                          : '${controller.selectedTime.value!.hour.toString().padLeft(2, '0')}:${controller.selectedTime.value!.minute.toString().padLeft(2, '0')}',
                    ),
                    onPressed: () => controller.setRecommendedTime(context),
                  )),
                ],
              ),

              Obx(() {
                if (controller.selectedType.value == HabitType.incremental) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text(
                            'Meta Diária',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: controller.targetValue.value <= 1
                                ? null
                                : () => controller.setTargetValue(controller.targetValue.value - 1),
                            color: Colors.red[400],
                          ),
                          Obx(() => Text(
                            controller.targetValue.value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => controller.setTargetValue(controller.targetValue.value + 1),
                            color: Colors.green[400],
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (await controller.addHabit()) {
                            controller.clearForm();
                            Get.toNamed(AppRoutes.habits); // Retorna para a tela de tracking após sucesso
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Adicionar Hábito'),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
