import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'user_service.dart';

/// A service class that handles Firebase authentication and user management
///
/// This service provides methods for Google sign-in, sign-out, and user data management
/// It uses dependency injection for better testability and follows the singleton pattern
/// for Firebase instances
class FirebaseService {
  final firebase_auth.FirebaseAuth? _auth;
  final GoogleSignIn? _googleSignIn;
  final UserService? _userService;
  
  /// Constructor that allows injecting dependencies for testing
  ///
  /// [auth] - Firebase Auth instance (defaults to FirebaseAuth.instance)
  /// [googleSignIn] - Google Sign In instance (defaults to GoogleSignIn())
  /// [userService] - User service instance (defaults to UserService())
  FirebaseService([
    firebase_auth.FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    UserService? userService,
  ])  : _auth = auth,
        _googleSignIn = googleSignIn,
        _userService = userService;

  /// Lazy initialization of Firebase Auth
  firebase_auth.FirebaseAuth get auth => _auth ?? firebase_auth.FirebaseAuth.instance;
  
  /// Lazy initialization of Google Sign In
  GoogleSignIn get googleSignIn => _googleSignIn ?? GoogleSignIn();
  
  /// Lazy initialization of User Service
  UserService get userService => _userService ?? UserService();

  /// Sign in with Google using Firebase Auth
  ///
  /// Returns a UserCredential on successful authentication, or null if the sign-in
  /// was cancelled or failed
  Future<firebase_auth.UserCredential?> signInWithGoogle() async {
    try {
      // For web, we need to use a different approach due to popup restrictions
      if (kIsWeb) {
        // Create a new GoogleAuthProvider instance
        final googleProvider = firebase_auth.GoogleAuthProvider();
        
        // Add scopes if needed
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        
        // Set custom parameters for web
        googleProvider.setCustomParameters({
          'login_hint': 'user@example.com',
        });
        
        // For web, we use signInWithPopup or signInWithRedirect
        final userCredential = await auth.signInWithPopup(googleProvider);
        
        // Create or update user document in Firestore
        if (userCredential.user != null) {
          await userService.createUserDocument(userCredential.user!);
        }
        
        return userCredential;
      } else {
        // For mobile platforms, use the traditional approach
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        
        if (googleUser == null) {
          // The user canceled the sign-in
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = 
            await googleUser.authentication;

        // Create a new credential
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        final userCredential = await auth.signInWithCredential(credential);
        
        // Create or update user document in Firestore
        if (userCredential.user != null) {
          await userService.createUserDocument(userCredential.user!);
        }
        
        return userCredential;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      // Show a user-friendly error message
      if (e.code == 'configuration-not-found') {
        debugPrint('Firebase configuration error. Please check your Firebase setup.');
      } else if (e.code == 'popup-closed-by-user') {
        debugPrint('Sign-in popup was closed by user.');
      } else if (e.code == 'cancelled-popup-request') {
        debugPrint('Sign-in popup request was cancelled.');
      } else {
        debugPrint('Authentication failed: ${e.message}');
      }
      return null;
    } on Exception catch (e) {
      debugPrint('General error during Google Sign-In: $e');
      return null;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Unexpected error signing in with Google: $e');
      return null;
    }
  }

  /// Sign out the current user from both Google and Firebase
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  /// Get the currently authenticated user
  ///
  /// Returns the current Firebase User or null if not authenticated
  firebase_auth.User? getCurrentUser() {
    return auth.currentUser;
  }

  /// Stream of authentication state changes
  ///
  /// This stream emits the current user when authentication state changes
  Stream<firebase_auth.User?> get authStateChanges => auth.authStateChanges();
  
  /// Get the role of a user by their UID
  ///
  /// [uid] - The user ID to get the role for
  /// Returns the user's role as a string
  Future<String> getUserRole(String uid) async {
    return await userService.getUserRole(uid);
  }
  
  /// Check if a user is an admin
  ///
  /// [uid] - The user ID to check
  /// Returns true if the user has admin role, false otherwise
  Future<bool> isAdmin(String uid) async {
    return await userService.isAdmin(uid);
  }
  
  /// Get all user data from Firestore
  ///
  /// [uid] - The user ID to get data for
  /// Returns a map of user data or null if user not found
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    return await userService.getUserData(uid);
  }
  
  /// Check if a user is currently authenticated
  ///
  /// Returns true if a user is signed in, false otherwise
  bool get isAuthenticated => getCurrentUser() != null;
  
  /// Get the current user's UID
  ///
  /// Returns the current user's UID or null if not authenticated
  String? get currentUid => getCurrentUser()?.uid;
}