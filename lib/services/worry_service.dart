import 'package:http/http.dart' as http;
import 'dart:convert';

class WorryService {
  static const String _baseUrl = 'http://flyingstone.me:3000';

  // 모든 고민 리스트를 서버에서 가져옴
  Future<List<dynamic>> fetchWorryList() async {
    final url = Uri.parse('$_baseUrl/worry/list');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body); // 고민 리스트를 반환
      }
    } catch (e) {
      print('Error loading worry list: $e');
    }
    return [];
  }

  // 특정 고민과 관련된 랜덤 목표를 서버에서 가져옴
  Future<Map<String, dynamic>?> fetchRandomGoal(int worryId) async {
    final url = Uri.parse('$_baseUrl/worry/$worryId/goals');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body); // 랜덤 목표 반환
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching random goal: $e');
      return null;
    }
  }
}
