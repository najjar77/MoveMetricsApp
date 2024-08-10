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
      await _firestore.collection('exercises').doc(exercise.id).set(exercise.toMap());
      exercises.add(exercise);
    } catch (e) {
      print('Fehler beim Hinzufügen des Übungseintrags: $e');
    }
  }

  @action
  Future<void> loadExercises() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('exercises').get();
      exercises = ObservableList<ExerciseEntry>.of(snapshot.docs.map((doc) {
        return ExerciseEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList());
    } catch (e) {
      print('Fehler beim Laden der Übungseinträge: $e');
    }
  }
}
