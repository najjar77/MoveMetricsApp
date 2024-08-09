import 'package:flutter/material.dart';
import '../models/exercise_type.dart';
import '../widgets/custom_text_field.dart'; // Importiere das CustomTextField

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExerciseType? _selectedExerciseType;
  bool _isProteinTaken = false;
  bool _isCreatineTaken = false;
  bool _isBcaaTaken = false;
  bool _isVitaminTaken = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Exercise Name',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ExerciseType>(
                  decoration: InputDecoration(
                    labelText: 'Exercise Type',
                    filled: true,
                    fillColor: Colors.white, // Setze den Hintergrund auf Weiß
                    border: OutlineInputBorder(),
                  ),
                  items: ExerciseType.values.map((ExerciseType type) {
                    return DropdownMenuItem<ExerciseType>(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (ExerciseType? newValue) {
                    setState(() {
                      _selectedExerciseType = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select an exercise type' : null,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Protein'),
                  value: _isProteinTaken,
                  onChanged: (bool? value) {
                    setState(() {
                      _isProteinTaken = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Creatine'),
                  value: _isCreatineTaken,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCreatineTaken = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('BCAA'),
                  value: _isBcaaTaken,
                  onChanged: (bool? value) {
                    setState(() {
                      _isBcaaTaken = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Vitamins'),
                  value: _isVitaminTaken,
                  onChanged: (bool? value) {
                    setState(() {
                      _isVitaminTaken = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Save exercise entry
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Exercise'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
