import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/providers/auth_provider.dart';
import 'package:catch_flutter/providers/worry_porvider.dart'; // worryProvider import
import 'package:catch_flutter/screens/concern_screens/concern_detail_screen.dart';
import 'package:catch_flutter/widgets/top_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConcernSelectScreen extends ConsumerStatefulWidget {
  const ConcernSelectScreen({super.key});

  @override
  ConsumerState createState() => _ConcernSelectScreenState();
}

class _ConcernSelectScreenState extends ConsumerState<ConcernSelectScreen> {
  var user;
  int selectedConcernIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 사용자 정보 초기화
    user ??= ref.watch(authProvider);

    // 고민 리스트가 비어 있을 경우에만 서버에서 데이터를 가져옵니다.
    if (ref.read(worryProvider).worryList.isEmpty) {
      // 상태 변경 작업을 위젯 트리 빌드 후에 수행
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(worryProvider.notifier).loadWorryList(); // 고민 리스트를 로드
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final worryState = ref.watch(worryProvider); // worryProvider의 상태를 구독

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: Colors.white))
        ],
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80.0.h), // 상태바와의 여백
            child: Text('고민 선택', style: CustomTextStyle.p60w(context)),
          ),
        ),
      ),
      body: Column(
        children: [
          TopUserInfoWidget(
            user: user,
            isMainScreen: false,
          ),
          SizedBox(height: 100.h),
          worryState.isLoading // 로딩 상태일 때 표시
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.separated(
                    itemCount: worryState.worryList.length,
                    itemBuilder: (context, index) {
                      final worry = worryState.worryList[index]; // 서버에서 받아온 고민
                      return SizedBox(
                        width: 988.w,
                        height: 255.h,
                        child: OutlinedButton(
                          onPressed: () {
                            // 고민 선택 시 처리
                            setState(() {
                              selectedConcernIndex = index + 1;
                            });
                          },
                          style: ButtonStyle(
                            side: selectedConcernIndex == index + 1
                                ? MaterialStateProperty.all(
                                    const BorderSide(color: AppColors.blue),
                                  )
                                : MaterialStateProperty.all(
                                    const BorderSide(color: AppColors.white),
                                  ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            worry['content'], // 서버에서 받은 고민 내용 표시
                            style: selectedConcernIndex == index + 1
                                ? CustomTextStyle.p50(context)
                                    .copyWith(color: AppColors.blue)
                                : CustomTextStyle.p50w(context),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 100.h);
                    },
                  ),
                ),
          SizedBox(height: 100.h),
          ElevatedButton(
            onPressed: selectedConcernIndex > 0
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConcernDetailScreen(
                          concernTitle: worryState
                              .worryList[selectedConcernIndex - 1]['content'],
                          concernId: worryState
                              .worryList[selectedConcernIndex - 1]['id'],
                        ),
                      ),
                    );
                  }
                : null, // 선택된 고민이 없으면 버튼 비활성화
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              minimumSize: Size(900.w, 200.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text('다음', style: CustomTextStyle.p100(context)),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
