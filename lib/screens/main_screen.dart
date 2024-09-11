import 'dart:math';

import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/screens/recommend_screen.dart';
import 'package:catch_flutter/screens/concern_wish_manager_screen.dart';
import 'package:catch_flutter/services/auth_service.dart';
import 'package:catch_flutter/services/chat_service.dart';
import 'package:catch_flutter/services/notification_service.dart';
import 'package:catch_flutter/widgets/chat_bubble.dart';
import 'package:catch_flutter/widgets/main_image_button.dart';
import 'package:catch_flutter/widgets/sidebar.dart';
import 'package:catch_flutter/widgets/top_user_info.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  var user;
  late AuthNotifier authNotifier;
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isVoiceInput = false;

  String _userMessage = "다리와 대화해보세요.";
  String _chatGptResponse = "프로필이 등록 되어서 위쪽에 정보가 잘 표시되고 있어. ";

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // initState에서 context나 ref.watch를 사용하지 않습니다.
    authNotifier = ref.read(authProvider.notifier);
    _notificationService.initialize(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 이미 초기화된 경우 초기화를 건너뜀
    if (user == null) {
      user = ref.watch(authProvider); // 안전하게 user 초기화
      _initializeChatInfo();
    }
  }

  void _initializeChatInfo() async {
    final idToken = authNotifier.idToken;
    final chatInfo = await _chatService.initializeChatInfo(idToken!);

    if (chatInfo.isNotEmpty) {
      ref.read(chatProvider.notifier).updateIds(
            assistantId: chatInfo['assistant_id'],
            threadId: chatInfo['thread_id'],
          );
    }
  }

  // 알림 예약 예시
  void _scheduleNotification() {
    _notificationService.scheduleRepeatingTextNotification(
      'Daily Reminder', // 알림 제목
      'This is your daily reminder!', // 알림 본문
      DateTime.now().subtract(const Duration(days: 1)), // 알림 시작 날짜
      DateTime.now().add(const Duration(days: 1)), // 알림 종료 날짜
      TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().add(const Duration(minutes: 1)).minute,
      ), // 알림 시간
      _notificationService.generateNotificationId(), // 알림 ID
    );
  }

  void sendMessage() async {
    final message = _controller.text;
    final chatState = ref.read(chatProvider);
    final idToken = authNotifier.idToken;

    if (message.isNotEmpty) {
      setState(() {
        _userMessage = message;
        _chatGptResponse = "응답을 기다리는 중...";
        _isVoiceInput = false;
        _controller.clear();
        FocusScope.of(context).unfocus();
      });

      final response = await _chatService.sendMessage(
          message, chatState.assistantId, chatState.threadId, idToken!);

      print(response);

      setState(() {
        _chatGptResponse = response["response"] ?? "응답을 받을 수 없습니다.";
      });

      if (response.containsKey('assistantId') &&
          response.containsKey('threadId')) {
        final newAssistantId = response['assistantId'];
        final newThreadId = response['threadId'];
        ref.read(chatProvider.notifier).updateIds(
              assistantId: newAssistantId,
              threadId: newThreadId,
            );

        await _chatService.saveChatInfo(newAssistantId, newThreadId, idToken);
      }
    }
  }

  void toggleVoiceInput() {
    setState(() {
      _isVoiceInput = !_isVoiceInput;
      if (_isVoiceInput) {
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom > 0
        ? MediaQuery.of(context).viewInsets.bottom
        : 250.0; // 기본 키보드 높이 추정치

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: SideBar(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/03_main_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/03_main_logo.png',
                  width: 254.w,
                  height: 124.w,
                ),
              )),
          // 상단 사용자 정보 영역
          Positioned(
            top: kToolbarHeight + 24,
            left: 0,
            right: 0,
            child: TopUserInfoWidget(user: user),
          ),
          Positioned(
            top: kToolbarHeight + min(500.h, 350.w),
            left: 0,
            right: 0,
            child: Align(
                alignment: Alignment.centerLeft,
                child: ChatBubble(message: _userMessage)),
          ),
          Positioned(
            bottom: _isVoiceInput
                ? keyboardHeight + 180.w
                : isKeyboardVisible
                    ? 90.w
                    : 0.w,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: 500.w,
                  child: Center(
                      child: ChatBubble(
                    message: _chatGptResponse,
                    isUser: false,
                  )),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/01_title_cat.png', // 고양이 이미지 설정
                    width: _isVoiceInput || isKeyboardVisible ? 284.w : 1080.w,
                    height: _isVoiceInput || isKeyboardVisible ? 267.h : 1014.h,
                  ),
                ),
              ],
            ),
          ),

          // 메인 고양이 이미지
          Positioned(
            top: min(500.w, 670.h),
            left: 0,
            right: 10,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ImageButtonWidget(
                  imagePath: 'assets/images/03_main_menu_icon_01.png',
                  text: '고민/위시 관리',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ConcernWishManagerScreen()));
                  }),
              const SizedBox(height: 20),
              ImageButtonWidget(
                  imagePath: 'assets/images/03_main_menu_icon_02.png',
                  text: '다리의 추천 상품',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecommendScreen()));
                  }),
              const SizedBox(height: 20),
              ImageButtonWidget(
                  imagePath: 'assets/images/03_main_menu_icon_03.png',
                  text: '내 행동 그래프',
                  onPressed: _scheduleNotification),
            ]),
          ),
          // 하단 마이크 및 텍스트 입력 영역
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _isVoiceInput ? 1143.h : 192.h,
              color: Colors.black.withOpacity(0.8),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (!_isVoiceInput)
                        InkWell(
                          onTap: toggleVoiceInput,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: 124.h,
                                height: 124.h,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset(
                                  'assets/images/03_main_mic_icon.png',
                                )),
                          ),
                        ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: _isVoiceInput || isKeyboardVisible
                                ? ''
                                : '영역을 터치하여 다리와 대화 하세요',
                            hintStyle: CustomTextStyle.p42(context)
                                .copyWith(color: Colors.grey),
                          ),
                          style: CustomTextStyle.p42w(context),
                        ),
                      ),
                      InkWell(
                        onTap: sendMessage,
                        child: Image.asset(
                          'assets/images/03_main_send_icon_01.png',
                          width: 86.w,
                        ),
                      )
                    ],
                  ),
                  if (_isVoiceInput) ...[
                    Container(
                      width: 1080.w,
                      height: 950.h,
                      color: const Color(0xFF171719),
                      child: Stack(children: [
                        Positioned(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              'assets/images/03_main_vocui_emp.png',
                              height: 700.h,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 50.h,
                          child: Column(
                            children: [
                              Text('음성 인식이 잘 되도록',
                                  style: CustomTextStyle.p60w(context)),
                              Text('마이크에 가까이 대고 말하세요.',
                                  style: CustomTextStyle.p42w(context)),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
