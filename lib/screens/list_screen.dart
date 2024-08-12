import 'package:flutter/material.dart';
import '../widgets/custom_list.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ),
      body: CustomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/exercise');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
