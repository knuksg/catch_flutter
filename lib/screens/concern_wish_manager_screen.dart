import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/screens/concern_screens/concern_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConcernWishManagerScreen extends StatelessWidget {
  const ConcernWishManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 고민과 위시 탭 두 개
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.pink,
          leading: Container(
            padding: EdgeInsets.only(left: 80.0.w),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/03_main_back.png',
              ),
            ),
          ),
          flexibleSpace: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0.h), // 상태바와의 여백
              child: Text('고민/위시 관리', style: CustomTextStyle.p60w(context)),
            ),
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ConcernScreen(), // 고민 화면
                  WishScreen(), // 위시 화면
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: AppColors.black),
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('고민', style: CustomTextStyle.p60w(context)),
                      ],
                    ),
                  ),
                  Tab(
                    icon: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('위시',
                              style: CustomTextStyle.p60(context)
                                  .copyWith(color: Colors.grey)),
                          const SizedBox(width: 5),
                          const Icon(Icons.lock, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
                labelStyle: CustomTextStyle.p60w(context),
                unselectedLabelStyle: CustomTextStyle.p60(context),
                indicatorColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WishScreen extends StatelessWidget {
  const WishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '위시 관리',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text(
                      '위시가 없다.',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                  // 추가적인 위시 리스트 항목들
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 위시 추가 페이지로 이동
              },
              child: const Text('위시 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
