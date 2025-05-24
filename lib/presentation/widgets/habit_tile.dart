import 'package:flutter/material.dart';
import 'package:flutter_vidaplus/domain/entities/habit_entity.dart';

class HabitTile extends StatelessWidget {
  final HabitEntity habit;
  final VoidCallback onToggleCompletion;
  final Function(int) onUpdateValue;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onToggleCompletion,
    required this.onUpdateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: habit.isCompleted ? Colors.green.shade50 : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (habit.recommendedTime != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                habit.formattedRecommendedTime,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (habit.type == HabitType.binary)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        key: ValueKey(habit.isCompleted),
                        icon: Icon(
                          habit.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: habit.isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: onToggleCompletion,
                      ),
                    ),
                ],
              ),

              if (habit.type == HabitType.incremental) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: habit.progress,
                            ),
                            builder: (context, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: value,
                                      backgroundColor: Colors.grey[200],
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${habit.currentValue ?? 0} / ${habit.targetValue}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: habit.currentValue == null || habit.currentValue == 0
                              ? null
                              : () => onUpdateValue((habit.currentValue ?? 0) - 1),
                          color: Colors.red[400],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: habit.currentValue == habit.targetValue
                              ? null
                              : () => onUpdateValue((habit.currentValue ?? 0) + 1),
                          color: Colors.green[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
