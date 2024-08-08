import 'package:flutter/material.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final Function(String) onAvatarSelected;

  AvatarSelectionScreen({required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avatar auswählen'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () {
              onAvatarSelected('assets/Avatar1.png');
              Navigator.pop(context);
            },
            child: Image.asset('assets/Avatar1.png'),
          ),
          GestureDetector(
            onTap: () {
              onAvatarSelected('assets/Avatar2.png');
              Navigator.pop(context);
            },
            child: Image.asset('assets/Avatar2.png'),
          ),
        ],
      ),
    );
  }
}
