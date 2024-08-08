import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/user_store.dart';
import '../network/service_locator.dart';

class ProfileScreen extends StatelessWidget {
  final UserStore userStore = getIt<UserStore>(); // Zugriff auf den UserStore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(
            builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profilbild
                CircleAvatar(
                  radius: 80, // Größeres Bild
                  backgroundImage: NetworkImage(
                    userStore.avatar ?? 'https://via.placeholder.com/150',
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(height: 20),
                // Benutzername
                Text(
                  userStore.username ?? 'Name nicht verfügbar',
                  style: TextStyle(
                    fontSize: 28, // Größere Schriftart
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Benutzer E-Mail
                Text(
                  userStore.userId ?? 'Email nicht verfügbar',
                  style: TextStyle(
                    fontSize: 18, // Größere Schriftart
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30),
                // Profil bearbeiten
                ElevatedButton(
                  onPressed: () {
                    // Logik zum Bearbeiten des Profils hinzufügen
                  },
                  child: Text('Profil bearbeiten'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
