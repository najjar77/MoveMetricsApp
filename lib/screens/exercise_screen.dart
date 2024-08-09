import 'package:flutter/material.dart';
import '../models/exercise_type.dart';
import '../widgets/exercise_form_section.dart';
import '../widgets/dynamic_fields_section.dart';
import '../widgets/vitamin_section.dart';
import '../widgets/supplement_section.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<ExerciseType> _selectedExerciseTypes = [];
  final Map<ExerciseType, Map<String, TextEditingController>> _exerciseControllers = {};

  // Controller für Supplements
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _creatineController = TextEditingController();
  final TextEditingController _bcaaController = TextEditingController();

  // Checkbox-States für Vitamine und Supplements
  bool _isVitaminCTaken = false;
  bool _isVitaminDTaken = false;
  bool _isZincTaken = false;
  bool _isCalciumTaken = false;
  bool _isProteinChecked = false;
  bool _isCreatineChecked = false;
  bool _isBcaaChecked = false;

  @override
  void initState() {
    super.initState();
    // Initialisiere die Controller für jede Sportart
    for (var type in ExerciseType.values) {
      _exerciseControllers[type] = {
        'time': TextEditingController(),
        'distance': TextEditingController(),
        'weight': TextEditingController(),
        'reps': TextEditingController(),
      };
    }

    // Füge Listener für Supplements-Textfelder hinzu
    _proteinController.addListener(() {
      setState(() {
        _isProteinChecked = _proteinController.text.isNotEmpty && _proteinController.text != '0';
      });
    });

    _creatineController.addListener(() {
      setState(() {
        _isCreatineChecked = _creatineController.text.isNotEmpty && _creatineController.text != '0';
      });
    });

    _bcaaController.addListener(() {
      setState(() {
        _isBcaaChecked = _bcaaController.text.isNotEmpty && _bcaaController.text != '0';
      });
    });
  }

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
                ExerciseFormSection(
                  nameController: _nameController,
                  selectedDate: _selectedDate,
                  selectDateCallback: () => _selectDate(context),
                  showMultiSelectDialog: _showMultiSelectDialog,
                  selectedExerciseTypes: _selectedExerciseTypes,
                  getDropdownText: _getDropdownText,
                ),
                DynamicFieldsSection(
                  selectedExerciseTypes: _selectedExerciseTypes,
                  exerciseControllers: _exerciseControllers,
                ),
                const SizedBox(height: 16),
                VitaminSection(
                  isVitaminCTaken: _isVitaminCTaken,
                  isVitaminDTaken: _isVitaminDTaken,
                  isZincTaken: _isZincTaken,
                  isCalciumTaken: _isCalciumTaken,
                  onVitaminChanged: (vitamin, value) {
                    setState(() {
                      if (vitamin == 'C') _isVitaminCTaken = value;
                      if (vitamin == 'D') _isVitaminDTaken = value;
                      if (vitamin == 'Zinc') _isZincTaken = value;
                      if (vitamin == 'Calcium') _isCalciumTaken = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SupplementSection(
                  proteinController: _proteinController,
                  creatineController: _creatineController,
                  bcaaController: _bcaaController,
                  isProteinChecked: _isProteinChecked,
                  isCreatineChecked: _isCreatineChecked,
                  isBcaaChecked: _isBcaaChecked,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
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

  void _showMultiSelectDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        List<ExerciseType> selectedTemp = List.from(_selectedExerciseTypes);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Select Exercise Types'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: ExerciseType.values.map((type) {
                    return CheckboxListTile(
                      title: Text(type.name),
                      value: selectedTemp.contains(type),
                      onChanged: (bool? selected) {
                        setStateDialog(() {
                          if (selected == true) {
                            selectedTemp.add(type);
                          } else {
                            selectedTemp.remove(type);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      _selectedExerciseTypes = selectedTemp;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getDropdownText() {
    if (_selectedExerciseTypes.isEmpty) {
      return 'No exercise type selected';
    }

    String combinedText = _selectedExerciseTypes.map((e) => e.name).join(', ');

    if (combinedText.length > 30) {
      combinedText = combinedText.substring(0, 17) + '...';
    }

    return combinedText;
  }
}
