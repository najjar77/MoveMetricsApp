import 'package:flutter/material.dart';
import '../models/exercise_type.dart';
import '../widgets/custom_text_field.dart';

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

  // Checkbox-States für Supplements
  bool _isProteinChecked = false;
  bool _isCreatineChecked = false;
  bool _isBcaaChecked = false;

  @override
  void initState() {
    super.initState();

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

    // Initialisiere die Controller für jede Sportart
    for (var type in ExerciseType.values) {
      _exerciseControllers[type] = {
        'time': TextEditingController(),
        'distance': TextEditingController(),
        'weight': TextEditingController(),
        'reps': TextEditingController(),
        // Füge hier spezifische Controller für andere Sportarten hinzu
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

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        controller.text = time.toLocal().toString().split(' ')[1].substring(0, 5); // Zeigt die Zeit im Format HH:MM
      });
    }
  }

  void _showMultiSelectDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        List<ExerciseType> selectedTemp = List.from(_selectedExerciseTypes); // Temporäre Liste zur Speicherung der Auswahl
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
                      _selectedExerciseTypes = selectedTemp; // Aktualisiere die Auswahl im Hauptzustand
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}', // Das Datum korrekt anzeigen
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildExerciseTypeDropdown(),
                const SizedBox(height: 16),
                ..._buildDynamicFields(),
                const SizedBox(height: 16),
                _buildVitaminSection(),
                const SizedBox(height: 16),
                _buildSupplementSection(),
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

  Widget _buildExerciseTypeDropdown() {
    return GestureDetector(
      onTap: _showMultiSelectDialog,
      child: AbsorbPointer(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Exercise Types',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          value: _selectedExerciseTypes.isEmpty ? null : _getDropdownText(),
          items: [
            DropdownMenuItem(
              value: _getDropdownText(),
              child: Text(
                _getDropdownText(),
                overflow: TextOverflow.ellipsis, // Kürzt den Text mit Ellipsen
              ),
            ),
          ],
          onChanged: null, // Wird durch die Gestenerkennung verwaltet
        ),
      ),
    );
  }

  String _getDropdownText() {
    if (_selectedExerciseTypes.isEmpty) {
      return 'No exercise type selected';
    }

    String combinedText = _selectedExerciseTypes.map((e) => e.name).join(', ');

    if (combinedText.length > 30) { // Begrenze die Länge auf 30 Zeichen
      combinedText = combinedText.substring(0, 17) + '...';
    }

    return combinedText;
  }

  List<Widget> _buildDynamicFields() {
    List<Widget> fields = [];
    for (var type in _selectedExerciseTypes) {
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
                _buildNumberField(_exerciseControllers[type]!['distance']!, 'Distance (in kilometers)'),
                const SizedBox(height: 10),
                _buildTimeField(_exerciseControllers[type]!['time']!, 'Time'),
              ],
              if (type == ExerciseType.weightlifting) ...[
                _buildNumberField(_exerciseControllers[type]!['weight']!, 'Weight (in kg)'),
                const SizedBox(height: 10),
                _buildNumberField(_exerciseControllers[type]!['reps']!, 'Reps'),
              ],
              // Füge hier spezifische Felder für andere Sportarten hinzu
            ],
          ),
        ),
      );
    }
    return fields;
  }

  Widget _buildVitaminSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vitamins',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        CheckboxListTile(
          title: Text('Vitamin C'),
          value: _isVitaminCTaken,
          onChanged: (bool? value) {
            setState(() {
              _isVitaminCTaken = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Vitamin D'),
          value: _isVitaminDTaken,
          onChanged: (bool? value) {
            setState(() {
              _isVitaminDTaken = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Zinc'),
          value: _isZincTaken,
          onChanged: (bool? value) {
            setState(() {
              _isZincTaken = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Calcium'),
          value: _isCalciumTaken,
          onChanged: (bool? value) {
            setState(() {
              _isCalciumTaken = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSupplementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supplements',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _buildSupplementField(_proteinController, 'Protein (grams)', _isProteinChecked),
        const SizedBox(height: 10),
        _buildSupplementField(_creatineController, 'Creatine (grams)', _isCreatineChecked),
        const SizedBox(height: 10),
        _buildSupplementField(_bcaaController, 'BCAA (grams)', _isBcaaChecked),
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
            textInputType: TextInputType.number, // Akzeptiert nur Zahlen
            textInputAction: TextInputAction.next, // Stellt die "Next"/"Done"-Tasten bereit
          ),
        ),
        const SizedBox(width: 10),
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value == true && controller.text.isEmpty) {
                controller.text = '0'; // Setze einen Standardwert, wenn aktiviert
              } else if (value == false) {
                controller.clear(); // Leere das Feld, wenn deaktiviert
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildNumberField(TextEditingController controller, String labelText) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      obscureText: false,
      textInputType: TextInputType.number, // Akzeptiert nur Zahlen
      textInputAction: TextInputAction.next, // Zeigt die "Next"-Taste auf der Tastatur
    );
  }

  Widget _buildTimeField(TextEditingController controller, String labelText) {
    return GestureDetector(
      onTap: () => _selectTime(context, controller),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          labelText: labelText,
          obscureText: false,
          textInputAction: TextInputAction.next, // Zeigt die "Next"-Taste auf der Tastatur
        ),
      ),
    );
  }
}
