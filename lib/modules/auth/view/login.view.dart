import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/login.controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/colors.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 2.5),
            Column(
              children: [
                Image.asset(
                  'assets/pdfLogo.jpeg',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 2.5),
                Text(
                  'PaperFlow',
                  style: GoogleFonts.dancingScript(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: GoogleFonts.montserrat(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Obx(() {
                  return TextField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.montserrat(),
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.togglePassword();
                        },
                        child: Icon(
                          controller.passwordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: controller.passwordVisible.value,
                  );
                }),
                const SizedBox(
                  height: 32.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.loginUser(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(9.0),
                      backgroundColor: AppColors.buttonPrimary,
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.REGISTER_SCREEN);
              },
              child: const Text.rich(
                TextSpan(
                  text: "Don't Have an Account ? ",
                  children: [
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
