// lib/models/exercise_type.dart
enum ExerciseType {
  running,
  cycling,
  swimming,
  weightlifting,
  yoga,
  other,
}

extension ExerciseTypeExtension on ExerciseType {
  String get name {
    switch (this) {
      case ExerciseType.running:
        return 'Running';
      case ExerciseType.cycling:
        return 'Cycling';
      case ExerciseType.swimming:
        return 'Swimming';
      case ExerciseType.weightlifting:
        return 'Weightlifting';
      case ExerciseType.yoga:
        return 'Yoga';
      case ExerciseType.other:
        return 'Other';
      default:
        return '';
    }
  }
}
