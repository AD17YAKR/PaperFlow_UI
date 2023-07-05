import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paperflow_ui/views/home_page.dart';
import 'package:paperflow_ui/views/login_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<String?> isLoggedIn() async {
    const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    String? accessToken = await _secureStorage.read(key: 'access_token');
    return accessToken;
  }

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    String? data = await isLoggedIn();
    await Future.delayed(const Duration(seconds: 2));
    print(data);
    if (data != null) {
      Get.to(HomePage());
    } else {
      Get.to(LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/pdf.json',
          frameRate: FrameRate(60),
          filterQuality: FilterQuality.high,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
        ),
      ),
    );
  }
}
