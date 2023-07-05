import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:7227';

  Map<String, String> headersMap = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Future<dynamic> loginUser(String username, String password) async {
    String endPoint = '/auth/login';
    String finalUrl = baseUrl + endPoint;

    Map<String, dynamic> loginDetails = {
      "username": username,
      "password": password
    };

    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(loginDetails),
      );

      Map<String, dynamic> result = jsonDecode(response.body);

      if (response.statusCode == 201) {
        String accessToken = result['access_token'];
        await _secureStorage.write(key: 'access_token', value: accessToken);
        var idk = await _secureStorage.read(key: 'access_token');
        // print("the token is ${idk}");
        return result;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      print(e);
      return "Not Working";
    }
  }
}
