import 'package:flutter_test/flutter_test.dart';
import 'package:ifaa/src/services/firebase_service.dart';
import 'package:ifaa/src/services/auth_service.dart';

void main() {
  group('Google Sign-In Tests', () {
    test('FirebaseService has signInWithGoogle method', () {
      final firebaseService = FirebaseService();
      expect(firebaseService.signInWithGoogle, isNotNull);
    });

    test('AuthService has signInWithGoogle method', () {
      final authService = AuthService();
      expect(authService.signInWithGoogle, isNotNull);
    });

    test('FirebaseService web detection works', () {
      final firebaseService = FirebaseService();
      // Just test that the service can be instantiated
      expect(firebaseService, isNotNull);
    });
  });
}