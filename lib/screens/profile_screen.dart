import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/user_store.dart';
import '../network/service_locator.dart';
import '../network/db_services.dart';
import 'avatar_selection_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserStore userStore = getIt<UserStore>(); // Zugriff auf den UserStore
  final DBServices dbServices = DBServices(); // Instanz von DBServices

  void _updateAvatar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarSelectionScreen(
          onAvatarSelected: (String avatarPath) async {
            await userStore.updateAvatar(avatarPath); // Aktualisieren Sie den Avatar im UserStore
            await dbServices.updateUserAvatar(userStore.userId!, avatarPath); // Aktualisieren Sie den Avatar in der Datenbank
          },
        ),
      ),
    );
  }

  ImageProvider _getAvatarImage(String? avatar) {
    if (avatar != null && avatar.startsWith('http')) {
      return NetworkImage(avatar);
    } else if (avatar != null) {
      return AssetImage(avatar);
    } else {
      return AssetImage('assets/Avatar1.png'); // Standardavatar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profilbild
              CircleAvatar(
                radius: 80, // Größeres Bild
                backgroundImage: _getAvatarImage(userStore.avatar),
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
                  _updateAvatar(context);
                },
                child: Text('Profilbild ändern'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
