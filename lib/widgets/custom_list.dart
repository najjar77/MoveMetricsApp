import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/exercise_store.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomList extends StatefulWidget {
  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  List<String> _selectedExerciseIds = []; // Liste der ausgewählten Übungseintrags-IDs

  @override
  void initState() {
    super.initState();
    final exerciseStore = Provider.of<ExerciseStore>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      exerciseStore.loadExercisesByUID(user.uid); // Nur Übungen des aktuellen Benutzers laden
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedExerciseIds.contains(id)) {
        _selectedExerciseIds.remove(id);
      } else {
        _selectedExerciseIds.add(id);
      }
    });
  }

  void _deleteSelectedExercises() {
    final exerciseStore = Provider.of<ExerciseStore>(context, listen: false);
    for (var id in _selectedExerciseIds) {
      exerciseStore.deleteExercise(id);
    }
    setState(() {
      _selectedExerciseIds.clear(); // Auswahl nach dem Löschen leeren
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseStore = Provider.of<ExerciseStore>(context);

    return Observer(
      builder: (_) {
        final exercises = exerciseStore.exercises;

        if (exercises.isEmpty) {
          return Center(
            child: Text('No exercises found.'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  final isSelected = _selectedExerciseIds.contains(exercise.id);

                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(
                      '${exercise.date.day.toString().padLeft(2, '0')}-${exercise.date.month.toString().padLeft(2, '0')}-${exercise.date.year.toString()}  ${exercise.exerciseTypes.map((e) => e.name).join(', ')}',
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_box, color: Theme.of(context).primaryColor)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () => _toggleSelection(exercise.id),
                  );
                },
              ),
            ),
            if (_selectedExerciseIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _deleteSelectedExercises,
                  child: Text('Delete Selected (${_selectedExerciseIds.length})'),
                ),
              ),
          ],
        );
      },
    );
  }
}
