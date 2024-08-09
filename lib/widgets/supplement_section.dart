import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class SupplementSection extends StatelessWidget {
  final TextEditingController proteinController;
  final TextEditingController creatineController;
  final TextEditingController bcaaController;
  final bool isProteinChecked;
  final bool isCreatineChecked;
  final bool isBcaaChecked;

  const SupplementSection({
    required this.proteinController,
    required this.creatineController,
    required this.bcaaController,
    required this.isProteinChecked,
    required this.isCreatineChecked,
    required this.isBcaaChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supplements',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _buildSupplementField(proteinController, 'Protein (grams)', isProteinChecked),
        const SizedBox(height: 10),
        _buildSupplementField(creatineController, 'Creatine (grams)', isCreatineChecked),
        const SizedBox(height: 10),
        _buildSupplementField(bcaaController, 'BCAA (grams)', isBcaaChecked),
      ],
    );
  }

  Widget _buildSupplementField(TextEditingController controller, String labelText, bool isChecked) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: controller,
            labelText: labelText,
            obscureText: false,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(width: 10),
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            if (value == true && controller.text.isEmpty) {
              controller.text = '0';
            } else if (value == false) {
              controller.clear();
            }
          },
        ),
      ],
    );
  }
}
