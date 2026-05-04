import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "<STAGING_BASE_URL>";

  static Future<ApiResponse?> getUserData(Map<String, String> requestData) async {

    final url = Uri.parse("$baseUrl/api/customer/user-login");

    try{
      final response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer <API_KEY>",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
      }, body: json.encode(requestData));

      return ApiResponse(responseCode: response.statusCode, responseBody: jsonDecode(response.body));
    }catch(e){
      return null;
    }
  }
}

class ApiResponse {
  final int responseCode;
  final Map<String, dynamic> responseBody;

  ApiResponse({required this.responseCode, required this.responseBody});
}