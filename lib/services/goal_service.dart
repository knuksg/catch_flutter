import 'package:catch_flutter/core/exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoalService {
  static const String _baseUrl = 'http://flyingstone.me:3000';

  // 유저의 고민에 따른 목표 리스트를 서버에서 가져옴
  Future<List<dynamic>> fetchUserGoals(String authToken) async {
    final url = Uri.parse('$_baseUrl/users/goals');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        return json.decode(response.body); // 유저 목표 리스트 반환
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching user goals: $e');
    }
    return [];
  }

  // 유저의 고민에 따른 새로운 목표를 서버로 전송하여 저장
  Future<List<dynamic>> saveUserGoal(String authToken, int worryId, int goalId,
      String startDate, String endDate, String notificationTime) async {
    final url = Uri.parse('$_baseUrl/users/goal');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'worryId': worryId,
          'goalId': goalId,
          'startDate': startDate,
          'endDate': endDate,
          'notificationTime': notificationTime,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body)['userGoals']; // 유저 목표 리스트 반환
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error saving user goals: $e');
    }
    return [];
  }

  // 유저의 고민에 따른 목표을 서버에서 삭제
  Future<List<dynamic>> deleteUserGoal(String authToken, int userGoalId) async {
    final url = Uri.parse('$_baseUrl/users/goal/$userGoalId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['userGoals']; // 유저 목표 리스트 반환
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching user goals: $e');
    }
    return [];
  }
}
