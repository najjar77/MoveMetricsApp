import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_entry.dart';

class ExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExerciseEntry(ExerciseEntry entry) async {
    try {
      await _firestore.collection('exercises').doc(entry.id).set(entry.toMap());
    } catch (e) {
      print('Fehler beim Hinzufügen des Übungseintrags: $e');
    }
  }

  Future<List<ExerciseEntry>> getAllExerciseEntries() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('exercises').get();
      return snapshot.docs.map((doc) {
        return ExerciseEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Fehler beim Laden der Übungseinträge: $e');
      return [];
    }
  }

  Future<List<ExerciseEntry>> getExerciseEntriesByUid(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('exercises')
          .where('uid', isEqualTo: uid)
          .get();
      return snapshot.docs.map((doc) {
        return ExerciseEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Fehler beim Laden der Benutzerübungseinträge: $e');
      return [];
    }
  }

  Future<void> deleteExerciseEntry(String id) async {
    try {
      await _firestore.collection('exercises').doc(id).delete();
      print('Übungseintrag gelöscht');
    } catch (e) {
      print('Fehler beim Löschen des Übungseintrags: $e');
    }
  }
}
