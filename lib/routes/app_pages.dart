import 'package:get/get.dart';
import 'package:paperflow_ui/modules/auth/bindings/auth.bindings.dart';
import 'package:paperflow_ui/modules/auth/view/login.view.dart';
import 'package:paperflow_ui/modules/auth/view/register.view.dart';
import 'package:paperflow_ui/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN_SCREEN,
      page: () => const LoginView(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: Routes.REGISTER_SCREEN,
      page: () => const RegisterView(),
      binding: RegisterBindings(),
    ),
  ];
}
