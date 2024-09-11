import 'package:catch_flutter/core/exports.dart';
import 'package:catch_flutter/providers/auth_provider.dart';
import 'package:catch_flutter/providers/goal_provider.dart';
import 'package:catch_flutter/screens/concern_screens/concern_select_screen.dart';
import 'package:catch_flutter/widgets/top_user_info.dart';

class ConcernScreen extends ConsumerStatefulWidget {
  const ConcernScreen({super.key});

  @override
  ConsumerState createState() => _ConcernScreenState();
}

class _ConcernScreenState extends ConsumerState<ConcernScreen> {
  var user;
  var idToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 사용자 정보 초기화
    user ??= ref.watch(authProvider);
    idToken ??= ref.read(authProvider.notifier).idToken;

    // 유저의 고민 리스트가 비어 있을 경우에만 서버에서 데이터를 가져옵니다.
    if (ref.read(goalProvider).userGoals.isEmpty) {
      // 상태 변경 작업을 위젯 트리 빌드 후에 수행
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(goalProvider.notifier).loadUserGoals(idToken); // 고민 리스트를 로드
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalState = ref.watch(goalProvider); // goalProvider의 상태를 구독
    final userGoals = goalState.userGoals; // 서버에서 받아온 유저의 목표 리스트
    print(userGoals); // 디버깅용

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          TopUserInfoWidget(
            user: user,
            isMainScreen: false,
          ),
          SizedBox(height: 100.h),
          Expanded(
            child: goalState.isLoading
                ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
                : ListView(
                    children: [
                      // 서버에서 받아온 유저 목표 리스트를 동적으로 생성
                      ...List.generate(userGoals.length, (index) {
                        final goal = userGoals[index]; // 각 목표 데이터
                        final isDone = goal['status'] == 'completed'; // 완료 여부
                        final isSuccess =
                            goal['completion_rate'] == 100; // 성공 여부

                        return Column(
                          children: [
                            SizedBox(
                              width: 988.w,
                              height: 389.h,
                              child: OutlinedButton(
                                onPressed: () {
                                  // ref
                                  //     .watch(goalProvider.notifier)
                                  //     .deleteUserGoal(
                                  //         idToken, goal['user_goal_id']);
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: 30.w, vertical: 30.h)),
                                  side: MaterialStateProperty.all(
                                    const BorderSide(color: Colors.white),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        isDone
                                            ? isSuccess
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        width: 41.w,
                                                        height: 336.h,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          color: AppColors.pink,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.w),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Container(
                                                        width: 41.w,
                                                        height: 336.h,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.w),
                                                    ],
                                                  )
                                            : const SizedBox.shrink(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              goal['goal_content'], // 목표 내용 표시
                                              style: isDone
                                                  ? isSuccess
                                                      ? CustomTextStyle.p60w(
                                                          context)
                                                      : CustomTextStyle.p60(
                                                              context)
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey)
                                                  : CustomTextStyle.p60w(
                                                      context),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      int.parse(goal['notification_time']
                                                                  .split(
                                                                      ':')[0]) <
                                                              12
                                                          ? '오전'
                                                          : '오후',
                                                      style:
                                                          CustomTextStyle.p50w(
                                                              context),
                                                    ),
                                                    SizedBox(width: 20.w),
                                                    Text(
                                                      goal['notification_time']
                                                          .toString()
                                                          .substring(0, 5),
                                                      style: isDone
                                                          ? CustomTextStyle
                                                                  .p100(context)
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey)
                                                          : CustomTextStyle
                                                              .p100w(context),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  goal[
                                                      'worry_content'], // 고민 내용 표시
                                                  style: CustomTextStyle.p30(
                                                          context)
                                                      .copyWith(
                                                          color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        isDone
                                            ? Image.asset(
                                                'assets/images/03_main_trash.png',
                                                width: 73.w,
                                              )
                                            : Image.asset(
                                                'assets/images/03_main_alarmbell_01.png',
                                                width: 73.w,
                                              ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              isDone
                                                  ? isSuccess
                                                      ? '목표 달성 성공'
                                                      : '목표 달성 실패'
                                                  : '${_calculateDaysRemaining(goal['start_date'], goal['end_date'])}일 후 종료',
                                              style: isDone
                                                  ? isSuccess
                                                      ? CustomTextStyle.p40(
                                                              context)
                                                          .copyWith(
                                                              color: AppColors
                                                                  .pink)
                                                      : CustomTextStyle.p40w(
                                                          context)
                                                  : CustomTextStyle.p40(context)
                                                      .copyWith(
                                                          color:
                                                              AppColors.pink),
                                            ),
                                            Text(
                                              '${goal['start_date'].toString().substring(5, 10)} - ${goal['end_date'].toString().substring(5, 10)}',
                                              style:
                                                  CustomTextStyle.p30(context)
                                                      .copyWith(
                                                          color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 100.h), // 구분자 추가
                          ],
                        );
                      }),
                      Column(
                        children: [
                          SizedBox(
                            width: 988.w,
                            height: 389.h,
                            child: OutlinedButton(
                              onPressed: () {
                                // 고민 정하기 버튼 동작
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ConcernSelectScreen()),
                                );
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  const BorderSide(color: Colors.white),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              child: Text(
                                '+ 고민 정하기',
                                style: CustomTextStyle.p50w(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // 남은 날짜 계산 함수
  int _calculateDaysRemaining(String startDate, String endDate) {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return end.difference(start).inDays;
  }
}
