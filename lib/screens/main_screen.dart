import 'package:catch_flutter/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 파싱을 위해 필요

import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가
  bool _isVoiceInput = false; // 음성 입력 모드인지 확인하는 플래그

  String _userMessage = "캐치와 대화해보세요.";
  String _chatGptResponse = "잠시만 기다려..."; // 초기 응답 메시지

  @override
  void initState() {
    super.initState();
    _initializeChatInfo();
  }

  void _initializeChatInfo() async {
    final url = Uri.parse('http://flyingstone.me:3000/chat/threadId');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer your-auth-token', // 필요한 경우 인증 토큰 추가
      });
      print(response.body);
      if (response.statusCode == 200) {
        print('Chat info loaded successfully');
        final jsonResponse = json.decode(response.body);
        ref.read(chatProvider.notifier).updateIds(
              assistantId: jsonResponse['assistant_id'],
              threadId: jsonResponse['thread_id'],
            );
      }
    } catch (e) {
      print('Error loading chat info: $e');
    }
  }

  void sendMessage() async {
    final message = _controller.text;
    final chatState = ref.read(chatProvider);

    if (message.isNotEmpty) {
      setState(() {
        _userMessage = message;
        _chatGptResponse = "응답을 기다리는 중...";
        _isVoiceInput = false; // 메시지를 전송할 때 음성 입력 모드 종료
        _controller.clear(); // 메시지 전송 후 텍스트 입력창 비우기
        FocusScope.of(context).unfocus(); // 키보드 내리기
      });

      final url = Uri.parse('http://flyingstone.me:3000/chat/');
      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer your-auth-token', // 필요한 경우 인증 토큰 추가
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "message": message,
            "assistantId": chatState.assistantId,
            "threadId": chatState.threadId,
          }),
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          setState(() {
            _chatGptResponse = jsonResponse["response"]; // ChatGPT의 응답을 업데이트
          });

          // 응답에 포함된 assistantId와 threadId를 저장
          final newAssistantId = jsonResponse['assistantId'];
          final newThreadId = jsonResponse['threadId'];
          ref.read(chatProvider.notifier).updateIds(
                assistantId: newAssistantId,
                threadId: newThreadId,
              );

          // 백엔드에 이 정보를 저장
          await _saveChatInfo(newAssistantId, newThreadId);

          print('Message sent successfully');
          print(response.body);
        } else {
          setState(() {
            _chatGptResponse = "응답을 받을 수 없습니다. 다시 시도하세요.";
          });
          print('Failed to send message: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _chatGptResponse = "오류가 발생했습니다: $e";
        });
        print('Error sending message: $e');
      }
    }
  }

  Future<void> _saveChatInfo(String assistantId, String threadId) async {
    final url = Uri.parse('http://flyingstone.me:3000/chat/threadId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer your-auth-token', // 필요한 경우 인증 토큰 추가
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "assistantId": assistantId,
          "threadId": threadId,
        }),
      );
      if (response.statusCode == 200) {
        print('Chat info saved successfully');
      } else {
        print('Failed to save chat info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving chat info: $e');
    }
  }

  void toggleVoiceInput() {
    setState(() {
      _isVoiceInput = !_isVoiceInput;
      if (_isVoiceInput) {
        FocusScope.of(context).unfocus(); // 음성 입력 모드로 전환 시 키보드 내리기
      } else {
        FocusScope.of(context).requestFocus(_focusNode); // 텍스트 입력 모드로 전환
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final String userEmail = user?.email ?? "Unknown User";

    final isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0; // 키보드가 올라왔는지 감지

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.menu),
          onPressed: () {
            // 햄버거 메뉴 클릭 시의 동작
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isKeyboardVisible) // 키보드가 올라왔을 때 캐릭터와 텍스트를 숨김
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage('assets/images/03_main_user_char_01.png'),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$userEmail님',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '3개월 안에 몸무게 5KG 감량하자',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (!isKeyboardVisible) // 키보드가 올라왔을 때 하단 텍스트를 숨김
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    _userMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CustomPaint(
                    painter: ChatBubblePainter(), // 말풍선 모양 그리기
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        _chatGptResponse,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/images/01_title_cat.png',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _isVoiceInput
                  ? GestureDetector(
                      onTap: toggleVoiceInput,
                      child: Container(
                        height: 100,
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.mic,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mic, color: Colors.green),
                          onPressed: toggleVoiceInput,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode, // FocusNode 연결
                            decoration: InputDecoration(
                              hintText: '원하시는 글자를 입력하세요...',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.red),
                          onPressed: sendMessage,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
