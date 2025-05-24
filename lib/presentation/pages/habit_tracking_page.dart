import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';
import 'package:flutter_vidaplus/presentation/widgets/habit_tile.dart';

class HabitTrackingPage extends GetView<HabitController> {
  const HabitTrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Hábitos'),
      ),
      body: Obx(() {
        if (controller.habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.format_list_bulleted,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum hábito adicionado',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/add-habit'),
                  child: const Text('Adicionar Hábito'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.habits.length,
          itemBuilder: (context, index) {
            final habit = controller.habits[index];
            return HabitTile(
              habit: habit,
              onToggleCompletion: () => controller.toggleHabitCompletion(habit),
              onUpdateValue: (value) => controller.updateHabitValue(habit, value),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-habit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
