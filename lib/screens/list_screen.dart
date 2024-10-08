import 'package:flutter/material.dart';
import '../widgets/custom_list.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomList(), // Der Inhalt der Liste
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/exercise');
            },
            backgroundColor: Theme.of(context).primaryColor, // Verwende die primäre Farbe aus dem Theme
            foregroundColor: Colors.white, // Setze die Farbe des Icons auf Weiß
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
