import 'package:catch_flutter/core/exports.dart';
import 'package:catch_flutter/services/goal_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalState {
  final List<dynamic> userGoals;
  final bool isLoading;
  final bool goalSaved; // 새로운 목표 저장 여부 확인

  GoalState({
    required this.userGoals,
    required this.isLoading,
    required this.goalSaved,
  });

  // 상태 복사 메서드
  GoalState copyWith({
    List<dynamic>? userGoals,
    bool? isLoading,
    bool? goalSaved,
  }) {
    return GoalState(
      userGoals: userGoals ?? this.userGoals,
      isLoading: isLoading ?? this.isLoading,
      goalSaved: goalSaved ?? this.goalSaved,
    );
  }
}

class GoalNotifier extends StateNotifier<GoalState> {
  final GoalService _goalService;

  GoalNotifier(this._goalService)
      : super(GoalState(userGoals: [], isLoading: false, goalSaved: false));

  // 유저의 고민에 따른 목표 리스트 불러오기
  Future<void> loadUserGoals(String authToken) async {
    state = state.copyWith(isLoading: true); // 로딩 시작
    final userGoals = await _goalService.fetchUserGoals(authToken);
    state = state.copyWith(userGoals: userGoals, isLoading: false); // 로딩 끝
  }

  // 새로운 목표 저장
  Future<void> saveUserGoal(String authToken, int worryId, int goalId,
      String startDate, String endDate, String notificationTime) async {
    state = state.copyWith(isLoading: true); // 저장 시작
    final userGoals = await _goalService.saveUserGoal(
        authToken, worryId, goalId, startDate, endDate, notificationTime);
    state = state.copyWith(
        userGoals: userGoals, isLoading: false, goalSaved: true); // 저장 완료
  }

  // 새로운 목표 삭제
  Future<void> deleteUserGoal(String authToken, int userGoalId) async {
    state = state.copyWith(isLoading: true); // 삭제 시작
    final userGoals = await _goalService.deleteUserGoal(authToken, userGoalId);
    state = state.copyWith(
        userGoals: userGoals,
        isLoading: false,
        goalSaved: true); // 삭제 완료 후 리스트 업데이트
  }
}

final goalProvider = StateNotifierProvider<GoalNotifier, GoalState>((ref) {
  final goalService = GoalService();
  return GoalNotifier(goalService);
});
