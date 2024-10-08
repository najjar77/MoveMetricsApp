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
      final docRef = _firestore.collection('exercises').doc();
      final exerciseWithId = ExerciseEntry(
        id: docRef.id,
        uid: exercise.uid,
        name: exercise.name,
        date: exercise.date,
        exerciseTypes: exercise.exerciseTypes,
        details: exercise.details,
        vitamins: exercise.vitamins,
        supplements: exercise.supplements,
      );
      await docRef.set(exerciseWithId.toMap());
    } catch (e) {
      print('Fehler beim Hinzufügen des Übungseintrags: $e');
    }
  }

  @action
  Future<void> deleteExercise(String id) async {
    try {
      await _firestore.collection('exercises').doc(id).delete();
      exercises.removeWhere((exercise) => exercise.id == id);
    } catch (e) {
      print('Fehler beim Löschen des Übungseintrags: $e');
    }
  }

 @action
  void loadExercisesByUID(String uid) {
    _firestore
        .collection('exercises')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      final List<ExerciseEntry> updatedExercises = snapshot.docs.map((doc) {
        return ExerciseEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      exercises = ObservableList<ExerciseEntry>.of(updatedExercises);
    });
  }
}
