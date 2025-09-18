import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// A service class that provides a simplified interface for authentication
///
/// This service acts as a wrapper around FirebaseService to provide a cleaner
/// API for authentication operations
class AuthService {
  final FirebaseService _firebaseService = FirebaseService();

  /// Initialize the auth service
  ///
  /// Firebase is already initialized in main.dart, so this method is kept
  /// for backward compatibility
  Future<void> initialize() async {
    // Firebase is already initialized in main.dart
    // This method is kept for backward compatibility
  }

  /// Sign in with Google
  ///
  /// Returns the authenticated user on successful sign-in, or null if the sign-in
  /// was cancelled or failed
  Future<firebase_auth.User?> signInWithGoogle() async {
    try {
      final userCredential = await _firebaseService.signInWithGoogle();
      return userCredential?.user;
    } catch (e) {
      debugPrint('Error in AuthService.signInWithGoogle: $e');
      return null;
    }
  }

  /// Sign out the current user
  Future<void> signOutGoogle() async {
    await _firebaseService.signOut();
  }

  /// Get the currently authenticated user
  ///
  /// Returns the current Firebase User or null if not authenticated
  firebase_auth.User? getCurrentUser() {
    return _firebaseService.getCurrentUser();
  }

  /// Stream of authentication state changes
  ///
  /// This stream emits the current user when authentication state changes
  Stream<firebase_auth.User?> get onAuthStateChanged => _firebaseService.authStateChanges;
  
  /// Get user role
  ///
  /// [uid] - The user ID to get the role for
  /// Returns the user's role as a string
  Future<String> getUserRole(String uid) async {
    return await _firebaseService.getUserRole(uid);
  }
  
  /// Check if user is admin
  ///
  /// [uid] - The user ID to check
  /// Returns true if the user has admin role, false otherwise
  Future<bool> isAdmin(String uid) async {
    return await _firebaseService.isAdmin(uid);
  }
  
  /// Get user data
  ///
  /// [uid] - The user ID to get data for
  /// Returns a map of user data or null if user not found
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    return await _firebaseService.getUserData(uid);
  }
  
  /// Check if a user is currently authenticated
  ///
  /// Returns true if a user is signed in, false otherwise
  bool get isAuthenticated => _firebaseService.isAuthenticated;
  
  /// Get the current user's UID
  ///
  /// Returns the current user's UID or null if not authenticated
  String? get currentUid => _firebaseService.currentUid;
}