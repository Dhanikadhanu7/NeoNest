import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  // Base URL of your backend (ensure your backend is running at this URL)
  static const String baseUrl = "http://127.0.0.1:8000";

  // ==================== LOGIN ====================
 static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/user/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"success": true, "token": data["access_token"]};
    } else if (response.statusCode == 401) {
      return {"success": false, "message": "Invalid credentials"};
    } else {
      return {"success": false, "message": "Server error"};
    }
  }
 

  // ==================== REGISTER ====================
  static Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Register Error: $e");
      return {"success": false, "message": "Error connecting to server"};
    }
  }

  // ==================== CRY ANALYSIS ====================
  static Future<Map<String, dynamic>> analyzeCry(File audioFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/cry/analyze'));
      request.files.add(await http.MultipartFile.fromPath('file', audioFile.path));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      print("Cry Analysis Error: $e");
      return {"success": false, "message": "Error analyzing cry"};
    }
  }

  // ==================== SLEEP TRACKER ====================
  static Future<Map<String, dynamic>> trackSleep(String userId, String start, String end) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sleep/track'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "sleepStart": start, "sleepEnd": end}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Sleep Tracker Error: $e");
      return {"success": false, "message": "Error tracking sleep"};
    }
  }

  // ==================== LULLABY PLAYER ====================
  static Future<Map<String, dynamic>> playLullaby(String songId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lullaby/play'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"song": songId}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Lullaby Player Error: $e");
      return {"success": false, "message": "Error playing lullaby"};
    }
  }

  // ==================== CHATBOT ====================
  static Future<String> sendChatMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"message": message}),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['reply'] ?? "NeoNest Bot: No reply received";
      } else {
        return "NeoNest Bot: Failed to get reply";
      }
    } catch (e) {
      print("Chatbot Error: $e");
      return "NeoNest Bot: Error contacting server";
    }
  }

  // ==================== CONTEXT DATA ====================
  static Future<Map<String, dynamic>> fetchContextData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/context/data'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false, "message": "Failed to load context"};
      }
    } catch (e) {
      print("Context Data Error: $e");
      return {"success": false, "message": "Error fetching context"};
    }
  }
}
