import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ApiHelper {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse("${AppConstants.apiBaseUrl}$endpoint"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed GET request: ${response.statusCode}");
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("${AppConstants.apiBaseUrl}$endpoint"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed POST request: ${response.statusCode}");
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("${AppConstants.apiBaseUrl}$endpoint"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed PUT request: ${response.statusCode}");
    }
  }

  static Future<void> delete(String endpoint) async {
    final response = await http.delete(Uri.parse("${AppConstants.apiBaseUrl}$endpoint"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed DELETE request: ${response.statusCode}");
    }
  }
}
