import 'package:flutter_test/flutter_test.dart';
import 'package:ifaa/src/services/firebase_service.dart';

void main() {
  group('FirebaseService Integration Tests', () {
    late FirebaseService firebaseService;

    setUp(() {
      firebaseService = FirebaseService();
    });

    test('FirebaseService can be instantiated with default dependencies', () {
      expect(firebaseService, isNotNull);
      expect(firebaseService.auth, isNotNull);
      expect(firebaseService.googleSignIn, isNotNull);
      expect(firebaseService.userService, isNotNull);
    });

    test('FirebaseService has all required methods', () {
      // Verify all public methods exist
      expect(firebaseService.signInWithGoogle, isNotNull);
      expect(firebaseService.signOut, isNotNull);
      expect(firebaseService.getCurrentUser, isNotNull);
      expect(firebaseService.authStateChanges, isNotNull);
      expect(firebaseService.getUserRole, isNotNull);
      expect(firebaseService.isAdmin, isNotNull);
      expect(firebaseService.getUserData, isNotNull);
      expect(firebaseService.isAuthenticated, isNotNull);
      expect(firebaseService.currentUid, isNotNull);
    });
  });
}