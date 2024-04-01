import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:7227';

  Map<String, String> headersMap = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<dynamic> uploadPdf() async {
    const endPoint = '/pdf/upload';
    final finalUrl = baseUrl + endPoint;

    final accessToken = await _secureStorage.read(key: 'access_token');
    final headersMap = <String, String>{
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final request = http.MultipartRequest('POST', Uri.parse(finalUrl));
        request.headers.addAll(headersMap);
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path!),
        );

        final response = await request.send();
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
      debugPrint(e.toString());
      Get.snackbar('Error', 'File upload failed');
    }
  }

  Future<dynamic> loginUser(String username, String password) async {
    const endPoint = '/auth/login';
    final finalUrl = baseUrl + endPoint;
    print({username, password});
    final loginDetails = <String, dynamic>{
      'username': username,
      'password': password
    };

    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(loginDetails),
      );

      final Map<String, dynamic> result = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final String accessToken = result['access_token'];
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
      debugPrint(e.toString());
      Get.snackbar('Error', 'Login failed');
      return 'Not Working';
    }
  }

  Future<dynamic> registerUser(
      String username, String password, String email) async {
    const endPoint = '/auth/register';
    final finalUrl = baseUrl + endPoint;
    print({username, password, email});
    final registerDetail = <String, dynamic>{
      'username': username,
      'password': password,
      'email': email
    };

    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(registerDetail),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Registration Successful Please Login Now');
        return response;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Login failed');
      return 'Not Working';
    }
  }

  Future<dynamic> fetchUserDetails() async {
    const endPoint = '/user/details';
    final finalUrl = baseUrl + endPoint;

    final accessToken = await _secureStorage.read(key: 'access_token');
    final headersMap = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${accessToken!}'
    };

    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headersMap,
      );

      final result = jsonDecode(response.body);

      return result;
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Something failed');
      return 'Not Working';
    }
  }

  Future<dynamic> fetchPdfById(String id) async {
    final endPoint = '/pdf/$id';
    final finalUrl = baseUrl + endPoint;

    final accessToken = await _secureStorage.read(key: 'access_token');
    final headersMap = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${accessToken!}'
    };

    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headersMap,
      );
      final result = jsonDecode(response.body);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Something failed');
      return 'Not Working';
    }
  }

  Future<dynamic> addComment(String comment, String id) async {
    final endPoint = '/pdf/comment/$id';
    final finalUrl = baseUrl + endPoint;
    final commentDetail = <String, dynamic>{
      'comment': comment,
    };
    final accessToken = await _secureStorage.read(key: 'access_token');
    final headersMap = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${accessToken!}'
    };
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(commentDetail),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Failed');
      return 'Not Working';
    }
  }

  Future<dynamic> addNewUser(String userId, String pdfId) async {
    final endPoint = '/pdf/user/share/$pdfId';
    final finalUrl = baseUrl + endPoint;
    print('reaching here');

    final commentDetail = <String, dynamic>{'sharedUserId': userId};

    final accessToken = await _secureStorage.read(key: 'access_token');
    final headersMap = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${accessToken!}'
    };
    try {
      final response = await http.patch(
        Uri.parse(finalUrl),
        headers: headersMap,
        body: jsonEncode(commentDetail),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'User Added Successfully');
        return response;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Failed');
      return 'Not Working';
    }
  }

  Future<dynamic> getAllUsers() async {
    const endPoint = '/user/all';
    final finalUrl = baseUrl + endPoint;

    final accessToken = await _secureStorage.read(key: 'access_token');
    final headersMap = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${accessToken!}'
    };

    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headersMap,
      );

      final result = jsonDecode(response.body);

      return result;
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Something failed');
      return 'Not Working';
    }
  }
}
