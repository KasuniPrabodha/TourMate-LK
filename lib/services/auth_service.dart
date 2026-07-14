import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Handles Firebase Auth (email/password) and stores the user's profile
// in Firestore. Returns null on success, or an error message on failure,
// so pages can just show that message in a SnackBar.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _db.collection('users').doc(credential.user!.uid).set({
        'fullName': fullName,
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Signup failed';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() => _auth.signOut();

  // CHANGED: fetches the signed-in user's fullName from Firestore (saved
  // during signup) and returns just the first word of it.
  Future<String> getCurrentUserFirstName() async {
    final user = _auth.currentUser;
    if (user == null) return 'Traveller';
    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      final fullName = (doc.data()?['fullName'] as String?)?.trim() ?? '';
      if (fullName.isEmpty) return 'Traveller';
      return fullName.split(' ').first;
    } catch (_) {
      return 'Traveller';
    }
  }
}
