import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/providers/auth_provider.dart';
import 'package:catch_flutter/providers/goal_provider.dart';
import 'package:catch_flutter/screens/concern_wish_manager_screen.dart';
import 'package:catch_flutter/services/notification_service.dart';
import 'package:catch_flutter/services/worry_service.dart'; // 서버와 통신할 WorryService 추가
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class ConcernDetailScreen extends ConsumerStatefulWidget {
  final String concernTitle;
  final int concernId; // 선택된 고민의 ID 추가

  const ConcernDetailScreen({
    required this.concernTitle,
    required this.concernId, // 고민 ID 받기
    super.key,
  });

  @override
  ConsumerState<ConcernDetailScreen> createState() =>
      _ConcernDetailScreenState();
}

class _ConcernDetailScreenState extends ConsumerState<ConcernDetailScreen> {
  var idToken;
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day + 4, 23, 59, 59);
  DateTime _selectedTime = DateTime.now().add(const Duration(minutes: 5));

  var goal;
  String goalTitle = "목표를 불러오는 중...";
  late final WorryService _worryService; // WorryService를 한 번만 생성

  @override
  void initState() {
    super.initState();
    _worryService = WorryService(); // 한 번만 인스턴스 생성
    _loadRandomGoal(); // 화면 초기화 시 랜덤 목표 불러오기
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 사용자 정보 초기화 (ref.read를 사용하여 한 번만 읽음)
    idToken ??= ref.read(authProvider.notifier).idToken;
  }

  // 서버에서 랜덤 목표를 불러오는 함수
  Future<void> _loadRandomGoal() async {
    goal = await _worryService.fetchRandomGoal(widget.concernId);

    if (goal != null && mounted) {
      setState(() {
        goalTitle = goal['content'];
      });
    }
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      helpText: "날짜 선택",
      locale: const Locale('ko', ''),
      barrierColor: Colors.black,
    );
    if (picked != null &&
        picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              '고민 세부 관리',
              style: CustomTextStyle.p60w(context),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 945.w,
              height: 141.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(widget.concernTitle,
                  style: CustomTextStyle.p50w(context)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "알람 및 앱 푸시 시간 설정",
                    style: CustomTextStyle.p60(context)
                        .copyWith(color: Colors.grey),
                  ),
                  Image.asset(
                    'assets/images/03_main_refresh.png',
                    width: 73.w,
                    height: 88.h,
                  )
                ],
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              _buildTimePicker(),
            ]),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "목표 기간 설정",
                    style: CustomTextStyle.p60(context)
                        .copyWith(color: Colors.grey),
                  ),
                  Image.asset(
                    'assets/images/03_main_refresh.png',
                    width: 73.w,
                    height: 88.h,
                  )
                ],
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              _buildDateSelector(context),
            ]),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildGoalSection(context), // 목표 섹션에 서버에서 받아온 랜덤 목표를 반영
                SizedBox(height: 20.h),
                _buildNotificationOptions(context),
              ],
            ),
          ),
          const Spacer(),
          _buildActionButton(context, "결정"),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  _buildTimePicker() {
    return Row(
      children: [
        Expanded(
            child: TimePickerSpinner(
          locale: const Locale('ko', 'kr'),
          time: _selectedTime,
          is24HourMode: false,
          itemHeight: 200.h,
          normalTextStyle:
              CustomTextStyle.p120(context).copyWith(color: Colors.grey),
          highlightedTextStyle: CustomTextStyle.p120w(context),
          itemWidth: 200.w,
          alignment: Alignment.center,
          isForce2Digits: true,
          onTimeChange: (time) {
            setState(() {
              _selectedTime = time;
              print(time);
            });
          },
        )),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${DateFormat('MM월 dd일 (E)', 'ko').format(_startDate)} - ${DateFormat('MM월 dd일 (E)', 'ko').format(_endDate)}",
                style: CustomTextStyle.p40w(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_endDate.difference(_startDate).inDays}일 후 종료",
                    style: CustomTextStyle.p40(context)
                        .copyWith(color: AppColors.pink),
                  ),
                  Text("| 총 ${_endDate.difference(_startDate).inDays + 1}일",
                      style: CustomTextStyle.p25w(context)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 100.w),
        InkWell(
          onTap: _selectDateRange,
          child: Image.asset(
            'assets/images/03_main_calendar.png',
            width: 95.w,
            height: 90.h,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "다리 추천 목표",
              style: CustomTextStyle.p60(context).copyWith(color: Colors.grey),
            ),
            InkWell(
              onTap: _loadRandomGoal, // 목표 새로고침을 위해 클릭 시 서버에서 새 목표 불러오기
              child: Image.asset(
                'assets/images/03_main_refresh.png',
                width: 73.w,
                height: 88.h,
              ),
            )
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            goalTitle, // 서버에서 받아온 목표를 표시
            style: CustomTextStyle.p70w(context),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationOptions(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "관리 방식",
              style: CustomTextStyle.p60(context).copyWith(color: Colors.grey),
            ),
            Image.asset(
              'assets/images/03_main_alarmbell_01.png',
              width: 73.w,
              height: 88.h,
            )
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "알람+앱 푸시",
              style: CustomTextStyle.p50(context).copyWith(color: Colors.grey),
            ),
            Text(
              "알람만",
              style: CustomTextStyle.p50(context).copyWith(color: Colors.grey),
            ),
            Text(
              "앱 푸시만",
              style: CustomTextStyle.p50(context).copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        final worryId = widget.concernId;
        final goalId = goal['id'];
        final startDate = _startDate.toString();
        final endDate = _endDate.toString();

        final hour = _selectedTime.hour.toString().padLeft(2, '0'); // 2자리 시간
        final minute = _selectedTime.minute.toString().padLeft(2, '0'); // 2자리 분

        ref.read(goalProvider.notifier).saveUserGoal(
            idToken, worryId, goalId, startDate, endDate, '$hour:$minute:00');

        final NotificationService noti = NotificationService();

        noti.scheduleRepeatingTextNotification(
            '목표: $goalTitle',
            '오늘의 목표를 위해 힘써보아요.',
            _startDate,
            _endDate,
            TimeOfDay.fromDateTime(_selectedTime),
            noti.generateNotificationId());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ConcernWishManagerScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        minimumSize: Size(900.w, 200.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text('결정', style: CustomTextStyle.p100(context)),
    );
  }
}
