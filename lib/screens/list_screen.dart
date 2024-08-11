import 'package:flutter/material.dart';
import '../widgets/custom_list.dart'; // Importiere das CustomList-Widget

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('My Exercises'),
      ),
      body: CustomList(), // Verwende das CustomList-Widget
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/exercise'); // Navigation zum ExerciseScreen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
