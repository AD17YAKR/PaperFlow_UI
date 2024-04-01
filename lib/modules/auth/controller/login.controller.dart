import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../services/api_service.dart';
import '../../home_page.dart';

class LoginController extends GetxController {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  RxBool passwordVisible = false.obs;

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<void> loginUser() async {
    try {
      final results = await apiService.loginUser(
          usernameController.text, passwordController.text);
      if (results.statusCode == 201 || results.statusCode == 200) {
        Get.offAll(() => const HomePage());
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    }
  }
}
