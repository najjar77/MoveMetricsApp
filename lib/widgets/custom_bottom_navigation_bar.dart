import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped; // Callback für den Tab-Wechsel

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        _buildBottomNavigationBarItem(
          icon: Icons.home,
          label: 'Home',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.list,
          label: 'Liste',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.bar_chart,
          label: 'Statistik',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.person,
          label: 'Profil',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
