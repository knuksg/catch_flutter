import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalloonFadeIn extends StatefulWidget {
  const BalloonFadeIn({super.key});

  @override
  _BalloonFadeInState createState() => _BalloonFadeInState();
}

class _BalloonFadeInState extends State<BalloonFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 애니메이션 지속 시간
      vsync: this,
    );

    // 0부터 1까지 서서히 증가하는 애니메이션
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _animation, // 애니메이션 적용
        child: Stack(alignment: Alignment.center, children: [
          Image.asset(
            'assets/images/03_main_balloon.png', // 이미지 경로
            width: 436.w, // 원하는 너비 설정
            height: 532.h, // 원하는 높이 설정
          ),
          Align(
            alignment: const Alignment(0.0, -0.05),
            child: Image.asset(
              'assets/images/03_main_emoticon_01.png', // 이미지 경로
              width: 240.w, // 원하는 너비 설정
              height: 240.h, // 원하는 높이 설정
            ),
          ),
        ]),
      ),
    );
  }
}
