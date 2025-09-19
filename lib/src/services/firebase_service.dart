import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'user_service.dart';

/// A service class that handles Firebase authentication and user management
///
/// This service provides methods for Google sign-in, sign-out, and user data management
/// It uses dependency injection for better testability and follows the singleton pattern
/// for Firebase instances
class FirebaseService {
  final firebase_auth.FirebaseAuth? _auth;
  final UserService? _userService;
  
  /// Constructor that allows injecting dependencies for testing
  ///
  /// [auth] - Firebase Auth instance (defaults to FirebaseAuth.instance)
  /// [userService] - User service instance (defaults to UserService())
  FirebaseService([
    firebase_auth.FirebaseAuth? auth,
    UserService? userService,
  ])  : _auth = auth,
        _userService = userService;

  /// Lazy initialization of Firebase Auth
  firebase_auth.FirebaseAuth get auth => _auth ?? firebase_auth.FirebaseAuth.instance;
  

  
  /// Lazy initialization of User Service
  UserService get userService => _userService ?? UserService();

  /// Sign in with Google using Firebase Auth
  ///
  /// Returns a UserCredential on successful authentication, or null if the sign-in
  /// was cancelled or failed
  Future<firebase_auth.UserCredential?> signInWithGoogle() async {
    try {
      // Create a new GoogleAuthProvider instance
      final googleProvider = firebase_auth.GoogleAuthProvider();
      
      // Add scopes if needed
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      
      // For web, we use signInWithPopup
      if (kIsWeb) {
        // Set custom parameters for web
        googleProvider.setCustomParameters({
          'login_hint': 'user@example.com',
        });
        
        // For web, we use signInWithPopup
        final userCredential = await auth.signInWithPopup(googleProvider);
        
        // Create or update user document in Firestore
        if (userCredential.user != null) {
          await userService.createUserDocument(userCredential.user!);
        }
        
        return userCredential;
      } else {
          // Use Firebase Auth's built-in Google Sign-In for all platforms
        final userCredential = await auth.signInWithPopup(googleProvider);
        
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

  /// Sign out the current user from Firebase
  Future<void> signOut() async {
    try {
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
  
  /// Update user profile
  ///
  /// [uid] - The user ID to update
  /// [profileData] - The profile data to update
  Future<void> updateUserProfile(String uid, Map<String, dynamic> profileData) async {
    await userService.updateUserProfile(uid, profileData);
  }
  
  /// Add a payment for a user
  ///
  /// [uid] - The user ID
  /// [paymentData] - The payment data to add
  Future<String> addPayment(String uid, Map<String, dynamic> paymentData) async {
    return await userService.addPayment(uid, paymentData);
  }
  
  /// Get user payments
  ///
  /// [uid] - The user ID
  Future<List<Map<String, dynamic>>> getUserPayments(String uid) async {
    return await userService.getUserPayments(uid);
  }
  
  /// Update payment status (admin only)
  ///
  /// [uid] - The user ID
  /// [paymentId] - The payment ID
  /// [status] - The new status
  /// [approved] - Whether the payment is approved
  Future<void> updatePaymentStatus(String uid, String paymentId, String status, bool approved) async {
    await userService.updatePaymentStatus(uid, paymentId, status, approved);
  }
  
  /// Update user active status (admin only)
  ///
  /// [uid] - The user ID
  /// [isActive] - The new active status
  Future<void> updateUserActiveStatus(String uid, bool isActive) async {
    await userService.updateUserActiveStatus(uid, isActive);
  }

  /// Update user role (admin only)
  ///
  /// [uid] - The user ID
  /// [role] - The new role
  Future<void> updateUserRole(String uid, String role) async {
    await userService.updateUserRole(uid, role);
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