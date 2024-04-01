import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/api_service.dart';

class RegisterController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  RxBool passwordVisible = false.obs;
  final ApiService apiService = ApiService();
  bool isHidden = true;
  bool isEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<void> registerUser() async {
    try {
      final results = await apiService.registerUser(usernameController.text,
          passwordController.text, emailController.text);
      if (results.statusCode == 201 || results.statusCode == 200) {
        Get.back();
        Get.snackbar('Success', 'Registration Successful Please Login Now');
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    }
  }
}
