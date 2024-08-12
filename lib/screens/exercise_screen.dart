import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../models/exercise_type.dart';
import '../stores/exercise_store.dart';
import '../models/exercise_entry.dart';
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

  // Checkbox-States für Vitamine
  bool _isVitaminCTaken = false;
  bool _isVitaminDTaken = false;
  bool _isZincTaken = false;
  bool _isCalciumTaken = false;

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

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle error: no user is logged in
        return;
      }

      final entry = ExerciseEntry(
        id: '', // Wird später von Firestore generiert
        uid: user.uid, // Benutzer-ID
        name: _nameController.text,
        date: _selectedDate,
        exerciseTypes: _selectedExerciseTypes,
        details: _exerciseControllers.map((key, value) => MapEntry(key.name, value.map((k, v) => MapEntry(k, v.text)))),
        vitamins: {
          'Vitamin C': _isVitaminCTaken,
          'Vitamin D': _isVitaminDTaken,
          'Zinc': _isZincTaken,
          'Calcium': _isCalciumTaken,
        },
        supplements: {
          'Protein': int.tryParse(_proteinController.text) ?? 0,
          'Creatine': int.tryParse(_creatineController.text) ?? 0,
          'BCAA': int.tryParse(_bcaaController.text) ?? 0,
        },
      );

      final exerciseStore = Provider.of<ExerciseStore>(context, listen: false);
      exerciseStore.addExercise(entry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Exercise Entry')),
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
                  getDropdownText: () => _selectedExerciseTypes.map((e) => e.name).join(', '),
                ),
                const SizedBox(height: 16),
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
                      switch (vitamin) {
                        case 'C':
                          _isVitaminCTaken = value;
                          break;
                        case 'D':
                          _isVitaminDTaken = value;
                          break;
                        case 'Zinc':
                          _isZincTaken = value;
                          break;
                        case 'Calcium':
                          _isCalciumTaken = value;
                          break;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                SupplementSection(
                  proteinController: _proteinController,
                  creatineController: _creatineController,
                  bcaaController: _bcaaController,
                  isProteinChecked: _proteinController.text.isNotEmpty,
                  isCreatineChecked: _creatineController.text.isNotEmpty,
                  isBcaaChecked: _bcaaController.text.isNotEmpty,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveExercise,
                  child: Text('Save Exercise'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
