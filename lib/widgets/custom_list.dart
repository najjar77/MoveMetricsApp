import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/exercise_entry.dart';
import '../server/exercise_service.dart';

class CustomList extends StatefulWidget {
  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  final ExerciseService _exerciseService = ExerciseService();
  late Future<List<ExerciseEntry>> _exercisesFuture;
  final List<String> _selectedExerciseIds = []; // Liste der ausgewählten IDs

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _exercisesFuture = _exerciseService.getExerciseEntriesByUid(user.uid);
      });
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

  void _deleteSelectedExercises() async {
    for (String id in _selectedExerciseIds) {
      await _exerciseService.deleteExerciseEntry(id);
    }
    _selectedExerciseIds.clear(); // Auswahl leeren
    _loadExercises(); // Liste nach dem Löschen neu laden
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<ExerciseEntry>>(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading exercises'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No exercises found'));
              } else {
                final exercises = snapshot.data!;
                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    final isSelected = _selectedExerciseIds.contains(exercise.id);
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(exercise.date.toLocal().toString()),
                      trailing: Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? Colors.green : null,
                      ),
                      onTap: () => _toggleSelection(exercise.id),
                      onLongPress: () => _toggleSelection(exercise.id), // Lang drücken zum Auswählen
                    );
                  },
                );
              }
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
  }
}
