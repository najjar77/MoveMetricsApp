import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

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
      selectedItemColor: Colors.blue,
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
