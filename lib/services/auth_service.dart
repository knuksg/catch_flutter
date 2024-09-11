import 'package:catch_flutter/models/user_model.dart';
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
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signInSilently();
      return googleUser;
    } catch (error) {
      print('Google Silent Sign-In Error: $error');
      return null;
    }
  }

  // Google 로그인
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  // 서버로 ID 토큰 전송하고 UserProfile 반환
  Future<UserProfile?> sendTokenToBackend(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://flyingstone.me:3000/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 서버 응답을 JSON으로 파싱
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('user')) {
          // JSON 데이터에서 UserProfile 객체 생성
          final userProfile = UserProfile.fromJson(responseData['user']);
          print('User logged in or registered successfully: ${response.body}');
          return userProfile; // UserProfile 객체 반환
        } else {
          print('Unexpected response format: ${response.body}');
          return null;
        }
      } else {
        print('Failed to log in or register user: ${response.body}');
        return null; // 오류 발생 시 null 반환
      }
    } catch (error) {
      print('Error sending token to backend: $error');
      return null; // 예외 발생 시 null 반환
    }
  }

  Future<String?> getIdToken(GoogleSignInAccount user) async {
    try {
      final GoogleSignInAuthentication googleAuth = await user.authentication;
      return googleAuth.idToken;
    } catch (error) {
      print('Error retrieving ID token: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // 서버로 사용자 정보 전송하고 UserProfile 반환
  Future<UserProfile?> sendUserInfoToBackend(
    String idToken,
    String profileImg,
    String nickname,
    String gender,
    String age,
    String height,
    String weight,
    String? mbti,
    String? bloodType,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://flyingstone.me:3000/auth/userinfo'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'profile_img': profileImg,
          'nickname': nickname,
          'gender': gender,
          'age': age,
          'height': height,
          'weight': weight,
          'mbti': mbti,
          'blood_type': bloodType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 서버 응답을 JSON으로 파싱
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('user')) {
          // JSON 데이터에서 UserProfile 객체 생성
          final userProfile = UserProfile.fromJson(responseData['user']);
          print('User info sent successfully: ${response.body}');
          return userProfile; // UserProfile 객체 반환
        } else {
          print('Unexpected response format: ${response.body}');
          return null;
        }
      } else {
        print('Failed to send user info: ${response.body}');
        return null; // 오류 발생 시 null 반환
      }
    } catch (error) {
      print('Error sending user info to backend: $error');
      return null; // 예외 발생 시 null 반환
    }
  }
}
