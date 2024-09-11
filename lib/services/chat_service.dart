import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String _baseUrl = 'http://flyingstone.me:3000';

  Future<Map<String, dynamic>> initializeChatInfo(String authToken) async {
    final url = Uri.parse('$_baseUrl/chat/threadId');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $authToken',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error loading chat info: $e');
    }
    return {};
  }

  Future<Map<String, dynamic>> sendMessage(String message, String? assistantId,
      String? threadId, String authToken) async {
    final url = Uri.parse('$_baseUrl/chat/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "message": message,
          "assistantId": assistantId,
          "threadId": threadId,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error sending message: $e');
    }
    return {};
  }

  Future<void> saveChatInfo(
      String assistantId, String threadId, String authToken) async {
    final url = Uri.parse('$_baseUrl/chat/threadId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "assistantId": assistantId,
          "threadId": threadId,
        }),
      );

      if (response.statusCode == 200) {
        print('Chat info saved successfully');
      } else {
        print('Failed to save chat info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving chat info: $e');
    }
  }
}
