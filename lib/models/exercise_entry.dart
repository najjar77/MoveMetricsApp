import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_type.dart';

class ExerciseEntry {
  final String id; // Firebase-generierte ID
  final String uid; // Benutzer-ID
  final String name;
  final DateTime date;
  final List<ExerciseType> exerciseTypes;
  final Map<String, dynamic> details;
  final Map<String, bool> vitamins;
  final Map<String, int> supplements;

  ExerciseEntry({
    required this.id,
    required this.uid,
    required this.name,
    required this.date,
    required this.exerciseTypes,
    required this.details,
    required this.vitamins,
    required this.supplements,
  });

  // Konvertiere das ExerciseEntry in ein Map für Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'date': Timestamp.fromDate(date), // Konvertiere DateTime in Timestamp
      'exerciseTypes': exerciseTypes.isNotEmpty 
          ? exerciseTypes.map((e) => e.name).toList()
          : null, // Speichere nichts, wenn nicht ausgewählt
      'details': details,
      'vitamins': vitamins,
      'supplements': supplements,
    };
  }

  // Erstelle ein ExerciseEntry aus einem Firestore-Dokument
  static ExerciseEntry fromMap(Map<String, dynamic> map, String id) {
    return ExerciseEntry(
      id: id,
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      date: _parseDate(map['date']),
      exerciseTypes: (map['exerciseTypes'] as List<dynamic>?)
              ?.map((e) => ExerciseType.values.firstWhere(
                    (type) => type.name == e,
                    orElse: () => ExerciseType.cycling,
                  ))
              .toList() ??
          [], // Falls keine Sportart ausgewählt ist, gib eine leere Liste zurück
      details: Map<String, dynamic>.from(map['details'] ?? {}),
      vitamins: Map<String, bool>.from(map['vitamins'] ?? {}),
      supplements: Map<String, int>.from(map['supplements'] ?? {}),
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate(); // Wenn es ein Timestamp ist, konvertiere es in DateTime
    } else if (date is String) {
      return DateTime.parse(date); // Wenn es ein String ist, versuche es als ISO 8601-Datum zu parsen
    } else {
      throw Exception('Ungültiger Datentyp für Datum: $date');
    }
  }
}
