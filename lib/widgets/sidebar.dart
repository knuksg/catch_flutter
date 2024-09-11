// sidebar.dart

import 'package:catch_flutter/core/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 961.w,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5), // 투명한 검은색 배경 설정
        ),
        child: Column(
          children: [
            Container(
                height: 170.h,
                alignment: Alignment.centerRight,
                child: IconButton(
                    iconSize: 100.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 70.h),
                    color: Colors.white,
                    onPressed: onPressed,
                    icon: const Icon(Icons.close))),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ListTile(
                      title: Text(
                        '프로필 관리',
                        style: CustomTextStyle.p60w(context),
                      ),
                      trailing: OutlinedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              Size(215.w, 75.h)), // 최소 크기 설정
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4)), // 패딩 설정
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.yellow)),
                        ),
                        onPressed: () {},
                        child: Text('로그아웃',
                            style: CustomTextStyle.p35w(context)
                                .copyWith(color: Colors.yellow)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(color: Colors.white),
                  ),
                  ListTile(
                    title: Text('닉네임 변경', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('변경', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title: Text('이미지 변경', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('변경', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title:
                        Text('기타 정보 변경', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('변경', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title:
                        Text('구독 취소 문의', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('문의', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ListTile(
                      title: Text(
                        '정보 수신 설정',
                        style: CustomTextStyle.p60w(context),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(color: Colors.white),
                  ),
                  ListTile(
                    title: Text('알람 설정', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('켜짐', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title: Text('알림 푸시', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('켜짐', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title: Text('문자 메시지', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.grey)),
                      ),
                      onPressed: () {},
                      child: Text('꺼짐',
                          style: CustomTextStyle.p35(context).copyWith(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  ListTile(
                    title: Text('이메일', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.grey)),
                      ),
                      onPressed: () {},
                      child: Text('꺼짐',
                          style: CustomTextStyle.p35(context).copyWith(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ListTile(
                      title: Text(
                        '약관 및 정보',
                        style: CustomTextStyle.p60w(context),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(color: Colors.white),
                  ),
                  ListTile(
                    title: Text('이용 약관', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('보기', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title:
                        Text('개인정보 처리방침', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('보기', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title:
                        Text('오픈소스 라이선스', style: CustomTextStyle.p45w(context)),
                    trailing: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(215.w, 75.h)), // 최소 크기 설정
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)), // 패딩 설정
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.white)),
                      ),
                      onPressed: () {},
                      child: Text('보기', style: CustomTextStyle.p35w(context)),
                    ),
                  ),
                  ListTile(
                    title: Text('앱 버전', style: CustomTextStyle.p45w(context)),
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
