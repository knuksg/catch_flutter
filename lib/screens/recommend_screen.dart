import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _easeInController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 광고 시간 컨트롤러
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..forward();

    _controller.addListener(() {
      setState(() {});
    });

    // EaseIn CurvedAnimation
    _easeInController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // CurvedAnimation을 사용하여 보다 자연스러운 애니메이션 효과를 추가
    _animation =
        CurvedAnimation(parent: _easeInController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double animationValue = _controller.value;
    // const double animationValue = 0.76;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80.0.h), // 상태바와의 여백
            child: Text(
              '다리의 추천 상품',
              style: CustomTextStyle.p60w(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Video Background
          Positioned.fill(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/05_recommend_bg.png', // Replace with actual video asset
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 5~16초
          if (animationValue > 0.25 && animationValue <= 0.76)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(0.0, 2.0),
                  ).animate(CurvedAnimation(
                      parent: _controller, curve: const Interval(0.75, 0.76))),
                  child: AnimatedOpacity(
                    opacity: 1.0, // 목표 오퍼시티
                    duration: const Duration(seconds: 13), // 애니메이션 지속 시간
                    curve: Curves.easeIn, // 애니메이션 속도 곡선
                    child: Container(
                        width: 1080.w,
                        height: 477.h,
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.asset(
                                      'assets/images/05_recommnend_product.png', // Replace with actual concern image asset
                                      width: 331.w,
                                      height: 222.h,
                                    ),
                                    Positioned(
                                      top: 30.w,
                                      right: 30.h,
                                      child: Image.asset(
                                        'assets/images/05_recommnend_logo.png', // Replace with actual concern image asset
                                        width: 87.w,
                                        height: 33.h,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('크로스 엑스 418',
                                        style: CustomTextStyle.p60w(context)),
                                    Text('프로스펙스 | 데일리 운동화',
                                        style: CustomTextStyle.p35w(context)),
                                  ],
                                ),
                              ],
                            ),
                            if (animationValue > 0.25 && animationValue <= 0.5)
                              Expanded(
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1.0),
                                    end: const Offset(0, 0),
                                  ).animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: const Interval(0.25, 0.30))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 20.h),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text('고민',
                                              style: CustomTextStyle.p25w(
                                                  context))),
                                      SizedBox(width: 20.w),
                                      Text("살이 너무 쪄서 고민이에요.",
                                          style: CustomTextStyle.p60w(context)),
                                    ],
                                  ),
                                ),
                              ),
                            if (animationValue > 0.5 && animationValue <= 0.51)
                              Expanded(
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.0),
                                    end: const Offset(0, 2.0),
                                  ).animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: const Interval(0.5, 0.51))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 20.h),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text('고민',
                                              style: CustomTextStyle.p25w(
                                                  context))),
                                      SizedBox(width: 20.w),
                                      Text("살이 너무 쪄서 고민이에요.",
                                          style: CustomTextStyle.p60w(context)),
                                    ],
                                  ),
                                ),
                              ),
                            if (animationValue > 0.51 && animationValue <= 0.75)
                              Expanded(
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1.0),
                                    end: const Offset(0, 0.0),
                                  ).animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: const Interval(0.51, 0.6))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 20.h),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              border: Border.all(
                                                  color: AppColors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text('목표',
                                              style: CustomTextStyle.p25w(
                                                  context))),
                                      SizedBox(width: 20.w),
                                      Text("하루 1만보 걷기를 위한 추천.",
                                          style: CustomTextStyle.p60w(context)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ),
                )),

          //15~20초
          if (animationValue > 0.75)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          if (animationValue > 0.75)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: const Offset(0, 0),
                ).animate(CurvedAnimation(
                    parent: _controller, curve: const Interval(0.75, 0.76))),
                child: Image.asset(
                  'assets/images/05_recommnend_product.png', // Replace with actual product image asset
                  width: 1000.w,
                ),
              ),
            ),

          if (animationValue > 0.85)
            Positioned(
              left: 50.w,
              right: 50.w,
              bottom: 300.h,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 2.0),
                  end: const Offset(0, 0),
                ).animate(CurvedAnimation(
                    parent: _controller, curve: const Interval(0.85, 0.90))),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecommendScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(900.w, 300.h),
                  ),
                  child: Text(
                    '바로 가기',
                    style: CustomTextStyle.p100w(context),
                  ),
                ),
              ),
            ),
          if (animationValue > 0.92)
            Positioned(
              left: 50.w,
              right: 50.w,
              bottom: 50.h,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/05_recommnend_alarm_01.png', // Replace with actual product image asset
                      width: 55.w,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '알람 배경으로 등록',
                          style: CustomTextStyle.p50(context).copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Time Progress Bar (0-5 seconds)
          if (animationValue <= 0.75)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: animationValue / 0.75,
                backgroundColor: Colors.transparent,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
