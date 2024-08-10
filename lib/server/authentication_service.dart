import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../stores/user_store.dart';
import 'service_locator.dart';
import 'db_services.dart'; // Importiere den DB-Service

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserStore userStore = getIt<UserStore>();
  final DBServices dbServices = DBServices(); // Erstelle eine Instanz des DB-Service

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // Überprüfe, ob der Benutzer bereits in der Datenbank vorhanden ist
        bool userExists = await dbServices.isUserInDatabase(user.uid);
        if (!userExists) {
          await dbServices.saveUserToDatabase(user); // Speichere den Benutzer in der Datenbank
        }
        await fetchCurrentUser(); // Benutzerinformationen nach dem Login abrufen
      }
      return true;
    } catch (e) {
      print('Fehler beim Anmelden: $e');
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await dbServices.saveUserToDatabase(user); // Speichere den neuen Benutzer in der Datenbank
        await fetchCurrentUser();
      }
      return true;
    } catch (e) {
      print('Fehler bei der Registrierung: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await userStore.resetUserProfile();
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<void> fetchCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Abrufen der Benutzerdaten aus der Datenbank
      Map<String, dynamic>? userData = await dbServices.fetchUserFromDatabase(user.uid);

      if (userData != null) {
        // Speichern der Benutzerinformationen im UserStore
        String userId = userData['userId'];
        String username = userData['username'];
        String avatar = userData['avatar'];

        await userStore.saveUserProfile(userId, username, avatar);
      } else {
        // Fallback falls keine Daten gefunden wurden
        String userId = user.uid;
        String? username = user.displayName ?? user.email?.split('@')[0];
        String avatar = user.photoURL ?? 'https://via.placeholder.com/150';

        await userStore.saveUserProfile(userId, username!, avatar);
      }
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        // Überprüfe, ob der Benutzer bereits in der Datenbank vorhanden ist
        bool userExists = await dbServices.isUserInDatabase(user.uid);
        if (!userExists) {
          await dbServices.saveUserToDatabase(user); // Speichere den Benutzer in der Datenbank
        }
        await fetchCurrentUser(); // Benutzerinformationen nach dem Login abrufen
      }
      return true;
    } catch (e) {
      print('Fehler bei der Google-Anmeldung: $e');
      return false;
    }
  }
}
