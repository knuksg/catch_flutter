import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatState {
  final String? assistantId;
  final String? threadId;

  ChatState({this.assistantId, this.threadId});

  ChatState copyWith({String? assistantId, String? threadId}) {
    return ChatState(
      assistantId: assistantId ?? this.assistantId,
      threadId: threadId ?? this.threadId,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState());

  void updateIds({String? assistantId, String? threadId}) {
    state = state.copyWith(assistantId: assistantId, threadId: threadId);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
