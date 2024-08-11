import 'package:flutter/material.dart';
import '../server/authentication_service.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Importiere das benutzerdefinierte Widget
import 'profile_screen.dart';
import 'statistic_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste der Bildschirme, die in der Navigationsleiste verfügbar sind
  final List<Widget> _screens = [
    HomeContent(),
    ListScreen(),
    StatisticScreen(),
    ProfileScreen(),
  ];

  // Liste der Titel für die App-Bar
  final List<String> _titles = [
    'Home',
    'My Exercises',
    'Statistics',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await AuthenticationService().signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Dynamischer Titel basierend auf dem ausgewählten Index
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _screens[_selectedIndex],  // Anzeige des aktuell ausgewählten Bildschirms
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,  // Callback zum Wechseln der Tabs
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Willkommen auf der Startseite!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
