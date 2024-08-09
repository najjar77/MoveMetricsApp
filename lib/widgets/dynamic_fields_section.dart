import 'package:flutter/material.dart';
import '../models/exercise_type.dart';
import '../widgets/custom_text_field.dart';

class DynamicFieldsSection extends StatelessWidget {
  final List<ExerciseType> selectedExerciseTypes;
  final Map<ExerciseType, Map<String, TextEditingController>> exerciseControllers;

  const DynamicFieldsSection({
    required this.selectedExerciseTypes,
    required this.exerciseControllers,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];
    for (var type in selectedExerciseTypes) {
      fields.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${type.name} Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              if (type == ExerciseType.cycling || type == ExerciseType.running) ...[
                CustomTextField(
                  controller: exerciseControllers[type]!['distance']!,
                  labelText: 'Distance (in kilometers)',
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectTime(context, exerciseControllers[type]!['time']!),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: exerciseControllers[type]!['time']!,
                      labelText: 'Time',
                      obscureText: false,
                    ),
                  ),
                ),
              ],
              if (type == ExerciseType.weightlifting) ...[
                CustomTextField(
                  controller: exerciseControllers[type]!['weight']!,
                  labelText: 'Weight (in kg)',
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: exerciseControllers[type]!['reps']!,
                  labelText: 'Reps',
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: fields);
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final time = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller.text = time.toLocal().toString().split(' ')[1].substring(0, 5); // Zeigt die Zeit im Format HH:MM
    }
  }
}
