import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/screens/main_screen.dart';
import 'package:catch_flutter/screens/tutorial_screens/profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/auth_provider.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  var user;
  List<Map<String, dynamic>> _tutorialPages = [];
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user ??= ref.watch(authProvider);

    // 사용자 이메일에 따른 텍스트 제한 적용
    String userEmail = user?.email ?? "Unknown User";
    String truncatedEmail = _truncateText(userEmail, 11); // 최대 11자 제한

    _tutorialPages = [
      {
        'title': [
          {'text': '$truncatedEmail님', 'color': AppColors.blue},
          {'text': '첫 시작 환영해요!', 'color': AppColors.black},
        ],
        'description': [
          {'text': '시작 전에 앱에 대해\n짧게 소개해도 될까요?', 'color': AppColors.black},
        ],
        'buttonText': {'text': '좋아요', 'color': AppColors.green},
      },
      {
        'title': [
          {'text': 'AI 고양이 다리와', 'color': AppColors.blue},
          {'text': '함께 하는 캐치', 'color': AppColors.blue},
        ],
        'description': [
          {'text': '다리', 'color': AppColors.blue},
          {'text': '는 ', 'color': AppColors.black},
          {'text': '$truncatedEmail님', 'color': AppColors.blue},
          {
            'text':
                '의 고민과 바람을 들어주는 가까운 친구 같은 존재예요.\n고민 해결과 바람을 위해서 좋은 정보를 계속 알려주고 올바른 습관을 길러줄 거예요.',
            'color': AppColors.black
          },
        ],
        'buttonText': {'text': '다음', 'color': AppColors.white},
      },
      {
        'title': [
          {'text': '다리에게는', 'color': AppColors.blue},
          {'text': '선물이 필요해', 'color': AppColors.blue},
        ],
        'description': [
          {
            'text':
                '다리는 공짜로 질문에 답해 주거나 정보를 주지 않아요. 다리에게는 놀기 위한 털실이 필요해요. \n털실 속에는 다리가 좋아하는 선물이 숨겨져 있어요.',
            'color': AppColors.black
          },
        ],
        'buttonText': {'text': '다음', 'color': AppColors.white},
      },
      {
        'title': [
          {'text': '다리에게는', 'color': AppColors.blue},
          {'text': '선물이 필요해', 'color': AppColors.blue},
        ],
        'description': [
          {
            'text':
                '털실은 최초 10개가 주어지고 5분에 한 개씩 충전돼요. \n다리에게 질문하거나 정보를 얻을 때마다 털실이 차감되니 이점 꼭 유의하셔야 해요.',
            'color': AppColors.black
          },
        ],
        'buttonText': {'text': '다음', 'color': AppColors.white},
      },
      {
        'title': [
          {'text': '$truncatedEmail님께', 'color': AppColors.blue},
          {'text': '털실 전달했어요~', 'color': AppColors.blue},
        ],
        'description': [
          {'text': '그럼 지금 바로\n캐치를 시작해볼까요?', 'color': AppColors.black},
        ],
        'buttonText': {'text': '캐치 시작', 'color': AppColors.blue},
      },
    ];
  }

  // 텍스트를 특정 길이로 줄이는 함수
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength - 3)}...'; // 일부 텍스트를 생략
    }
  }

  void _nextPage() {
    if (_currentPage < _tutorialPages.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 하단 배경 이미지
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                'assets/images/01_title_cat.png',
                width: 1080.w,
                height: 1014.w,
              ),
            ),
          ),
          // 반투명 배경
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
          // 팝업 컨테이너
          Positioned(
            top: 340.h,
            bottom: 120.h,
            left: 65.w,
            right: 65.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: ClipRect(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _currentPage == 0
                        ? SizedBox(height: 400.h)
                        : SizedBox(height: 200.h),
                    // AnimatedSwitcher로 감싸서 텍스트가 슬라이드 전환되도록 설정
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          // 슬라이드 트랜지션을 왼쪽에서 왼쪽으로 변경
                          final slideOutAnimation = Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: const Offset(0.0, 0.0), // 왼쪽으로 나감
                          ).animate(animation);

                          final slideInAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0), // 오른쪽에서 왼쪽으로 들어옴
                            end: Offset.zero,
                          ).animate(animation);

                          return SlideTransition(
                            position: child.key == ValueKey(_currentPage)
                                ? slideInAnimation
                                : slideOutAnimation,
                            child: child,
                          );
                        },
                        child: _buildTextContent(_currentPage,
                            key: ValueKey<int>(_currentPage)), // 텍스트 컨텐츠 빌드
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_currentPage == 1 ||
                        _currentPage == 2 ||
                        _currentPage == 3)
                      _buildPageIndicator(_currentPage),
                    const SizedBox(height: 20), // 버튼과 인디케이터 간의 간격
                    // 버튼
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tutorialPages[_currentPage]
                            ['buttonText']['color'],
                        minimumSize: Size(900.w, 200.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _tutorialPages[_currentPage]['buttonText']['text'],
                        style: _currentPage == 0 ||
                                _currentPage == _tutorialPages.length - 1
                            ? CustomTextStyle.p100w(context)
                            : CustomTextStyle.p100(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 상단 로고
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/03_main_popup_logo.png', // 로고 이미지 경로
              width: 455.w,
              height: 455.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(int pageIndex, {Key? key}) {
    return Column(
      key: key, // 애니메이션 전환을 위한 키
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 제목 텍스트
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: _tutorialPages[pageIndex]['title']![0]['text'],
                style: CustomTextStyle.p80(context).copyWith(
                  color: _tutorialPages[pageIndex]['title']![0]['color'],
                ),
              ),
              TextSpan(
                text: '\n${_tutorialPages[pageIndex]['title']![1]['text']}',
                style: CustomTextStyle.p100(context).copyWith(
                  color: _tutorialPages[pageIndex]['title']![1]['color'],
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        if (_currentPage == _tutorialPages.length - 1)
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/03_main_ball.png', // 로고 이미지 경로
                    width: 455.w,
                    height: 455.w,
                  ),
                ),
                Positioned(
                  right: 50.w,
                  bottom: 50.w,
                  child: Container(
                    width: 200.w,
                    height: 200.w,
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                    child: Center(
                        child: Text(
                      'X10',
                      style: CustomTextStyle.p80w(context),
                    )),
                  ),
                ),
              ],
            ),
          ),
        _currentPage == 0 ? SizedBox(height: 400.h) : SizedBox(height: 100.h),
        // 설명 텍스트
        Text.rich(
          TextSpan(
            children: _tutorialPages[pageIndex]['description']!
                .map<TextSpan>((desc) => TextSpan(
                      text: desc['text'],
                      style: CustomTextStyle.n80(context).copyWith(
                        color: desc['color'],
                      ),
                    ))
                .toList(),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Widget _buildPageIndicator(int currentPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentPage == index + 1 ? Colors.grey : Colors.white,
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
      );
    }),
  );
}
