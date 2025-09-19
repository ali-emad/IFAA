import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

class UserRole {
  static const String member = 'member';
  static const String admin = 'admin';
  static const String editor = 'editor';
}

class UserService {
  final FirebaseFirestore? _firestore;
  
  // Constructor that allows injecting Firestore for testing
  UserService([FirebaseFirestore? firestore]) : _firestore = firestore;

  // Lazy initialization of Firestore
  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  // Create or update user in Firestore when they sign in
  Future<void> createUserDocument(firebase_auth.User user) async {
    try {
      final userDoc = firestore.collection('users').doc(user.uid);
      
      // Check if user document already exists
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        // Create new user document with default role and profile
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? 'Anonymous User',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'joinDate': user.metadata.creationTime ?? FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'role': UserRole.member, // Default role
          'isActive': true,
          'profile': {
            'phone': '',
            'position': '',
            'dateOfBirth': '',
            'experience': '',
            'emergencyContact': '',
          },
        });
      } else {
        // Update last login time
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
          'name': user.displayName ?? docSnapshot.data()?['name'] ?? 'Anonymous User',
          'email': user.email ?? docSnapshot.data()?['email'] ?? '',
          'photoUrl': user.photoURL ?? docSnapshot.data()?['photoUrl'] ?? '',
        });
      }
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error creating/updating user document: ${e.code} - ${e.message}');
      
      // Try to create a minimal user document as fallback
      if (e.code == 'permission-denied') {
        debugPrint('Attempting to create minimal user document due to permissions');
        try {
          final userDoc = firestore.collection('users').doc(user.uid);
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName ?? 'Anonymous User',
            'email': user.email ?? '',
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (fallbackError) {
          debugPrint('Fallback user document creation also failed: $fallbackError');
        }
      }
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error creating/updating user document: $e');
    }
  }

  // Get user role from Firestore
  Future<String> getUserRole(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data()?['role'] ?? UserRole.member;
      }
      return UserRole.member; // Default role if user document doesn't exist
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error getting user role: ${e.code} - ${e.message}');
      
      // Return default role on permission errors
      if (e.code == 'permission-denied') {
        debugPrint('Returning default member role due to permissions');
        return UserRole.member;
      }
      
      return UserRole.member; // Default role on error
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error getting user role: $e');
      return UserRole.member; // Default role on error
    }
  }

  // Check if user is admin
  Future<bool> isAdmin(String uid) async {
    final role = await getUserRole(uid);
    return role == UserRole.admin;
  }

  // Check if user is editor
  Future<bool> isEditor(String uid) async {
    final role = await getUserRole(uid);
    return role == UserRole.editor;
  }

  // Test methods for unit testing
  bool testIsAdmin(String role) {
    return role == UserRole.admin;
  }

  bool testIsEditor(String role) {
    return role == UserRole.editor;
  }

  // Update user profile data
  Future<void> updateUserProfile(String uid, Map<String, dynamic> profileData) async {
    try {
      final userDoc = firestore.collection('users').doc(uid);
      await userDoc.update({
        'profile': profileData,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error updating user profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  // Get all user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
      return null;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error getting user data: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Update user active status (admin only)
  Future<void> updateUserActiveStatus(String uid, bool isActive) async {
    try {
      final userDoc = firestore.collection('users').doc(uid);
      await userDoc.update({
        'isActive': isActive,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error updating user active status: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error updating user active status: $e');
      rethrow;
    }
  }

  // Update user role (admin only)
  Future<void> updateUserRole(String uid, String role) async {
    try {
      final userDoc = firestore.collection('users').doc(uid);
      await userDoc.update({
        'role': role,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error updating user role: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error updating user role: $e');
      rethrow;
    }
  }

  // Payment methods
  
  // Add a new payment record
  Future<String> addPayment(String uid, Map<String, dynamic> paymentData) async {
    try {
      final paymentDoc = await firestore
          .collection('users')
          .doc(uid)
          .collection('payments')
          .add({
        ...paymentData,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending', // Default status
        'approved': false, // Default approval status
      });
      return paymentDoc.id;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error adding payment: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error adding payment: $e');
      rethrow;
    }
  }

  // Get user payments
  Future<List<Map<String, dynamic>>> getUserPayments(String uid) async {
    try {
      final paymentsSnapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('payments')
          .orderBy('createdAt', descending: true)
          .get();
      
      return paymentsSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error getting payments: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error getting payments: $e');
      return [];
    }
  }

  // Update payment status (admin only)
  Future<void> updatePaymentStatus(String uid, String paymentId, String status, bool approved) async {
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('payments')
          .doc(paymentId)
          .update({
        'status': status,
        'approved': approved,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error updating payment status: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error updating payment status: $e');
      rethrow;
    }
  }
  
  // Get all users (admin only)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final usersSnapshot = await firestore
          .collection('users')
          .orderBy('name')
          .get();
      
      return usersSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error getting all users: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      // In production, you might want to use a logging framework instead
      debugPrint('Error getting all users: $e');
      return [];
    }
  }
}