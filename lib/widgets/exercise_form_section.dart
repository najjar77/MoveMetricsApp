import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class ExerciseFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final DateTime selectedDate;
  final VoidCallback selectDateCallback;
  final VoidCallback showMultiSelectDialog;
  final List selectedExerciseTypes;
  final String Function() getDropdownText;

  const ExerciseFormSection({
    required this.nameController,
    required this.selectedDate,
    required this.selectDateCallback,
    required this.showMultiSelectDialog,
    required this.selectedExerciseTypes,
    required this.getDropdownText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          labelText: 'Exercise Name',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: selectDateCallback,
              child: const Text('Select date'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: showMultiSelectDialog,
          child: AbsorbPointer(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Exercise Types',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              value: selectedExerciseTypes.isEmpty ? null : getDropdownText(),
              items: [
                DropdownMenuItem(
                  value: getDropdownText(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // Setze eine maximale Breite
                    child: Text(
                      getDropdownText(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: null,
            ),
          ),
        ),
      ],
    );
  }
}
