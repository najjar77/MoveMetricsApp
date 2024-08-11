import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_entry.dart';

part 'exercise_store.g.dart';

class ExerciseStore = _ExerciseStore with _$ExerciseStore;

abstract class _ExerciseStore with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @observable
  ObservableList<ExerciseEntry> exercises = ObservableList<ExerciseEntry>();

  @action
  Future<void> addExercise(ExerciseEntry exercise) async {
    try {
      final docRef = _firestore.collection('exercises').doc(); // Generiere eine neue ID
      final exerciseWithId = ExerciseEntry(
        id: docRef.id, // Verwende die generierte ID
        uid: exercise.uid, // Behalte die Benutzer-ID bei
        name: exercise.name,
        date: exercise.date,
        exerciseTypes: exercise.exerciseTypes,
        details: exercise.details,
        vitamins: exercise.vitamins,
        supplements: exercise.supplements,
      );
      await docRef.set(exerciseWithId.toMap()); // Speichere die Daten
      exercises.add(exerciseWithId);
    } catch (e) {
      print('Fehler beim Hinzufügen des Übungseintrags: $e');
    }
  }

  @action
Future<void> loadExercises(String uid) async {
  try {
    QuerySnapshot snapshot = await _firestore
        .collection('exercises')
        .where('uid', isEqualTo: uid)
        .get();

    exercises = ObservableList<ExerciseEntry>.of(snapshot.docs.map((doc) {
      return ExerciseEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList());
  } catch (e) {
    print('Fehler beim Laden der Übungseinträge: $e');
  }
}

}
