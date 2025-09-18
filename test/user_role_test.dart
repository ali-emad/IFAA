import 'package:flutter_test/flutter_test.dart';
import 'package:ifaa/src/services/user_service.dart';

void main() {
  group('User Role Tests', () {
    test('UserRole constants are defined correctly', () {
      expect(UserRole.member, 'member');
      expect(UserRole.admin, 'admin');
      expect(UserRole.editor, 'editor');
    });

    test('UserService isAdmin method works with member role', () async {
      final userService = UserService();
      
      // Test the logic directly
      final isAdminResult = userService.testIsAdmin('member');
      expect(isAdminResult, false);
    });

    test('UserService isAdmin method works with admin role', () async {
      final userService = UserService();
      
      // Test the logic directly
      final isAdminResult = userService.testIsAdmin('admin');
      expect(isAdminResult, true);
    });

    test('UserService isEditor method works with member role', () async {
      final userService = UserService();
      
      // Test the logic directly
      final isEditorResult = userService.testIsEditor('member');
      expect(isEditorResult, false);
    });

    test('UserService isEditor method works with editor role', () async {
      final userService = UserService();
      
      // Test the logic directly
      final isEditorResult = userService.testIsEditor('editor');
      expect(isEditorResult, true);
    });
  });
}