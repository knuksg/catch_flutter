import 'package:catch_flutter/services/worry_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorryState {
  final List<dynamic> worryList;
  final bool isLoading;
  final Map<String, dynamic>? randomGoal;

  WorryState(
      {required this.worryList, required this.isLoading, this.randomGoal});

  // 상태 복사 메서드
  WorryState copyWith(
      {List<dynamic>? worryList,
      bool? isLoading,
      Map<String, dynamic>? randomGoal}) {
    return WorryState(
      worryList: worryList ?? this.worryList,
      isLoading: isLoading ?? this.isLoading,
      randomGoal: randomGoal ?? this.randomGoal,
    );
  }
}

class WorryNotifier extends StateNotifier<WorryState> {
  final WorryService _worryService;

  WorryNotifier(this._worryService)
      : super(WorryState(worryList: [], isLoading: false));

  // 고민 리스트 불러오기
  Future<void> loadWorryList() async {
    state = state.copyWith(isLoading: true); // 로딩 시작
    final worryList = await _worryService.fetchWorryList();
    state = state.copyWith(worryList: worryList, isLoading: false); // 로딩 끝
  }

  // 특정 고민에 관련된 랜덤 목표 불러오기
  Future<void> loadRandomGoal(int worryId) async {
    state = state.copyWith(isLoading: true); // 로딩 시작
    final randomGoal = await _worryService.fetchRandomGoal(worryId);
    state =
        state.copyWith(randomGoal: randomGoal, isLoading: false); // 랜덤 목표 로딩 완료
  }
}

final worryProvider = StateNotifierProvider<WorryNotifier, WorryState>((ref) {
  final worryService = WorryService();
  return WorryNotifier(worryService);
});
