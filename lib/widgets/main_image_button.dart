import 'dart:math';

import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButtonWidget extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const ImageButtonWidget(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // 버튼 클릭 시 실행할 동작
      child: SizedBox(
        width: min(250.w, 450.h),
        height: min(280.w, 350.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: min(250.w, 250.h),
              height: min(250.w, 220.h),
            ), // 이미지 표시
            SizedBox(height: 10.h), // 이미지와 텍스트 사이의 공간
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                text,
                style: CustomTextStyle.p25w(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ), // 텍스트 표시
          ],
        ),
      ),
    );
  }
}
