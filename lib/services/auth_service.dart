import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  // 자동 로그인 시도
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      final user = await _googleSignIn.signInSilently();
      if (user != null) {
        // GoogleSignInAuthentication 객체를 가져옴
        final GoogleSignInAuthentication googleAuth = await user.authentication;

        // ID 토큰을 얻음
        final String? idToken = googleAuth.idToken;
        print('accessToken: ${googleAuth.accessToken}');
        print('idToken: $idToken');
        if (idToken != null) {
          await _sendTokenToBackend(idToken);
        }
      }
      return user;
    } catch (error) {
      print('Google Silent Sign-In Error: $error');
      return null;
    }
  }

  // Google 로그인
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // GoogleSignInAuthentication 객체를 가져옴
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // ID 토큰을 얻음
        final String? idToken = googleAuth.idToken;
        print('idToken: $idToken');
        if (idToken != null) {
          await _sendTokenToBackend(idToken);
        }
      }
      return googleUser;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  // 서버로 ID 토큰 전송
  Future<void> _sendTokenToBackend(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://flyingstone.me:3000/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Failed to log in or register user: ${response.body}');
      } else {
        print('User logged in or registered successfully: ${response.body}');
      }
    } catch (error) {
      print('Error sending token to backend: $error');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
