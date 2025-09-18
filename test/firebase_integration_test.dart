import 'package:flutter_test/flutter_test.dart';
import 'package:ifaa/src/services/firebase_service.dart';
import 'package:ifaa/src/services/user_service.dart';

void main() {
  group('Firebase Integration Tests', () {
    test('FirebaseService and UserService are properly initialized', () {
      // Test that we can create instances without errors
      final firebaseService = FirebaseService();
      final userService = UserService();
      
      expect(firebaseService, isNotNull);
      expect(userService, isNotNull);
    });

    test('UserRole constants are accessible', () {
      expect(UserRole.member, 'member');
      expect(UserRole.admin, 'admin');
      expect(UserRole.editor, 'editor');
    });
  });
}