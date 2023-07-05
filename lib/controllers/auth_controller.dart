import 'package:get/get.dart';

class AuthController extends GetxController {
  bool get isLoggedIn => false;

  void checkAuthStatus() {
    if (isLoggedIn) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
