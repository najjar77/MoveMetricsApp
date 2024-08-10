import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_type.dart';

class ExerciseEntry {
  String id; // Eindeutige ID für den Eintrag
  String name;
  DateTime date;
  List<ExerciseType> exerciseTypes;
  Map<String, dynamic> details; // Dynamische Details wie Zeit, Distanz, etc.
  Map<String, bool> vitamins; // Vitamine (Vitamin C, D, etc.)
  Map<String, dynamic> supplements; // Supplements (Protein, Creatine, etc.)

  ExerciseEntry({
    required this.id,
    required this.name,
    required this.date,
    required this.exerciseTypes,
    required this.details,
    required this.vitamins,
    required this.supplements,
  });

  // Konvertiert das Objekt in ein Map, um es in Firebase zu speichern
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'exerciseTypes': exerciseTypes.map((type) => type.toString()).toList(),
      'details': details,
      'vitamins': vitamins,
      'supplements': supplements,
    };
  }

  // Erstellt ein Objekt aus einer Firebase-Dokument-Snapshot
  factory ExerciseEntry.fromMap(Map<String, dynamic> map, String id) {
    return ExerciseEntry(
      id: id,
      name: map['name'],
      date: DateTime.parse(map['date']),
      exerciseTypes: (map['exerciseTypes'] as List)
          .map((type) => ExerciseType.values.firstWhere((e) => e.toString() == type))
          .toList(),
      details: Map<String, dynamic>.from(map['details']),
      vitamins: Map<String, bool>.from(map['vitamins']),
      supplements: Map<String, dynamic>.from(map['supplements']),
    );
  }
}
