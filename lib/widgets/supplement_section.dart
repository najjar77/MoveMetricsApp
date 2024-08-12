import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class SupplementSection extends StatefulWidget {
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
  _SupplementSectionState createState() => _SupplementSectionState();
}

class _SupplementSectionState extends State<SupplementSection> {
  late bool _isProteinChecked;
  late bool _isCreatineChecked;
  late bool _isBcaaChecked;

  @override
  void initState() {
    super.initState();
    _isProteinChecked = widget.isProteinChecked;
    _isCreatineChecked = widget.isCreatineChecked;
    _isBcaaChecked = widget.isBcaaChecked;
  }

  void _onCheckboxChanged(bool? value, TextEditingController controller, String supplement) {
    setState(() {
      if (value == true && (int.tryParse(controller.text) ?? 0) > 0) {
        controller.text = controller.text.isEmpty ? '0' : controller.text;
      } else {
        controller.clear();
      }

      switch (supplement) {
        case 'Protein':
          _isProteinChecked = value == true && (int.tryParse(controller.text) ?? 0) > 0;
          break;
        case 'Creatine':
          _isCreatineChecked = value == true && (int.tryParse(controller.text) ?? 0) > 0;
          break;
        case 'BCAA':
          _isBcaaChecked = value == true && (int.tryParse(controller.text) ?? 0) > 0;
          break;
      }
    });
  }

  void _onTextChanged(String text, String supplement) {
    final value = int.tryParse(text) ?? 0;
    setState(() {
      switch (supplement) {
        case 'Protein':
          _isProteinChecked = value > 0;
          break;
        case 'Creatine':
          _isCreatineChecked = value > 0;
          break;
        case 'BCAA':
          _isBcaaChecked = value > 0;
          break;
      }
    });
  }

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
        _buildSupplementField(widget.proteinController, 'Protein (grams)', _isProteinChecked),
        const SizedBox(height: 10),
        _buildSupplementField(widget.creatineController, 'Creatine (grams)', _isCreatineChecked),
        const SizedBox(height: 10),
        _buildSupplementField(widget.bcaaController, 'BCAA (grams)', _isBcaaChecked),
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
            onChanged: (text) => _onTextChanged(text, labelText.split(' ')[0]),
          ),
        ),
        const SizedBox(width: 10),
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) => _onCheckboxChanged(value, controller, labelText.split(' ')[0]),
        ),
      ],
    );
  }
}
