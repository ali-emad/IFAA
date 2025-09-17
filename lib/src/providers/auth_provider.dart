import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ifaa/src/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final authService = AuthService();
  authService.initialize();
  return authService;
});