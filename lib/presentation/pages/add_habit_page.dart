import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vidaplus/presentation/controllers/habit_controller.dart';
import 'package:flutter_vidaplus/presentation/widgets/habit_form_widget.dart';

class AddHabitPage extends GetView<HabitController> {
  const AddHabitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicione um Novo Habito'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Cria um Novo Habito',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crie melhores hábitos monitorando-os diariamente ou semanalmente',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Habit Form
                const HabitFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
