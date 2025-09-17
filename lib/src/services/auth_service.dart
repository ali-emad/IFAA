import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'firebase_service.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> initialize() async {
    // Firebase is already initialized in main.dart
    // This method is kept for backward compatibility
  }

  Future<firebase_auth.User?> signInWithGoogle() async {
    final userCredential = await _firebaseService.signInWithGoogle();
    return userCredential?.user;
  }

  Future<void> signOutGoogle() async {
    await _firebaseService.signOut();
  }

  firebase_auth.User? getCurrentUser() {
    return _firebaseService.getCurrentUser();
  }

  Stream<firebase_auth.User?> get onAuthStateChanged => _firebaseService.authStateChanges;
}