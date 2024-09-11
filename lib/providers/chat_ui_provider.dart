import 'package:flutter_riverpod/flutter_riverpod.dart';

// 상태 관리 클래스 정의
class InputModeNotifier extends StateNotifier<Map<String, bool>> {
  InputModeNotifier() : super({'isVoiceInput': false, 'isTextInput': false});

  void toggleVoiceInput() {
    state = {
      'isVoiceInput': !state['isVoiceInput']!,
      'isTextInput': false,
    };
  }

  void toggleTextInput() {
    state = {
      'isVoiceInput': false,
      'isTextInput': !state['isTextInput']!,
    };
  }
}

// 상태 프로바이더 정의
final inputModeProvider =
    StateNotifierProvider<InputModeNotifier, Map<String, bool>>((ref) {
  return InputModeNotifier();
});
