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
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    userStore.avatar ?? 'https://via.placeholder.com/150',
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(height: 20),
                Text(
                  userStore.username ?? 'Name nicht verfügbar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  userStore.userId ?? 'Email nicht verfügbar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
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
