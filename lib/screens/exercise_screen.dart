import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../models/exercise_type.dart';
import '../stores/exercise_store.dart';
import '../models/exercise_entry.dart';

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exerciseStore = Provider.of<ExerciseStore>(context);

    // Beispiel für das Hinzufügen eines Eintrags
    void _saveExercise() {

    final user = FirebaseAuth.instance.currentUser; // Aktueller Benutzer
    if (user == null) {
      // Handle error: no user is logged in
      return;
    }

      final entry = ExerciseEntry(
        id: '', // Wird später von Firestore generiert
        uid: user.uid, // Benutzer-ID
        name: 'Cycling',
        date: DateTime.now(),
        exerciseTypes: [ExerciseType.running, ExerciseType.cycling],
        details: {'distance': 10, 'time': '00:30'},
        vitamins: {'Vitamin C': true, 'Vitamin D': false},
        supplements: {'Protein': 30, 'Creatine': 5},
      );

    final exerciseStore = Provider.of<ExerciseStore>(context, listen: false);
    exerciseStore.addExercise(entry);
    Navigator.pop(context);    }

    return Scaffold(
      appBar: AppBar(title: Text('Exercise Entries')),
      body: Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: exerciseStore.exercises.length,
            itemBuilder: (context, index) {
              final exercise = exerciseStore.exercises[index];
              return ListTile(
                title: Text(exercise.name),
                subtitle: Text(
                  '${exercise.date.toLocal().toString().split(' ')[0]} - ${exercise.exerciseTypes.map((e) => e.name).join(', ')}',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveExercise,
        child: Icon(Icons.add),
      ),
    );
  }
}
