import 'package:flutter_test/flutter_test.dart';
import 'package:ifaa/src/services/firebase_service.dart';

void main() {
  group('FirebaseService Tests', () {
    test('FirebaseService can be instantiated', () {
      final firebaseService = FirebaseService();
      expect(firebaseService, isNotNull);
    });

    test('FirebaseService has required methods', () {
      final firebaseService = FirebaseService();
      
      // Check that the service has the expected methods
      expect(firebaseService.getCurrentUser, isNotNull);
      expect(firebaseService.signInWithGoogle, isNotNull);
      expect(firebaseService.signOut, isNotNull);
      expect(firebaseService.authStateChanges, isNotNull);
      expect(firebaseService.getUserRole, isNotNull);
      expect(firebaseService.isAdmin, isNotNull);
      expect(firebaseService.getUserData, isNotNull);
      expect(firebaseService.isAuthenticated, isNotNull);
      expect(firebaseService.currentUid, isNotNull);
    });
  });
}