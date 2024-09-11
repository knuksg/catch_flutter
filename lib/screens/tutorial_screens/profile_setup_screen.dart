import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/constatnts.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/providers/auth_provider.dart';
import 'package:catch_flutter/screens/main_screen.dart';
import 'package:catch_flutter/widgets/tutorial_emoticon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen>
    with TickerProviderStateMixin {
  var user;
  late AnimationController _controller;
  bool isPopupOpen = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String profileImage = '';

  List<List<Map<String, dynamic>>> daryTexts = [
    [
      {'text': '캐치', 'color': AppColors.pink},
      {'text': '에 처음 놀러온 걸 환영해\n내 이름은 ', 'color': AppColors.black},
      {'text': '다리', 'color': AppColors.pink},
      {'text': '라고 해.', 'color': AppColors.black}
    ],
    [
      {'text': '나는 ', 'color': AppColors.black},
      {'text': 'AI 어시스턴트', 'color': AppColors.pink},
      {'text': '로\n', 'color': AppColors.black},
      {'text': '너의 고민', 'color': AppColors.blue},
      {'text': '들을 듣고', 'color': AppColors.black}
    ],
    [
      {'text': '작은 목표를 세우고 \n필요한 정보들을 줄 거야.', 'color': AppColors.black},
    ],
    [
      {'text': '작은 도움을 주는 친한\n친구처럼 생각해 주길 바라.', 'color': AppColors.black},
    ],
    [
      {'text': '이제 간단한 내 소개는 끝났고\n너를 소개할 시간이야.', 'color': AppColors.black},
    ],
    [
      {'text': '첫만남이라 개인의\n자세한 정보는 차차 물어볼게.', 'color': AppColors.black},
    ],
    [
      {'text': '그럼 지금부터 함께\n', 'color': AppColors.white},
      {'text': '프로필 작성', 'color': Colors.yellow},
      {'text': '을 시작해 볼까?', 'color': AppColors.white},
    ],
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 광고 시간 컨트롤러
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 이미 초기화된 경우 초기화를 건너뜀
    user ??= ref.watch(authProvider);
  }

  void _nextPage() {
    if (_currentPage < 7) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      String mbtiString = '';

      if (selectedMbtiIndex[0] == 1) {
        mbtiString += mbtiTexts[0][3];
      } else if (selectedMbtiIndex[0] == 2) {
        mbtiString += mbtiTexts[1][3];
      }
      if (selectedMbtiIndex[1] == 1) {
        mbtiString += mbtiTexts[2][3];
      } else if (selectedMbtiIndex[1] == 2) {
        mbtiString += mbtiTexts[3][3];
      }
      if (selectedMbtiIndex[2] == 1) {
        mbtiString += mbtiTexts[4][3];
      } else if (selectedMbtiIndex[2] == 2) {
        mbtiString += mbtiTexts[5][3];
      }
      if (selectedMbtiIndex[3] == 1) {
        mbtiString += mbtiTexts[6][3];
      } else if (selectedMbtiIndex[3] == 2) {
        mbtiString += mbtiTexts[7][3];
      }

      ref.read(authProvider.notifier).updateUserInfo(
            profileImg: profileImage,
            nickname: isNicknameSameAsId
                ? user!.email
                : nicknameTexts[selectedNicknameIndex - 1],
            gender: selectedGenderIndex == 1 ? 'Male' : 'Female',
            age: ageTexts[selectedAgeIndex - 1],
            height: heightTexts[selectedHeightIndex - 1],
            weight: weightTexts[selectedWeightIndex - 1],
            mbti: mbtiString,
            bloodType: mbtiString != '' || selectedBloodTypeIndex == 4
                ? 'Other'
                : bloodTypeTexts[selectedBloodTypeIndex - 1][0],
          );

      print('profileImage: $profileImage');
      print(
          'nickname: ${isNicknameSameAsId ? user!.email : nicknameTexts[selectedNicknameIndex - 1]}');
      print('gender: ${selectedGenderIndex == 1 ? 'Male' : 'Female'}');
      print('age: ${ageTexts[selectedAgeIndex - 1]}');
      print('height: ${heightTexts[selectedHeightIndex - 1]}');
      print('weight: ${weightTexts[selectedWeightIndex - 1]}');
      print('mbti: $mbtiString');
      print(
          'bloodType: ${mbtiString != '' || selectedBloodTypeIndex == 4 ? 'Other' : bloodTypeTexts[selectedBloodTypeIndex - 1][0]}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double animationValue = _controller.value;
    // double animationValue = 0.1;
    // animationValue에 따라 텍스트 인덱스를 결정
    int textIndex = ((animationValue - 0.05) * daryTexts.length).floor();
    textIndex = textIndex.clamp(0, daryTexts.length - 1);

    // 선택된 텍스트 목록
    List<Map<String, dynamic>> selectedTexts = daryTexts[textIndex];

    if (animationValue >= 1.0) {
      isPopupOpen = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/03_main_bg.png',
              fit: BoxFit.cover,
            ),
          ),
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

          if (animationValue >= 0.05 && animationValue < 1.0)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 200.h,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 772.w, // 이미지의 너비를 명시적으로 설정
                  height: 445.h, // 이미지의 높이를 명시적으로 설정
                  child: Stack(
                    children: [
                      if (animationValue >= 0.05 &&
                          textIndex != daryTexts.length - 1)
                        Image.asset(
                          'assets/images/03_main_text_balloon.png',
                          fit: BoxFit.contain, // 이미지가 SizedBox의 크기에 맞게 조정됨
                          width: 772.w,
                          height: 445.h,
                        ),
                      if (textIndex == daryTexts.length - 1)
                        Image.asset(
                          'assets/images/03_main_qtext_balloon.png',
                          fit: BoxFit.contain, // 이미지가 SizedBox의 크기에 맞게 조정됨
                          width: 772.w,
                          height: 445.h,
                        ),
                      Align(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: selectedTexts.map((textData) {
                                return TextSpan(
                                  text: textData['text'],
                                  style: CustomTextStyle.p50(context).copyWith(
                                    color: textData['color'],
                                  ),
                                );
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),

          if (isPopupOpen)
            // 반투명 배경
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.8)),
            ),
          if (isPopupOpen)
            // 프로필 설정 페이지들
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
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    buildWelcomePage(),
                    buildProfileImagePage(),
                    buildProfileNicknamePage(),
                    buildProfileGenderAndAgePage(),
                    buildProfileHeightPage(),
                    buildProfileWeightPage(),
                    selectedAgeIndex < 5
                        ? buildProfileMBTIPage()
                        : buildProfileBloodTypePage(),
                    buildConfirmationPage(),
                  ],
                ),
              ),
            ),
          if (isPopupOpen)
            // 상단 로고
            Positioned(
              top: 80.h,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: _nextPage,
                child: Image.asset(
                  'assets/images/03_main_profile_register_icon.png', // 로고 이미지 경로
                  width: 455.w,
                  height: 455.w,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildWelcomePage() {
    return Column(
      children: [
        SizedBox(height: 300.h),
        Text(
          '구글아이디님의',
          style: CustomTextStyle.p80(context).copyWith(color: Colors.blue),
          textAlign: TextAlign.center,
        ),
        Text(
          '정보가 필요해요',
          style: CustomTextStyle.p100(context),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 200.h),
        Text(
          '원활한 서비스를 위해\n신규 프로필 작성을\n요청해도 될까요?',
          textAlign: TextAlign.center,
          style: CustomTextStyle.n80(context),
        ),
        const Spacer(),
        Text(
          '* 작성 완료된 프로필 상의 개인정보들은 캐치 서비스의 정보수집을 위해서만 사용됩니다.',
          textAlign: TextAlign.center,
          style: CustomTextStyle.n45(context).copyWith(color: Colors.red),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            minimumSize: Size(900.w, 200.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text('좋아요', style: CustomTextStyle.p100w(context)),
        ),
      ],
    );
  }

  Widget buildProfileImagePage() {
    return Column(
      children: [
        SizedBox(height: 300.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '프로필 작성',
              style: CustomTextStyle.p80(context).copyWith(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 10),
            Text(
              '| 01 이미지 선택',
              style: CustomTextStyle.p35(context).copyWith(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 프로필 이미지 선택 옵션 표시
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedProfileImageIndex = index + 1;
                  profileImage =
                      'assets/images/03_main_user_char_0${index + 1}.png';
                });
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 120.w,
                    backgroundImage: AssetImage(
                      'assets/images/03_main_user_char_0${index + 1}.png',
                    ),
                  ),
                  if (selectedProfileImageIndex == index + 1)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const Spacer(),
        Text(
          '* 프로필 관리에서 촬영한 사진이나 갤러리를 통해 프로필 이미지 수정이 가능합니다.',
          textAlign: TextAlign.center,
          style: CustomTextStyle.n45(context).copyWith(color: Colors.red),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedProfileImageIndex == 0 ? null : _nextPage,
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
    );
  }

  Widget buildProfileNicknamePage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 300.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 작성',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Text(
                '| 02 닉네임 선택',
                style:
                    CustomTextStyle.p35(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: () {
              setState(() {
                isNicknameSameAsId = !isNicknameSameAsId;
                if (isNicknameSameAsId) {
                  selectedNicknameIndex = 0;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    activeColor: Colors.blue,
                    value: isNicknameSameAsId,
                    onChanged: (onChanged) {
                      setState(() {
                        isNicknameSameAsId = onChanged!;
                        if (isNicknameSameAsId) {
                          selectedNicknameIndex = 0;
                        }
                      });
                    }),
                Text('현재 아이디를 닉네임으로 사용',
                    style: isNicknameSameAsId
                        ? CustomTextStyle.p50(context)
                            .copyWith(color: AppColors.blue)
                        : CustomTextStyle.p50(context))
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // 사용자 정보 입력 필드 표시
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 한 줄에 2개의 버튼
                crossAxisSpacing: 30.0.w, // 버튼 간의 수평 간격
                mainAxisSpacing: 30.0.h, // 버튼 간의 수직 간격
                childAspectRatio: 3.0, // 버튼의 가로:세로 비율
                children: List.generate(8, (index) {
                  return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(300.w, 100.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNicknameIndex = index + 1;
                          isNicknameSameAsId = false;
                        });
                      },
                      child: Text(
                        nicknameTexts[index],
                        style: selectedNicknameIndex == index + 1
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      ));
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedNicknameIndex == 0 && !isNicknameSameAsId
                ? null
                : _nextPage,
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
    );
  }

  Widget buildProfileGenderAndAgePage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 300.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 작성',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Text(
                '| 03 추가 정보 선택',
                style:
                    CustomTextStyle.p35(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text('성별', style: CustomTextStyle.p50(context))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedGenderIndex = 1;
                        });
                      },
                      child: Text(
                        genderTexts[0],
                        style: selectedGenderIndex == 1
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                  const SizedBox(width: 20),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedGenderIndex = 2;
                        });
                      },
                      child: Text(
                        genderTexts[1],
                        style: selectedGenderIndex == 2
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                ],
              ),
            ],
          ),

          SizedBox(height: 50.h),
          // 사용자 정보 입력 필드 표시
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '연령층',
                        style: CustomTextStyle.p50(context),
                      ),
                      Text(
                        '| 대',
                        style: CustomTextStyle.p30(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3, // 한 줄에 3개의 버튼
                            crossAxisSpacing: 30.0.w, // 버튼 간의 수평 간격
                            mainAxisSpacing: 30.0.h, // 버튼 간의 수직 간격
                            childAspectRatio: 2.0, // 버튼의 가로:세로 비율
                            children: List.generate(6, (index) {
                              return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(300.w, 100.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedAgeIndex = index + 1;
                                    });
                                  },
                                  child: Text(
                                    ageTexts[index],
                                    style: index == selectedAgeIndex - 1
                                        ? CustomTextStyle.p50(context)
                                            .copyWith(color: AppColors.blue)
                                        : CustomTextStyle.p50(context),
                                  ));
                            }),
                          ),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(900.w, 150.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedAgeIndex = 7;
                              });
                            },
                            child: Text(
                              ageTexts[6],
                              style: selectedAgeIndex == 7
                                  ? CustomTextStyle.p50(context)
                                      .copyWith(color: AppColors.blue)
                                  : CustomTextStyle.p50(context),
                            )),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedGenderIndex == 0 || selectedAgeIndex == 0
                ? null
                : _nextPage,
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
    );
  }

  Widget buildProfileHeightPage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 300.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 작성',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Text(
                '| 03 추가 정보 선택',
                style:
                    CustomTextStyle.p35(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          SizedBox(height: 20.h),
          // 사용자 정보 입력 필드 표시
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '신장',
                        style: CustomTextStyle.p50(context),
                      ),
                      Text(
                        '| cm',
                        style: CustomTextStyle.p30(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3, // 한 줄에 3개의 버튼
                            crossAxisSpacing: 30.0.w, // 버튼 간의 수평 간격
                            mainAxisSpacing: 30.0.h, // 버튼 간의 수직 간격
                            childAspectRatio: 2.0, // 버튼의 가로:세로 비율
                            children: List.generate(9, (index) {
                              return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(300.w, 100.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedHeightIndex = index + 1;
                                    });
                                  },
                                  child: Text(
                                    heightTexts[index],
                                    style: index == selectedHeightIndex - 1
                                        ? CustomTextStyle.p50(context)
                                            .copyWith(color: AppColors.blue)
                                        : CustomTextStyle.p50(context),
                                  ));
                            }),
                          ),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(900.w, 150.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedHeightIndex = 10;
                              });
                            },
                            child: Text(
                              heightTexts[9],
                              style: selectedHeightIndex == 10
                                  ? CustomTextStyle.p50(context)
                                      .copyWith(color: AppColors.blue)
                                  : CustomTextStyle.p50(context),
                            )),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedHeightIndex == 0 ? null : _nextPage,
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
    );
  }

  Widget buildProfileWeightPage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 300.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 작성',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Text(
                '| 03 추가 정보 선택',
                style:
                    CustomTextStyle.p35(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          SizedBox(height: 20.h),
          // 사용자 정보 입력 필드 표시
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '체중',
                        style: CustomTextStyle.p50(context),
                      ),
                      Text(
                        '| kg',
                        style: CustomTextStyle.p30(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3, // 한 줄에 3개의 버튼
                            crossAxisSpacing: 30.0.w, // 버튼 간의 수평 간격
                            mainAxisSpacing: 30.0.h, // 버튼 간의 수직 간격
                            childAspectRatio: 2.0, // 버튼의 가로:세로 비율
                            children: List.generate(9, (index) {
                              return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(300.w, 100.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedWeightIndex = index + 1;
                                    });
                                  },
                                  child: Text(
                                    weightTexts[index],
                                    style: index == selectedWeightIndex - 1
                                        ? CustomTextStyle.p50(context)
                                            .copyWith(color: AppColors.blue)
                                        : CustomTextStyle.p50(context),
                                  ));
                            }),
                          ),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(900.w, 150.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedWeightIndex = 10;
                              });
                            },
                            child: Text(
                              weightTexts[9],
                              style: selectedWeightIndex == 10
                                  ? CustomTextStyle.p50(context)
                                      .copyWith(color: AppColors.blue)
                                  : CustomTextStyle.p50(context),
                            )),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedWeightIndex == 0 ? null : _nextPage,
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
    );
  }

  Widget buildProfileMBTIPage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 300.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 작성',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Text(
                '| 03 추가 정보 선택',
                style:
                    CustomTextStyle.p35(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MBTI', style: CustomTextStyle.p50(context))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[0] = 1;
                        });
                      },
                      child: Text(
                        mbtiTexts[0],
                        style: selectedMbtiIndex[0] == 1
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                  const SizedBox(width: 20),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[0] = 2;
                        });
                      },
                      child: Text(
                        mbtiTexts[1],
                        style: selectedMbtiIndex[0] == 2
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[1] = 1;
                        });
                      },
                      child: Text(
                        mbtiTexts[2],
                        style: selectedMbtiIndex[1] == 1
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                  const SizedBox(width: 20),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[1] = 2;
                        });
                      },
                      child: Text(
                        mbtiTexts[3],
                        style: selectedMbtiIndex[1] == 2
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[2] = 1;
                        });
                      },
                      child: Text(
                        mbtiTexts[4],
                        style: selectedMbtiIndex[2] == 1
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                  const SizedBox(width: 20),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[2] = 2;
                        });
                      },
                      child: Text(
                        mbtiTexts[5],
                        style: selectedMbtiIndex[2] == 2
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[3] = 1;
                        });
                      },
                      child: Text(
                        mbtiTexts[6],
                        style: selectedMbtiIndex[3] == 1
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                  const SizedBox(width: 20),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(400.w, 150.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMbtiIndex[3] = 2;
                        });
                      },
                      child: Text(
                        mbtiTexts[7],
                        style: selectedMbtiIndex[3] == 2
                            ? CustomTextStyle.p50(context)
                                .copyWith(color: AppColors.blue)
                            : CustomTextStyle.p50(context),
                      )),
                ],
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: selectedMbtiIndex[0] == 0 ||
                    selectedMbtiIndex[1] == 0 ||
                    selectedMbtiIndex[2] == 0 ||
                    selectedMbtiIndex[3] == 0
                ? null
                : _nextPage,
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
    );
  }

  Widget buildProfileBloodTypePage() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 300.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '프로필 작성',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Text(
                '| 03 추가 정보 선택',
                style:
                    CustomTextStyle.p35(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          SizedBox(height: 20.h),
          // 사용자 정보 입력 필드 표시
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '혈액형',
                        style: CustomTextStyle.p50(context),
                      ),
                      Text(
                        '| 유형 선택',
                        style: CustomTextStyle.p30(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 30.0.w, // 버튼 간의 수평 간격
                            mainAxisSpacing: 30.0.h, // 버튼 간의 수직 간격
                            childAspectRatio: 2.0, // 버튼의 가로:세로 비율
                            children: List.generate(4, (index) {
                              return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(300.w, 100.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedBloodTypeIndex = index + 1;
                                    });
                                  },
                                  child: Text(
                                    bloodTypeTexts[index],
                                    style: selectedBloodTypeIndex == index + 1
                                        ? CustomTextStyle.p50(context)
                                            .copyWith(color: AppColors.blue)
                                        : CustomTextStyle.p50(context),
                                  ));
                            }),
                          ),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(900.w, 150.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedBloodTypeIndex = 5;
                              });
                            },
                            child: Text(
                              bloodTypeTexts[4],
                              style: selectedBloodTypeIndex == 5
                                  ? CustomTextStyle.p50(context)
                                      .copyWith(color: AppColors.blue)
                                  : CustomTextStyle.p50(context),
                            )),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedBloodTypeIndex == 0 ? null : _nextPage,
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
    );
  }

  Widget buildConfirmationPage() {
    return Center(
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 300.h),
              Text(
                isNicknameSameAsId == true || selectedNicknameIndex == 0
                    ? user.email + '님의'
                    : '${nicknameTexts[selectedNicknameIndex - 1]}님의',
                style:
                    CustomTextStyle.p80(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              Text(
                '프로필을 등록했어요',
                style:
                    CustomTextStyle.p100(context).copyWith(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '등록된 프로필은\n프로필 관리에서 수정이\n가능해요.(털실 사용)',
            style: CustomTextStyle.n80(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            '자 그러면 이제 다리와\n함께 이야기를 나눠볼까요?',
            style: CustomTextStyle.n80(context),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _nextPage,
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
    );
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(8, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
