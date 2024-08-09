import 'package:flutter/material.dart';

class VitaminSection extends StatelessWidget {
  final bool isVitaminCTaken;
  final bool isVitaminDTaken;
  final bool isZincTaken;
  final bool isCalciumTaken;
  final Function(String, bool) onVitaminChanged;

  const VitaminSection({
    required this.isVitaminCTaken,
    required this.isVitaminDTaken,
    required this.isZincTaken,
    required this.isCalciumTaken,
    required this.onVitaminChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vitamins',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        CheckboxListTile(
          title: Text('Vitamin C'),
          value: isVitaminCTaken,
          onChanged: (bool? value) => onVitaminChanged('C', value!),
        ),
        CheckboxListTile(
          title: Text('Vitamin D'),
          value: isVitaminDTaken,
          onChanged: (bool? value) => onVitaminChanged('D', value!),
        ),
        CheckboxListTile(
          title: Text('Zinc'),
          value: isZincTaken,
          onChanged: (bool? value) => onVitaminChanged('Zinc', value!),
        ),
        CheckboxListTile(
          title: Text('Calcium'),
          value: isCalciumTaken,
          onChanged: (bool? value) => onVitaminChanged('Calcium', value!),
        ),
      ],
    );
  }
}
