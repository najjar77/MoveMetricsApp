// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExerciseStore on _ExerciseStore, Store {
  late final _$exercisesAtom =
      Atom(name: '_ExerciseStore.exercises', context: context);

  @override
  ObservableList<ExerciseEntry> get exercises {
    _$exercisesAtom.reportRead();
    return super.exercises;
  }

  @override
  set exercises(ObservableList<ExerciseEntry> value) {
    _$exercisesAtom.reportWrite(value, super.exercises, () {
      super.exercises = value;
    });
  }

  late final _$addExerciseAsyncAction =
      AsyncAction('_ExerciseStore.addExercise', context: context);

  @override
  Future<void> addExercise(ExerciseEntry exercise) {
    return _$addExerciseAsyncAction.run(() => super.addExercise(exercise));
  }

  late final _$loadExercisesAsyncAction =
      AsyncAction('_ExerciseStore.loadExercises', context: context);

  @override
  Future<void> loadExercises(String uid) {
    return _$loadExercisesAsyncAction.run(() => super.loadExercises(uid));
  }

  @override
  String toString() {
    return '''
exercises: ${exercises}
    ''';
  }
}
