import 'package:get/get.dart';
import 'package:paperflow_ui/modules/auth/controller/login.controller.dart';
import 'package:paperflow_ui/modules/auth/controller/register.controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}
