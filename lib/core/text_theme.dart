// lib/text_theme.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextStyle {
  static TextStyle n20(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'NanumSquare',
          fontSize: min(20.sp, 30),
        );
  }

  static TextStyle n25(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'NanumSquare',
          fontSize: min(25.sp, 35),
        );
  }

  static TextStyle n30(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'NanumSquare',
          fontSize: min(30.sp, 40),
        );
  }

  static TextStyle n35(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'NanumSquare',
          fontSize: min(35.sp, 45),
        );
  }

  static TextStyle n45(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'NanumSquare',
          fontSize: min(45.sp, 55),
        );
  }

  static TextStyle n80(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'NanumSquare',
          fontSize: min(80.sp, 100),
        );
  }

  static TextStyle p20(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(20.sp, 30),
        );
  }

  static TextStyle p25(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(25.sp, 35),
        );
  }

  static TextStyle p30(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(30.sp, 40),
        );
  }

  static TextStyle p35(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(35.sp, 45),
        );
  }

  static TextStyle p40(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(40.sp, 50),
        );
  }

  static TextStyle p42(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(42.sp, 52),
        );
  }

  static TextStyle p45(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(45.sp, 55),
        );
  }

  static TextStyle p50(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(50.sp, 60),
        );
  }

  static TextStyle p60(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(60.sp, 70),
        );
  }

  static TextStyle p70(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: min(70.sp, 80),
        );
  }

  static TextStyle p80(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: 80.sp,
        );
  }

  static TextStyle p100(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: 100.sp,
        );
  }

  static TextStyle p120(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: 120.sp,
        );
  }

  static TextStyle p150(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: 150.sp,
        );
  }

  static TextStyle n20w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'NanumSquare',
        fontSize: min(20.sp, 30),
        color: Colors.white);
  }

  static TextStyle n25w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'NanumSquare',
        fontSize: min(25.sp, 35),
        color: Colors.white);
  }

  static TextStyle n30w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'NanumSquare',
        fontSize: min(30.sp, 40),
        color: Colors.white);
  }

  static TextStyle n35w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'NanumSquare',
        fontSize: min(35.sp, 45),
        color: Colors.white);
  }

  static TextStyle p20w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace',
        fontSize: min(20.sp, 30),
        color: Colors.white);
  }

  static TextStyle p25w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace',
        fontSize: min(25.sp, 35),
        color: Colors.white);
  }

  static TextStyle p30w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace',
        fontSize: min(30.sp, 40),
        color: Colors.white);
  }

  static TextStyle p35w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace',
        fontSize: min(35.sp, 45),
        color: Colors.white);
  }

  static TextStyle p40w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace',
        fontSize: min(40.sp, 50),
        color: Colors.white);
  }

  static TextStyle p42w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 42.sp, color: Colors.white);
  }

  static TextStyle p45w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 45.sp, color: Colors.white);
  }

  static TextStyle p50w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 50.sp, color: Colors.white);
  }

  static TextStyle p60w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'PyeongChangPeace',
          fontSize: 60.sp,
          color: Colors.white,
        );
  }

  static TextStyle p70w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 70.sp, color: Colors.white);
  }

  static TextStyle p80w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 80.sp, color: Colors.white);
  }

  static TextStyle p100w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 100.sp, color: Colors.white);
  }

  static TextStyle p120w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 120.sp, color: Colors.white);
  }

  static TextStyle p150w(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontFamily: 'PyeongChangPeace', fontSize: 150.sp, color: Colors.white);
  }
}
