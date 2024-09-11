import 'package:catch_flutter/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthNotifier extends StateNotifier<UserProfile?> {
  final AuthService _authService;
  String? _idToken;
  String? uid;
  String? email;
  String? profileImg;
  String? nickname;
  String? gender;
  String? age;
  String? height;
  String? weight;
  String? mbti;
  String? bloodType;

  String? get idToken => _idToken;

  AuthNotifier(this._authService) : super(null) {
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    // Google 로그인 시도
    final GoogleSignInAccount? googleUser = await _authService.signInSilently();

    if (googleUser != null) {
      // ID 토큰 가져오기
      final idToken = await _authService.getIdToken(googleUser);
      _idToken = idToken; // ID 토큰 저장

      // ID 토큰이 있는 경우에만 서버와 통신
      if (_idToken != null) {
        // 서버로 토큰을 보내고 사용자 정보를 받아옴
        final UserProfile? user =
            await _authService.sendTokenToBackend(_idToken!);

        // 사용자 정보를 상태로 업데이트
        state = user;
      } else {
        // ID 토큰이 없을 경우 상태를 null로 설정 (로그인되지 않음)
        state = null;
      }
    } else {
      // Google 사용자가 없을 경우 상태를 null로 설정 (로그인되지 않음)
      state = null;
    }
  }

  Future<void> signInWithGoogle() async {
    // Google 로그인 시도
    final GoogleSignInAccount? googleUser =
        await _authService.signInWithGoogle();
    if (googleUser != null) {
      // ID 토큰 가져오기
      final idToken = await _authService.getIdToken(googleUser);
      _idToken = idToken; // ID 토큰 저장

      // ID 토큰이 있는 경우에만 서버와 통신
      if (_idToken != null) {
        // 서버로 토큰을 보내고 사용자 정보를 받아옴
        final UserProfile? user =
            await _authService.sendTokenToBackend(_idToken!);

        // 사용자 정보를 상태로 업데이트
        state = user;
      } else {
        // ID 토큰이 없을 경우 상태를 null로 설정 (로그인되지 않음)
        state = null;
      }
    } else {
      // Google 사용자가 없을 경우 상태를 null로 설정 (로그인되지 않음)
      state = null;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _idToken = null; // 로그아웃 시 ID 토큰 초기화
    state = null;
  }

  // 유저 정보 업데이트 함수
  void updateUserInfo(
      {String? profileImg,
      String? nickname,
      String? gender,
      String? age,
      String? height,
      String? weight,
      String? mbti,
      String? bloodType}) {
    this.profileImg = profileImg;
    this.nickname = nickname;
    this.gender = gender;
    this.age = age;
    this.height = height;
    this.weight = weight;
    this.mbti = mbti;
    this.bloodType = bloodType;

    _authService.sendUserInfoToBackend(_idToken!, profileImg!, nickname!,
        gender!, age!, height!, weight!, mbti, bloodType);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile?>((ref) {
  return AuthNotifier(AuthService());
});
