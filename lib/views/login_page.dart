import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paperflow_ui/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paperflow_ui/utils/colors.dart';
import 'package:paperflow_ui/views/home_page.dart';
import 'package:paperflow_ui/views/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool passwordVisible = false;

  Future<void> loginUser() async {
    try {
      final results = await apiService.loginUser(
          usernameController.text, passwordController.text);
      if (results.statusCode == 201 || results.statusCode == 200) {
        Get.offAll(() => const HomePage());
        // Get.snackbar('Success', 'Login Successful');
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    }
  }

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
                  "PaperFlow",
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
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: GoogleFonts.montserrat(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.montserrat(),
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: Icon(
                        passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: passwordVisible,
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => loginUser(),
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
                Get.to(const RegisterPage());
              },
              child: const Text.rich(
                TextSpan(
                  text: "Don't Have an Account ? ",
                  children: [
                    TextSpan(
                      text: "Register",
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
