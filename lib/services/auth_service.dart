import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  static Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  static Future<void> updateProfile(String displayName, String photoURL) async {
    try {
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.updatePhotoURL(photoURL);
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  static String? getUserDisplayName() {
    return _auth.currentUser?.displayName;
  }

  static String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  static String? getUserUid() {
    return _auth.currentUser?.uid;
  }

  static Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${e.message}');
      return null;
    }
  }

  static Future<User?> registerWithEmailAndPassword(
      String email, String password, String name, String phone) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await updateProfile(name, '');

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error registering user: ${e.message}');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
