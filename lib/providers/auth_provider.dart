import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthNotifier extends StateNotifier<GoogleSignInAccount?> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(null) {
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    final user = await _authService.signInSilently();
    state = user;
  }

  Future<void> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    state = user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, GoogleSignInAccount?>((ref) {
  return AuthNotifier(AuthService());
});
