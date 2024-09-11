// profile screen

import 'package:flutter/material.dart';

int selectedProfileImageIndex = 0;

List<String> nicknameTexts = [
  '귀신이고칼로리',
  '달려야하니',
  '추쿠하세요추쿠',
  '헬로퀴티나',
  '연쇄할인범',
  '배숙희라빈슨',
  '롯데월드컵',
  '짱구는옷말려',
];

bool isNicknameSameAsId = false;

int selectedNicknameIndex = 0;

List<String> genderTexts = ['남성', '여성', '기타'];

int selectedGenderIndex = 0;

List<String> ageTexts = [
  '10',
  '20',
  '30',
  '40',
  '50',
  '60',
  '70 이상',
];

int selectedAgeIndex = 0;

List<String> heightTexts = [
  '110 이하',
  '110',
  '120',
  '130',
  '140',
  '150',
  '160',
  '170',
  '180',
  '190 이상',
];

int selectedHeightIndex = 0;

List<String> weightTexts = [
  '40 이하',
  '40',
  '50',
  '60',
  '70',
  '80',
  '90',
  '100',
  '110',
  '120 이상',
];

int selectedWeightIndex = 0;

List<String> mbtiTexts = [
  '외향(E)',
  '내향(I)',
  '현실(S)',
  '직관(N)',
  '사고(T)',
  '감정(F)',
  '판단(J)',
  '인식(P)',
];

List<int> selectedMbtiIndex = [0, 0, 0, 0];

List<String> bloodTypeTexts = ['A형', 'B형', 'AB형', 'O형', '기타(OH, RH 등)'];

int selectedBloodTypeIndex = 0;

// concern screen

List<String> concernTexts = [
  '살이 너무 쪄서 고민이에요',
  '잠이 너무 안 와서 고민이에요',
  '우울해서 고민이에요',
  '너무 말라서 고민이에요'
];

int selectedConcernIndex = 0;

List<Map<String, dynamic>> concernMaps = [
  {
    'concern': '살이 너무 쪄서 고민이에요',
    'goal': '하루 1만보 걷기',
    'selectedTime': const TimeOfDay(hour: 15, minute: 0), // 오후 3시
    'selectedDate': {
      'start': DateTime(2022, 3, 1), // 시작 날짜
      'end': DateTime(2022, 3, 31), // 종료 날짜
    },
    'isDone': false,
    'isSuccess': false,
  },
  {
    'concern': '살이 너무 쪄서 고민이에요',
    'goal': '하루 1만보 걷기',
    'selectedTime': const TimeOfDay(hour: 15, minute: 0), // 오후 3시
    'selectedDate': {
      'start': DateTime(2022, 3, 1), // 시작 날짜
      'end': DateTime(2022, 3, 31), // 종료 날짜
    },
    'isDone': true,
    'isSuccess': true,
  },
  {
    'concern': '살이 너무 쪄서 고민이에요',
    'goal': '하루 1만보 걷기',
    'selectedTime': const TimeOfDay(hour: 15, minute: 0), // 오후 3시
    'selectedDate': {
      'start': DateTime(2022, 3, 1), // 시작 날짜
      'end': DateTime(2022, 3, 31), // 종료 날짜
    },
    'isDone': true,
    'isSuccess': false,
  }
];
