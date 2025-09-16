import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }
      // Process successful sign-in
      print('Signed in with Google: ${googleUser.displayName}');
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    print('Signed out of Google');
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }

  Stream<GoogleSignInAccount?> get onAuthStateChanged =>
      _googleSignIn.onCurrentUserChanged;
}
