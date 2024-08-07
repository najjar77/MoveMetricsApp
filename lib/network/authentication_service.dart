import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../stores/user_store.dart';
import '../network/service_locator.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserStore userStore = getIt<UserStore>(); // Zugriff auf den UserStore

  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await fetchCurrentUser(); // Benutzerinformationen nach dem Login abrufen
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await fetchCurrentUser(); // Benutzerinformationen nach der Registrierung abrufen
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await userStore.resetUserProfile(); // Benutzerinformationen zurücksetzen
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<void> fetchCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Speichern der Benutzerinformationen im UserStore
      String userId = user.uid;
      String? username = user.displayName ?? user.email?.split('@')[0]; // Nutze den Email-Präfix als Fallback für den Benutzernamen
      String avatar = user.photoURL ?? 'https://via.placeholder.com/150'; // Fallback-Bild

      await userStore.saveUserProfile(userId, username!, avatar);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      // Google Sign-In Logik
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      await fetchCurrentUser(); // Benutzerinformationen nach Google-Login abrufen
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
