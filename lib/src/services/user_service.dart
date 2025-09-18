import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

class UserRole {
  static const String member = 'member';
  static const String admin = 'admin';
  static const String editor = 'editor';
}

class UserService {
  FirebaseFirestore? _firestore;
  
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
        // Create new user document with default role
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? 'Anonymous User',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'joinDate': user.metadata.creationTime ?? FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'role': UserRole.member, // Default role
          'isActive': true,
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
}