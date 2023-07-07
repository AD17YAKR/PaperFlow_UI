import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:7227';

  Map<String, String> headersMap = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<dynamic> uploadPdf() async {
    String endPoint = '/pdf/upload';
    String finalUrl = baseUrl + endPoint;

    var access_token = await _secureStorage.read(key: 'access_token');
    Map<String, String> headersMap = {
      'Authorization': 'Bearer $access_token',
    };

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        var request = http.MultipartRequest('POST', Uri.parse(finalUrl));
        request.headers.addAll(headersMap);
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path!),
        );

        var response = await request.send();
        if (response.statusCode == 201) {
          // Successful upload
          Get.snackbar('Success', 'File uploaded successfully');
        } else {
          // Failed upload
          Get.snackbar('Error', 'File upload failed');
        }
      } else {
        // No file selected
        Get.snackbar('Error', 'No file selected');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'File upload failed');
    }
  }

  Future<dynamic> loginUser(String username, String password) async {
    String endPoint = '/auth/login';
    String finalUrl = baseUrl + endPoint;
    print({username, password});
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
        await _secureStorage.write(
          key: 'access_token',
          value: accessToken,
        );
        await _secureStorage.write(
          key: 'username',
          value: result['user']['username'],
        );
        await _secureStorage.write(
          key: 'email',
          value: result['user']['email'],
        );
        return response;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Login failed');
      return "Not Working";
    }
  }

  Future<dynamic> registerUser(
      String username, String password, String email) async {
    String endPoint = '/auth/register';
    String finalUrl = baseUrl + endPoint;
    print({username, password, email});
    Map<String, dynamic> registerDetail = {
      "username": username,
      "password": password,
      "email": email
    };

    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(registerDetail),
      );

      Map<String, dynamic> result = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Registration Successful Please Login Now");
        return response;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Login failed');
      return "Not Working";
    }
  }

  Future<dynamic> fetchUserDetails() async {
    String endPoint = '/user/details';
    String finalUrl = baseUrl + endPoint;

    var access_token = await _secureStorage.read(key: 'access_token');
    Map<String, String> headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${access_token!}"
    };

    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headersMap,
      );

      var result = jsonDecode(response.body);

      return result;
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something failed');
      return "Not Working";
    }
  }

  Future<dynamic> fetchPdfById(String id) async {
    String endPoint = '/pdf/${id}';
    String finalUrl = baseUrl + endPoint;

    var access_token = await _secureStorage.read(key: 'access_token');
    Map<String, String> headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${access_token!}"
    };

    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headersMap,
      );
      var result = jsonDecode(response.body);
      return result;
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something failed');
      return "Not Working";
    }
  }

  Future<dynamic> addComment(String comment, String id) async {
    String endPoint = '/pdf/comment/${id}';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> commentDetail = {
      "comment": comment,
    };
    var access_token = await _secureStorage.read(key: 'access_token');
    Map<String, String> headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${access_token!}"
    };
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(commentDetail),
      );

      Map<String, dynamic> result = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed');
      return "Not Working";
    }
  }

  Future<dynamic> addNewUser(String userId, String pdfId) async {
    String endPoint = '/pdf/user/share/${pdfId}';
    String finalUrl = baseUrl + endPoint;
    print("reaching here");

    Map<String, dynamic> commentDetail = {"sharedUserId": userId};

    var access_token = await _secureStorage.read(key: 'access_token');
    Map<String, String> headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${access_token!}"
    };
    try {
      final response = await http.patch(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(commentDetail),
      );

      Map<String, dynamic> result = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "User Added Successfully");
        return response;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed');
      return "Not Working";
    }
  }

  Future<dynamic> getAllUsers() async {
    String endPoint = '/user/all';
    String finalUrl = baseUrl + endPoint;

    var access_token = await _secureStorage.read(key: 'access_token');
    Map<String, String> headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${access_token!}"
    };

    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headersMap,
      );

      var result = jsonDecode(response.body);

      return result;
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something failed');
      return "Not Working";
    }
  }
}
