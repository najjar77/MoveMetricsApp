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
    final ThemeData theme = Theme.of(context);        
    final ColorScheme colorScheme = theme.colorScheme;

    
    return BottomNavigationBar(
      items: [
        _buildBottomNavigationBarItem(
          icon: Icons.home,
          label: 'Home',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.list,
          label: 'My Data',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.bar_chart,
          label: 'Statistics',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.person,
          label: 'Profil',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
      backgroundColor: colorScheme.background,
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
