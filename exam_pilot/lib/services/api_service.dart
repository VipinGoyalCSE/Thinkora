import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ APNA NGROK URL YAHAN CHECK KARLENA
  static const String baseUrl = "https://balkiest-donnie-nonfluently.ngrok-free.dev";

  static Future<String> uploadPDF(String filePath, String category) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/upload"));
      request.fields['category'] = category.toLowerCase();
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers.addAll({"ngrok-skip-browser-warning": "true"});

      var response = await request.send();
      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // 🧠 UPDATED: Ab ye poori chat history backend ko bhej raha hai
  static Future<String> askAI(List<Map<String, String>> history) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat"),
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({
          "history": history // Sending the full list of messages
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        return "Server Error: ${response.statusCode}. Check if main.py is running.";
      }
    } catch (e) {
      print("Connection Error: $e");
      return "Connection Failed. Is Ngrok and Python Server Online?";
    }
  }
}