import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Überprüfen, ob ein Benutzer bereits in der Datenbank vorhanden ist
  Future<bool> isUserInDatabase(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();
      return snapshot.exists;
    } catch (e) {
      print('Fehler beim Überprüfen des Benutzers in der Datenbank: $e');
      return false;
    }
  }

  // Speichern eines neuen Benutzers in der users-Sammlung
  Future<void> saveUserToDatabase(User user) async {
    try {
      String userId = user.uid;
      String username = user.displayName ?? user.email!.split('@')[0]; // Nutze den Email-Präfix als Fallback
      String email = user.email!;
      String avatar = user.photoURL ?? 'https://via.placeholder.com/150'; // Standardbild, falls kein Foto vorhanden

      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'username': username,
        'email': email,
        'avatar': avatar,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Benutzer erfolgreich in der Datenbank gespeichert.');
    } catch (e) {
      print('Fehler beim Speichern des Benutzers in der Datenbank: $e');
    }
  }

  // Benutzeravatar aktualisieren
  Future<void> updateUserAvatar(String userId, String avatarUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'avatar': avatarUrl,
      });

      print('Benutzeravatar erfolgreich aktualisiert.');
    } catch (e) {
      print('Fehler beim Aktualisieren des Benutzeravatars: $e');
    }
  }

  // Abrufen von Benutzerdaten aus der users-Sammlung
  Future<Map<String, dynamic>?> fetchUserFromDatabase(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        print('Benutzerdaten erfolgreich abgerufen.');
        return snapshot.data();
      } else {
        print('Benutzerdaten nicht gefunden.');
        return null;
      }
    } catch (e) {
      print('Fehler beim Abrufen der Benutzerdaten: $e');
      return null;
    }
  }
}
